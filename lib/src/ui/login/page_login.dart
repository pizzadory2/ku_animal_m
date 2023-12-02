import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ku_animal_m/src/common/preference.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/network/rest_client.dart';
import 'package:ku_animal_m/src/ui/login/user_controller.dart';
import 'package:ku_animal_m/src/ui/setting/page_setting.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({Key? key}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final TextEditingController _controllerID = TextEditingController();
  final TextEditingController _controllerPW = TextEditingController();

  @override
  void initState() {
    if (kDebugMode) {
      _controllerID.text = "admin";
      _controllerPW.text = "admin";
    }

    String ip = Preference().getString("ip");
    if (ip.isNotEmpty) {
      RestClient().updateDio(ip);
    }

    AppController.to.className = Preference().getString("className");
    AppController.to.classSeq = Preference().getString("classSeq");

    super.initState();
  }

  @override
  void dispose() {
    _controllerID.dispose();
    _controllerPW.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double tfHeight = 70;
    double loginHeight = 80;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            // width: double.maxFinite,
            width: double.infinity,
            decoration: const BoxDecoration(
              // image: DecorationImage(
              //     image: NetworkImage('이미지 주소'),
              //     fit: BoxFit.cover)),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/bg_login2.png"),
                // image: AssetImage("assets/images/bg_campus_01.jpg"),
                // image: AssetImage("assets/images/bg_space_03.jpg"),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Container(color: Colors.black.withOpacity(0.1)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   child: Utils.ImageAsset("ku_logo.png", width: 200, height: 200),
              // ),
              Container(
                color: Colors.grey,
                width: 300,
                height: tfHeight,
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: tfHeight,
                      // color: Colors.grey,
                      child: const Icon(Icons.person, color: Colors.white, size: 50),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controllerID,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: Colors.grey,
                width: 300,
                height: tfHeight,
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: tfHeight,
                      // color: Colors.grey,
                      child: const Icon(Icons.lock, color: Colors.white, size: 50),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controllerPW,
                        obscureText: true,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (AppController.to.serverUrl.isEmpty) {
                    Get.snackbar("서버IP를 입력해주세요.", "설정에서 서버IP를 입력해주세요.",
                        backgroundColor: Colors.pink[300], colorText: Colors.white);
                    return;
                  }

                  String id = _controllerID.text;
                  String pw = _controllerPW.text;
                  UserController.to.login(id: id, pw: pw).then((value) {
                    if (value) {
                      // Get.off(const PageHome(), transition: Transition.rightToLeft);
                    } else {
                      Get.snackbar("로그인 실패", "아이디와 비밀번호를 확인해주세요.",
                          backgroundColor: Colors.pink[300], colorText: Colors.white);
                    }
                  });
                },
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 300,
                    height: loginHeight,
                    color: Colors.black,
                    child: Text(
                      "LOGIN",
                      style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 30,
            right: 10,
            child: IconButton(
              onPressed: () {
                Get.to(const PageSetting());
              },
              icon: const Icon(Icons.settings, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
