import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ku_animal_m/src/index/index_common.dart';
import 'package:ku_animal_m/src/ui/login/page_login.dart';
import 'package:ku_animal_m/src/ui/login/user_controller.dart';

class PageSignup2 extends StatefulWidget {
  const PageSignup2({Key? key}) : super(key: key);

  @override
  State<PageSignup2> createState() => _PageSignup2State();
}

class _PageSignup2State extends State<PageSignup2> {
  final TextEditingController _controllerID = TextEditingController();
  final TextEditingController _controllerPW = TextEditingController();
  final TextEditingController _controllerPWConfirm = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  int _workType = 3;

  bool _isLoading = false;

  final Color primaryColor = const Color(0xFF679E7D); // VMTH 그린
  final Color inputFillColor = const Color(0xFFF1F4F2);

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
      backgroundColor: const Color(0xFFF8FAF9), // 배경을 살짝 연한 그린톤으로
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text("Sign up".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              // ListView 대신 SingleChildScrollView 권장
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputText(
                        title: "id".tr, controller: _controllerID, hint: "id info".tr, icon: Icons.person_outline),
                    _buildInputText(
                        title: "pw".tr,
                        controller: _controllerPW,
                        hint: "pw info".tr,
                        pw: true,
                        maxLength: 30,
                        icon: Icons.lock_outline),
                    _buildInputText(
                        title: "pw confirm".tr,
                        controller: _controllerPWConfirm,
                        hint: "pw info".tr,
                        pw: true,
                        maxLength: 30,
                        icon: Icons.lock_reset_outlined),
                    _buildInputText(title: "name".tr, controller: _controllerName, icon: Icons.badge_outlined),
                    _buildInputText(
                      title: "phone".tr,
                      controller: _controllerPhone,
                      inputType: TextInputType.number,
                      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                      icon: Icons.phone_android_outlined,
                    ),
                    _buildInputText(
                      title: "email".tr,
                      controller: _controllerEmail,
                      hint: "ku@konkuk.ac.kr",
                      inputType: TextInputType.emailAddress,
                      maxLength: 50,
                      icon: Icons.email_outlined,
                    ),
                    _buildDropdown(
                        title: "worktype".tr, list: ["시간제".tr, "계약직".tr, "정규직".tr, "선택안함".tr], select: _workType),
                    const SizedBox(height: 40),
                    _buildSignupButton(),
                  ],
                ),
              ),
            ),
          ),
          WidgetFactory.loadingWidget(isLoading: _isLoading, title: "회원가입 중입니다.", isBackground: false),
        ],
      ),
    );
  }

  // 1. 개선된 입력창 위젯
  Widget _buildInputText({
    required String title,
    TextEditingController? controller,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatter,
    bool pw = false,
    String hint = "",
    int maxLength = 20,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child:
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF666666))),
        ),
        TextField(
          controller: controller,
          obscureText: pw,
          maxLength: maxLength,
          keyboardType: inputType,
          inputFormatters: inputFormatter,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: primaryColor, size: 20) : null,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: inputFillColor,
            // 기본 상태 (테두리 없음)
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            // ⭐ 탭했을 때 상태 (그린 테두리 추가)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            counterText: "",
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // 2. 개선된 드롭다운 위젯
  Widget _buildDropdown({required String title, required List<String> list, required int select}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child:
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF666666))),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: select,
              isExpanded: true,
              // ⭐ 메뉴 창 스타일 수정
              dropdownColor: Colors.white, // 메뉴 배경색을 순백색으로
              borderRadius: BorderRadius.circular(12), // 메뉴 창 모서리 라운드
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
              items: list
                  .asMap()
                  .entries
                  .map((e) => DropdownMenuItem<int>(
                        value: e.key,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(e.value, style: const TextStyle(fontSize: 15, color: Colors.black87)),
                        ),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _workType = value!),
            ),
          ),
        ),
      ],
    );
  }

  // 3. 개선된 회원가입 버튼
  Widget _buildSignupButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _handleSignup, // 로직 분리
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          "Create an account".tr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // 4. 로직 핸들러 (코드 가독성을 위해 기존 onPressed 로직을 분리)
  void _handleSignup() {
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
  }
}
