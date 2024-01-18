import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ku_animal_m/src/common/preference.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/network/rest_client.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/login/user_controller.dart';
import 'package:ku_animal_m/src/ui/page_app.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({Key? key}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final TextEditingController _controllerID = TextEditingController();
  final TextEditingController _controllerPW = TextEditingController();

  bool _autoLogin = false;
  bool _isLoading = false;

  @override
  void initState() {
    // if (kDebugMode) {
    //   _controllerID.text = "admin";
    //   _controllerPW.text = "admin";
    // }

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
    double loginHeight = 50;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(top: 50, left: 40, right: 40),
              child: ListView(
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 130,
                        child: Utils.ImageAsset("logo.png", width: 130, height: 130),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        height: 25,
                        margin: const EdgeInsets.only(left: 5, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "logintoyouraccount".tr,
                          style: GoogleFonts.aBeeZee(fontSize: 17, color: Colors.grey[500]),
                        ),
                      ),
                      _buildInputText(controller: _controllerID, hint: "email or id".tr, icon: Icons.person),
                      const SizedBox(height: 10),
                      _buildInputText(controller: _controllerPW, hint: "password".tr, icon: Icons.lock, pw: true),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Checkbox(
                                value: _autoLogin,
                                onChanged: (value) {
                                  setState(() {
                                    _autoLogin = value ?? false;
                                  });
                                }),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  _autoLogin = !_autoLogin;
                                });
                              },
                              child: Center(
                                child: Text(
                                  "auto login".tr,
                                  style: GoogleFonts.aBeeZee(fontSize: 16, color: ColorsEx.primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          // Get.snackbar("서버IP를 입력해주세요.", "설정에서 서버IP를 입력해주세요.",
                          //     backgroundColor: Colors.pink[300], colorText: Colors.white);
                          // Get.snackbar("서버IP를 입력해주세요.", "설정에서 서버IP를 입력해주세요.",
                          //     backgroundColor: ColorsEx.primaryColor, colorText: Colors.white);
                          // Get.snackbar(
                          //   "서버IP를 입력해주세요.",
                          //   "설정에서 서버IP를 입력해주세요.",
                          // );
                          if (kDebugMode) {
                            Get.off(const PageApp());
                            return;
                          }

                          String id = _controllerID.text;
                          String pw = _controllerPW.text;

                          if (id.isEmpty) {
                            Get.snackbar("login failed".tr, "please input id".tr);
                            return;
                          }

                          if (pw.isEmpty) {
                            Get.snackbar("login failed".tr, "please input password".tr);
                            return;
                          }

                          // setState(() {
                          //   _isLoading = true;
                          // });

                          Utils.keyboardHide();

                          UserController.to
                              .login(
                                  id: id,
                                  pw: pw,
                                  pushToken: AppController.to.fcmToken,
                                  deviceName: "",
                                  appVer: AppController.to.versionInfo)
                              .then((value) {
                            if (value) {
                              if (_autoLogin) {
                                Preference().setString("userId", id);
                                Preference().setString("userPw", pw);
                              }

                              Get.off(const PageApp());
                              // Get.off(const PageHome(), transition: Transition.rightToLeft);
                            } else {
                              // Get.snackbar("login failed".tr, "아이디와 비밀번호를 확인해주세요.");

                              setState(() {
                                _isLoading = false;
                              });
                            }
                          });
                        },
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: loginHeight,
                            child: Text(
                              "signin".tr,
                              style:
                                  GoogleFonts.aBeeZee(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      // const Spacer(),
                      //_buildSignUp()
                    ],
                  ),
                ],
              ),
            ),
          ),
          WidgetFactory.loadingWidget(isLoading: _isLoading, title: "로그인 중입니다."),
        ],
      ),
    );
  }

  // Row _buildSignUp() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       // Text('first'.tr, style: GoogleFonts.aBeeZee(fontSize: 18)),
  //       Text('first'.tr),
  //       const SizedBox(width: 5),
  //       TextButton(
  //         onPressed: () {
  //           //
  //         },
  //         child: Text(
  //           "Create an account".tr,
  //           style: const TextStyle(color: ColorsEx.primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  _buildInputText({
    required TextEditingController controller,
    String hint = "",
    IconData? icon,
    bool pw = false,
  }) {
    double tfHeight = 50;

    return Container(
      height: tfHeight,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          icon != null
              ? SizedBox(
                  width: tfHeight - 5,
                  height: tfHeight,
                  // color: Colors.grey,
                  child: Icon(icon, color: Colors.grey[400], size: tfHeight - 20),
                )
              : Container(),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: pw,
              textInputAction: TextInputAction.next,
              // cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.aBeeZee(color: Colors.grey[400]),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
