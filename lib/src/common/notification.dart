import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final notifications = FlutterLocalNotificationsPlugin();

// https://github.com/MaikuB/flutter_local_notifications/tree/master/flutter_local_notifications/example/android/app/src/main/res
//1. 앱로드시 실행할 기본설정
initNotification() async {
  //안드로이드용 아이콘파일 이름
  // var androidSetting = AndroidInitializationSettings('app_icon');
  var androidSetting = AndroidInitializationSettings("launcher_icon");
  //launcher_icon

  //ios에서 앱 로드시 유저에게 권한요청하려면
  // var iosSetting = IOSInitializationSettings(
  //   requestAlertPermission: true,
  //   requestBadgePermission: true,
  //   requestSoundPermission: true,
  // );
  // final DarwinInitializationSettings initializationSettingsDarwin =
  //   DarwinInitializationSettings(
  //       onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  DarwinInitializationSettings ios = const DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  var initializationSettings = InitializationSettings(android: androidSetting, iOS: ios);
  await notifications.initialize(
    initializationSettings,
    //알림 누를때 함수실행하고 싶으면
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    // onSelectNotification: ((payload) async {
    //   if (payload != null) {
    //     debugPrint('notification payload: $payload');
    //   }
    //   // await Navigator.push(
    //   //   context,
    //   //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    //   // );
    // }),
  );
}

Future<void> initPlatformState() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  var deviceData = <String, dynamic>{};

  try {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // var deviceIdentifier = 'unknown';
      // var deviceInfo = DeviceInfoPlugin();
      // var androidInfo = await deviceInfo.androidInfo;
      // deviceIdentifier = androidInfo!;
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      print(deviceData.toString());
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }

    // AppController.to.deviceToken = deviceData["display"].toString();
    // AppController.to.deviceModelName = deviceData["model"].toString();

    // print(deviceData);
  } on PlatformException {
    deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
  }
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'systemFeatures': build.systemFeatures,
    'displaySizeInches': ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
    'displayWidthPixels': build.displayMetrics.widthPx,
    'displayWidthInches': build.displayMetrics.widthInches,
    'displayHeightPixels': build.displayMetrics.heightPx,
    'displayHeightInches': build.displayMetrics.heightInches,
    'displayXDpi': build.displayMetrics.xDpi,
    'displayYDpi': build.displayMetrics.yDpi,
    'serialNumber': build.serialNumber,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
}

makeDate(hour, min, sec) {
  var now = tz.TZDateTime.now(tz.local);
  var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, sec);
  if (when.isBefore(now)) {
    return when.add(Duration(days: 1));
  } else {
    return when;
  }
}
