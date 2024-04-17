import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/preference.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/ui/login/page_login.dart';
import 'package:ku_animal_m/src/ui/login/user_controller.dart';
import 'package:ku_animal_m/src/ui/page_app.dart';
import 'package:package_info_plus/package_info_plus.dart';

class StartUp extends StatefulWidget {
  const StartUp({super.key});

  @override
  State<StartUp> createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(seconds: 2), () {}

    processRun();

    // Future.delayed(Duration.zero, () {
    //   debugPrint("[animal] 00000000");
    //   _initPackageInfo();

    //   debugPrint("[animal] 3333333");

    //   var id = Preference().getString("userId");
    //   var pw = Preference().getString("userPw");

    //   debugPrint("[animal] 44444");
    //   if (id.isEmpty || pw.isEmpty) {
    //     goLoginPage();
    //   } else {
    //     UserController.to
    //         .login(
    //             id: id,
    //             pw: pw,
    //             pushToken: AppController.to.fcmToken,
    //             deviceName: "",
    //             appVer: AppController.to.versionInfo)
    //         .then((value) {
    //       if (value) {
    //         Get.off(const PageApp());
    //       } else {
    //         goLoginPage();
    //       }
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Connectivity example app'),
      // ),
      // backgroundColor: ColorsEx.primaryColor,
      backgroundColor: Colors.white,
      // body: Center(child: Text('Connection Status: ${_connectionStatus.toString()}')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 130,
              child: Utils.ImageAsset("logo.png", width: 130, height: 130),
            ),
          ),
          // CircularProgressIndicator(),
          // Util.ImageAsset("login_bi_hand.png"),
          // Lottie.asset("assets/lottie/loading7.json"),
        ],
      ),
    );
  }

  _initPackageInfo() async {
    debugPrint("[animal] ::initPackageInfo before - (3)");

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppController.to.versionInfo = packageInfo.version;

    debugPrint("[animal] ::initPackageInfo after - (4)");
  }

  _initPlatformState() async {
    debugPrint("[animal] ::initPlatformState before - (5)");

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
      AppController.to.deviceName = deviceData["model"].toString();

      // print(deviceData);
    } on PlatformException {
      deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
    }

    debugPrint("[animal] ::initPlatformState after - (6)");
  }

  // android play store 버전 체크
  // Future<String> _getAndroidStoreVersion(PackageInfo packageInfo) async {
  // // https://play.google.com/store/apps/details?id=com.today25.kuanimalm.ku_animal_m
  // final id = packageInfo.packageName;
  // final uri = Uri.https("play.google.com", "/store/apps/details", {"id": "$id"});
  // final response = await http.get(uri);
  // if (response.statusCode != 200) {
  //   debugPrint('Can\'t find an app in the Play Store with the id: $id');
  //   return "";
  // }
  // final document = parse(response.body);
  // final elements = document.getElementsByClassName('hAyfc');
  // final versionElement = elements.firstWhere(
  //   (elm) => elm.querySelector('.BgcNfc').text == 'Current Version',
  // );
  // return versionElement.querySelector('.htlgb').text;
  // }

  // ios app store 버전 체크
  // Future<dynamic> _getiOSStoreVersion(PackageInfo packageInfo) async {
  //   final id = packageInfo.packageName;

  //   final parameters = {"bundleId": "$id"};

  //   var uri = Uri.https("itunes.apple.com", "/lookup", parameters);
  //   final response = await http.get(uri);

  //   if (response.statusCode != 200) {
  //     debugPrint('Can\'t find an app in the App Store with the id: $id');
  //     return "";
  //   }

  //   final jsonObj = json.decode(response.body);

  //   /* 일반 print에서 일정 길이 이상의 문자열이 들어왔을 때,
  //    해당 길이만큼 문자열이 출력된 후 나머지 문자열은 잘린다.
  //    debugPrint의 경우 일반 print와 달리 잘리지 않고 여러 행의 문자열 형태로 출력된다. */

  //   // debugPrint(response.body.toString());
  //   return jsonObj['results'][0]['version'];
  // }

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

  void goLoginPage() {
    debugPrint("[animal] ::goLoginPage before");

    UserController.to.logout();
    Get.off(PageLogin());

    debugPrint("[animal] ::goLoginPage after");
  }

  initPushToken() async {
    debugPrint("[animal] ::initPushToken after - (1)");

    String? pushToken = await FirebaseMessaging.instance.getToken();
    debugPrint("[animal] FirebaseMessaging.instance.getToken() : $pushToken");
    // Preference().setFcmToken(value);

    AppController.to.setFcmToken(pushToken ?? "");
    debugPrint("[animal] ::initPushToken end - (2)");
  }

  processRun() async {
    debugPrint("[animal] 스타트업::processRun() before");
    await initPushToken();
    await _initPackageInfo();
    await _initPlatformState();

    debugPrint("[animal] processRun::00000000 - (7)");

    var id = Preference().getString("userId");
    var pw = Preference().getString("userPw");

    debugPrint("[animal] processRun::1111111 - (8)");
    if (id.isEmpty || pw.isEmpty) {
      goLoginPage();
    } else {
      UserController.to
          .login(
              id: id,
              pw: pw,
              pushToken: AppController.to.fcmToken,
              deviceName: AppController.to.deviceName,
              appVer: AppController.to.versionInfo)
          .then((value) {
        if (value) {
          Get.off(const PageApp());
        } else {
          goLoginPage();
        }
      });
    }

    debugPrint("[animal] 스타트업::processRun() after");
  }
}
