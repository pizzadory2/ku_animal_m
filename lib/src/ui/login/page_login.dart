// ignore_for_file: must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ku_animal_m/src/common/preference.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/login/page_signup.dart';
import 'package:ku_animal_m/src/ui/login/user_controller.dart';
import 'package:ku_animal_m/src/ui/page_app.dart';

class PageLogin extends StatefulWidget {
  PageLogin({Key? key, this.id = "", this.pw = ""}) : super(key: key);
  String id = "";
  String pw = "";

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
    if (widget.id.isNotEmpty && widget.pw.isNotEmpty) {
      _controllerID.text = widget.id;
      _controllerPW.text = widget.pw;
    } else {
      _controllerID.text = "";
      _controllerPW.text = "";

      // if (kDebugMode) {
      //   _controllerID.text = "test17";
      //   _controllerPW.text = "1234567a!";
      // }
    }

    // String ip = Preference().getString("ip");
    // if (ip.isNotEmpty) {
    //   RestClient().updateDio(ip);
    // }

    // AppController.to.className = Preference().getString("className");
    // AppController.to.classSeq = Preference().getString("classSeq");

    super.initState();
  }

  @override
  void dispose() {
    _controllerID.dispose();
    _controllerPW.dispose();

    super.dispose();
  }

  // 스타일 정의 예시
  final primaryColor = const Color(0xFF679E7D); // 로고의 메인 그린 컬러

  Widget _buildMedicineLoginScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9), // 아주 연한 그린톤 배경
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. 로고 및 서비스 명칭
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, spreadRadius: 5)],
                ),
                child: Utils.ImageAsset("logo.png", width: 130, height: 130),
              ),
              const SizedBox(height: 24),
              Text(
                "동물의약품 통합관리 시스템",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor, letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Text("재고 및 근태 통합 관리", style: TextStyle(color: Colors.grey[600], fontSize: 14)),

              const SizedBox(height: 40),

              // 2. 로그인 카드 영역
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))
                  ],
                ),
                child: Column(
                  children: [
                    _buildMedicalTextField(Icons.badge_outlined, "사번 또는 아이디"),
                    const SizedBox(height: 16),
                    _buildMedicalTextField(Icons.lock_open_rounded, "비밀번호", isPassword: true),
                    const SizedBox(height: 16),
                    // 자동 로그인 & 아이디 저장
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (v) {},
                              activeColor: primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            Text("자동 로그인", style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("비밀번호 찾기", style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                        )
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 3. 로그인 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text("로그인",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 4. 하단 안내
              TextButton(
                onPressed: () {},
                child: Text(
                  "시스템 접속 권한 신청 (가입하기)",
                  style: TextStyle(color: Colors.grey[600], decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalTextField(IconData icon, String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF679E7D).withOpacity(0.7)),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF1F4F2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // 1. 상단 로고 영역 (여백을 넉넉히 주어 여유롭게 배치)
                const SizedBox(height: 100),
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Utils.ImageAsset("logo.png", width: 130, height: 130),
                  ),
                ),
                const SizedBox(height: 40),

                // 2. 웰컴 텍스트
                Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                ),
                const SizedBox(height: 8),
                Text("동물 의약품 관리시스템", style: TextStyle(color: Colors.grey[500])),
                const SizedBox(height: 40),
                // 3. 입력 폼 영역
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      // _buildInputText(
                      //     controller: _controllerID,
                      //     inputType: TextInputType.emailAddress,
                      //     hint: "email or id".tr,
                      //     icon: Icons.person),
                      // const SizedBox(height: 10),
                      // _buildInputText(controller: _controllerPW, hint: "password".tr, icon: Icons.lock, pw: true),
                      _buildTextField(Icons.person_outline, "아이디", false, _controllerID),
                      const SizedBox(height: 16),
                      _buildTextField(Icons.lock_outline, "비밀번호", true, _controllerPW),
                      const SizedBox(height: 10),
                      // 자동 로그인 영역
                      Row(
                        children: [
                          // SizedBox(
                          //   width: 24,
                          //   height: 24,
                          //   child: Checkbox(
                          //     value: _autoLogin,
                          //     onChanged: (v) {
                          //       setState(() {
                          //         _autoLogin = v ?? false;
                          //       });
                          //     },
                          //     activeColor: primaryColor,
                          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          //   ),
                          // ),
                          // const SizedBox(width: 8),
                          // GestureDetector(
                          //     behavior: HitTestBehavior.translucent,
                          //     onTap: () {
                          //       setState(() {
                          //         _autoLogin = !_autoLogin;
                          //       });
                          //     },
                          //     child: Text("자동 로그인", style: TextStyle(color: Colors.grey[600], fontSize: 14))),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => setState(() => _autoLogin = !_autoLogin),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    // ⭐ 체크 여부에 따라 배경색 변경
                                    color: _autoLogin ? const Color(0xFF679E7D) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: const Color(0xFF679E7D),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: _autoLogin ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "자동 로그인",
                                  style: TextStyle(color: Color(0xFF666666), fontSize: 14),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 30),

                      // 4. 로그인 버튼 (그림자 추가로 입체감 부여)
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            // Get.snackbar("서버IP를 입력해주세요.", "설정에서 서버IP를 입력해주세요.",
                            //     backgroundColor: Colors.pink[300], colorText: Colors.white);
                            // Get.snackbar("서버IP를 입력해주세요.", "설정에서 서버IP를 입력해주세요.",
                            //     backgroundColor: ColorsEx.primaryColor, colorText: Colors.white);
                            // Get.snackbar(
                            //   "서버IP를 입력해주세요.",
                            //   "설정에서 서버IP를 입력해주세요.",
                            // );
                            // if (kDebugMode) {
                            //   Get.off(const PageApp());
                            //   return;
                            // }

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
                                    deviceName: AppController.to.deviceName,
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: primaryColor.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text("Login", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const SizedBox(height: 20),
                      // 5. 하단 링크 (가입하기 강조)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("처음이신가요? ", style: TextStyle(color: Colors.grey)),
                          TextButton(
                            onPressed: () {
                              Get.to(PageSignup());
                            },
                            child: Text("가입하기", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          WidgetFactory.loadingWidget(isLoading: _isLoading, title: "로그인 중입니다."),
        ],
      ),
    );
  }

// 공통 입력창 위젯
  Widget _buildTextField(IconData icon, String hint, bool isPassword, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double loginHeight = 50;

    // return _buildMedicineLoginScreen();
    return _buildLoginScreen();

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
                      _buildInputText(
                          controller: _controllerID,
                          inputType: TextInputType.emailAddress,
                          hint: "email or id".tr,
                          icon: Icons.person),
                      const SizedBox(height: 10),
                      _buildInputText(controller: _controllerPW, hint: "password".tr, icon: Icons.lock, pw: true),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Checkbox(
                                checkColor: Colors.black, // 체크 표시 색
                                // fillColor: MaterialStateProperty.resolveWith((states) {
                                //   if (states.contains(MaterialState.selected)) {
                                //     return Colors.grey; // 체크 시 박스 배경
                                //   }
                                //   return Colors.white; // 기본 박스 배경
                                // }),
                                // side: const BorderSide(
                                //   color: Colors.grey, // 테두리 색
                                //   width: 1.5,
                                // ),
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
                          // if (kDebugMode) {
                          //   Get.off(const PageApp());
                          //   return;
                          // }

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
                                  deviceName: AppController.to.deviceName,
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
                      _buildSignUp()
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

  _buildSignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text('first'.tr, style: GoogleFonts.aBeeZee(fontSize: 18)),
        Text('first'.tr),
        const SizedBox(width: 5),
        TextButton(
          onPressed: () {
            Get.to(PageSignup());
          },
          child: Text(
            "Create an account".tr,
            style: const TextStyle(color: ColorsEx.primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  _buildInputText({
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    bool pw = false,
    String hint = "",
    IconData? icon,
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
              keyboardType: inputType,
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
