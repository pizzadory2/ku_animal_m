import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/firebase_options.dart';
import 'package:ku_animal_m/src/binding/init_binding.dart';
import 'package:ku_animal_m/src/common/notification.dart';
import 'package:ku_animal_m/src/common/preference.dart';
import 'package:ku_animal_m/src/common/theme_ex.dart';
import 'package:ku_animal_m/src/language/languages.dart';
import 'package:ku_animal_m/src/ui/login/page_login.dart';
import 'package:ku_animal_m/src/ui/startup/start_up.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  // showFlutterNotification(message); // 백그라운드에서는 노티 띄우지 않음(두번 팝업됨)
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await notifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // foreground listen
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;
    // var androidNotiDetails = AndroidNotificationDetails(
    //   channel.id,
    //   channel.name,
    //   channelDescription: channel.description,
    // );
    // // var iOSNotiDetails = const IOSNotificationDetails();
    // // var details = NotificationDetails(android: androidNotiDetails, iOS: iOSNotiDetails);
    // var details = NotificationDetails(android: androidNotiDetails);
    // if (notification != null) {
    //   flutterLocalNotificationsPlugin.show(
    //     notification.hashCode,
    //     notification.title,
    //     notification.body,
    //     details,
    //   );
    // }
    showFlutterNotification(message);
  });

  ///gives you the messsage on which user taps
  ///and it opened the app from temminated state
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    debugPrint('fcm getInitialMessage, message : ${message?.data ?? ''}');
    if (message != null) {
      return;
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print(message);
  });
  //

  isFlutterLocalNotificationsInitialized = true;
}

// void showFlutterNotification(RemoteMessage message) {
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//   if (notification != null && android != null && !kIsWeb) {
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           //      one that already exists in example app.
//           icon: 'launcher_icon',
//         ),
//       ),
//     );
//   }
// }

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? rNoti = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (rNoti != null && android != null && !kIsWeb) {
    notifications.show(
      rNoti.hashCode,
      rNoti.title,
      rNoti.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          //      one that already exists in example app.
          icon: 'launcher_icon',
        ),
      ),
    );
  }
}

// void testNotification() {
//   flutterLocalNotificationsPlugin.show(
//     1,
//     "입고 알림",
//     "타미플루가 입고되었습니다.",
//     NotificationDetails(
//       android: AndroidNotificationDetails(
//         channel.id,
//         channel.name,
//         channelDescription: channel.description,
//         icon: 'launcher_icon',
//       ),
//     ),
//   );
// }

// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// bundle id : com.today25.kuanimalm.kuAnimalm
// ios app store connect Apple ID : 6497170054
// ios app store connect SKU : com.today25.kuanimalm.kuAnimalm.ios
// generate apk : flutter build apk --split-per-abi
// generate release apk : flutter build appbundle --release
// ios build : flutter build ipa
// ios build option : flutter build ipa --export-methodbuild/ios/archive/MyApp.xcarchive
// flutter pub run flutter_launcher_icons:main (런처아이콘 적용)
// gradle migration : https://docs.flutter.dev/release/breaking-changes/flutter-gradle-plugin-apply
// gradle migration : https://velog.io/@koyk0408/Fix-flutter-gradle-%EC%97%90%EB%9F%ACSupport-in-stable-release-3.16.0-Recommended-in-stable-release-3.19.0
// flutter 3.10 버전이면 업그레이드 해야한다(dart 3.0.6)
// flutter clean
// flutter pub cache clean
// flutter pub get
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // firebase crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  //

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await initNotification();
    await setupFlutterNotifications();
  }

  // get device token
  // String? deviceToken = await FirebaseMessaging.instance.getToken();
  // debugPrint('deviceToken: $deviceToken');

  await Preference().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KU Animal',
      // theme: ThemeData(
      //   primarySwatch: Colors.purple,
      // ),
      translations: Languages(),
      // locale: Get.deviceLocale,
      locale: const Locale('ko', 'KR'),
      fallbackLocale: const Locale('ko', 'KR'),
      theme: ThemeEx.light,
      // darkTheme: ThemeEx.dark,
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialBinding: InitBinding(),
      initialRoute: '/start_up',
      getPages: [
        GetPage(name: '/start_up', page: () => const StartUp()),
        GetPage(name: '/login', page: () => PageLogin()),
        // GetPage(name: '/qr', page: () => const PageQr()),
        // GetPage(name: '/home', page: () => const PageHome()),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
