import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/preference.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
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
          SizedBox(
            height: 130,
            child: Utils.ImageAsset("logo.png", width: 130, height: 130),
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

  void goLoginPage() {
    debugPrint("[animal] ::goLoginPage before");

    UserController.to.logout();
    Get.off(const PageLogin());

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

    debugPrint("[animal] processRun::00000000 - (5)");

    var id = Preference().getString("userId");
    var pw = Preference().getString("userPw");

    debugPrint("[animal] processRun::1111111 - (6)");
    if (id.isEmpty || pw.isEmpty) {
      goLoginPage();
    } else {
      UserController.to
          .login(
              id: id,
              pw: pw,
              pushToken: AppController.to.fcmToken,
              deviceName: "",
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
