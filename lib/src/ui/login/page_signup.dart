import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ku_animal_m/src/common/extension_string.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/ui/login/page_login.dart';
import 'package:ku_animal_m/src/ui/login/user_controller.dart';

class PageSignup extends StatefulWidget {
  const PageSignup({Key? key}) : super(key: key);

  @override
  State<PageSignup> createState() => _PageSignupState();
}

class _PageSignupState extends State<PageSignup> {
  final TextEditingController _controllerID = TextEditingController();
  final TextEditingController _controllerPW = TextEditingController();
  final TextEditingController _controllerPWConfirm = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  int _workType = 3;

  bool _isLoading = false;

  @override
  void initState() {
    if (kDebugMode) {
      _controllerID.text = "";
      _controllerPW.text = "";
      _controllerName.text = "";
      _controllerPhone.text = "";
      _controllerEmail.text = "";
    }

    super.initState();
  }

  @override
  void dispose() {
    _controllerID.dispose();
    _controllerPW.dispose();
    _controllerPWConfirm.dispose();
    _controllerName.dispose();
    _controllerPhone.dispose();
    _controllerEmail.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sign up".tr, style: tsAppbarTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListView(
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInputText(title: "id".tr, controller: _controllerID, hint: "id info".tr),
                      _buildInputText(
                        title: "pw".tr,
                        controller: _controllerPW,
                        hint: "pw info".tr,
                        pw: true,
                        maxLength: 30,
                      ),
                      _buildInputText(
                        title: "pw confirm".tr,
                        controller: _controllerPWConfirm,
                        hint: "pw info".tr,
                        pw: true,
                        maxLength: 30,
                      ),
                      _buildInputText(title: "name".tr, controller: _controllerName),
                      _buildInputText(
                        title: "phone".tr,
                        controller: _controllerPhone,
                        inputType: TextInputType.number,
                        inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                        //[WhitelistingTextInputFormatter(RegExp('[0-9]')),]
                      ),
                      _buildInputText(
                        title: "email".tr,
                        controller: _controllerEmail,
                        hint: "ku@konkuk.ac.kr",
                        inputType: TextInputType.emailAddress,
                        maxLength: 50,
                      ),
                      _buildDropdown(
                          title: "worktype".tr, list: ["시간제".tr, "계약직".tr, "정규직".tr, "선택안함".tr], select: _workType),
                      const SizedBox(height: 30),
                      _buildInfo(),
                      _buildSignupButton(),
                      // const Spacer(),
                      //_buildSignUp()
                    ],
                  ),
                ],
              ),
            ),
          ),
          WidgetFactory.loadingWidget(isLoading: _isLoading, title: "회원가입 중입니다.", isBackground: false),
        ],
      ),
    );
  }

  ElevatedButton _buildSignupButton() {
    double loginHeight = 50;

    return ElevatedButton(
      onPressed: () {
        String id = _controllerID.text;
        String pw = _controllerPW.text;

        if (id.isEmpty) {
          Get.snackbar("signup failed".tr, "please input id".tr);
          return;
        }

        if (pw.isEmpty) {
          Get.snackbar("signup failed".tr, "please input password".tr);
          return;
        } else {
          if (pw.isValidPassword() == false) {
            Get.snackbar("signup failed".tr, "pw info fail".tr);
            return;
          }
        }

        if (_controllerPWConfirm.text.isEmpty) {
          Get.snackbar("signup failed".tr, "please input password check".tr);
          return;
        } else {
          if (_controllerPWConfirm.text.isValidPassword() == false) {
            Get.snackbar("signup failed".tr, "pw info".tr);
            return;
          }
        }

        if (_controllerName.text.isEmpty) {
          Get.snackbar("signup failed".tr, "please input name".tr);
          return;
        }

        // if (_controllerPhone.text.isEmpty) {
        //   Get.snackbar("signup failed".tr, "please input phone number".tr);
        //   return;
        // }

        if (_controllerEmail.text.isEmpty) {
          Get.snackbar("signup failed".tr, "please input email".tr);
          return;
        } else {
          if (_controllerEmail.text.isValidEmailFormat() == false) {
            Get.snackbar("signup failed".tr, "Please enter the correct email address".tr);
            return;
          }
        }

        setState(() {
          _isLoading = true;
        });

        Utils.keyboardHide();

        String workType = Utils.getWorkType(workIndex: _workType);

        UserController.to
            .singup(
                id: id,
                pw: pw,
                name: _controllerName.text,
                phone: _controllerPhone.text,
                email: _controllerEmail.text,
                type: workType)
            .then((value) {
          if (value) {
            Get.snackbar("thankyou".tr, "signup success".tr);
            Get.off(PageLogin(id: _controllerID.text, pw: _controllerPW.text));
          } else {
            // Get.snackbar("signup failed".tr, "아이디와 비밀번호를 확인해주세요.");

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
            "Create an account".tr,
            style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
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
    required String title,
    TextEditingController? controller,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatter,
    bool pw = false,
    String hint = "",
    int maxLength = 20,
    IconData? icon,
  }) {
    double tfHeight = 50;

    return Column(
      children: [
        Container(
          height: 25,
          margin: const EdgeInsets.only(left: 5, bottom: 5),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: GoogleFonts.aBeeZee(fontSize: 17, color: Colors.grey[500]),
          ),
        ),
        Container(
          height: tfHeight,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            controller: controller,
            obscureText: pw,
            maxLength: maxLength,
            keyboardType: inputType,
            inputFormatters: inputFormatter,
            textInputAction: TextInputAction.next,
            // cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.aBeeZee(color: Colors.grey[400]),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              counterText: "",
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  _buildInfo() {
    return Container(
      child: Text(""),
    );
  }

  _buildDropdown({required String title, required List<String> list, required int select}) {
    return Column(
      children: [
        Container(
          height: 25,
          margin: const EdgeInsets.only(left: 5, bottom: 5),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: GoogleFonts.aBeeZee(fontSize: 17, color: Colors.grey[500]),
          ),
        ),
        Container(
          height: 50,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<int>(
            value: select,
            isExpanded: true,
            underline: SizedBox.shrink(),
            items: list
                .asMap()
                .entries
                .map((e) => DropdownMenuItem<int>(
                      value: e.key,
                      child: Text(e.value, style: GoogleFonts.aBeeZee(fontSize: 17)),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _workType = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}
