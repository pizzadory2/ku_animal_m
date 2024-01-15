// ignore_for_file: unused_element

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/network/rest_client.dart';
import 'package:ku_animal_m/src/ui/notice/page_notice.dart';

// 언어 선택
// 공지사항
// 기본안전재고
// 버전
// 로그아웃
class PageSetting extends StatefulWidget {
  const PageSetting({super.key});

  @override
  State<PageSetting> createState() => _PageSettingState();
}

class _PageSettingState extends State<PageSetting> {
  final TextEditingController _controllerIP = TextEditingController();

  // int _selectClass = -1;
  // bool _isLoading = true;

  @override
  void initState() {
    _controllerIP.text = RestClient().dio.options.baseUrl;
    super.initState();

    // _loadData();
  }

  @override
  void dispose() {
    _controllerIP.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("setting".tr, style: tsAppbarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // _buildMyInfo(),
                  _buildNotice(),
                  _buildLanguage(),
                  // _buildVersion(),
                  kDebugMode ? _buildTheme() : Container(),
                  _buildLogout(),
                ],
              ),
            ),
            _buildVersion2(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _defaultDecoration(bool select) {
    return BoxDecoration(
      gradient: select ? _deviceItemSelect() : _deviceItemNormal(),
      color: const Color.fromRGBO(54, 60, 92, 1),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 3,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  void _loadData() {
    if (_controllerIP.text.isEmpty) {
      Utils.showToast("ip를 입력후 저장을 눌러주세요.");
      return;
    }

    // ClassController.to.readAll().then((value) {
    //   setState(() {
    //     _isLoading = false;

    //     if (value == true) {
    //     } else {
    //       Utils.showToast("호실 정보를 가져오는데 실패하였습니다.");
    //     }
    //   });
    // });
  }

  _deviceItemSelect() {
    return const LinearGradient(
      colors: [
        Color.fromRGBO(144, 125, 221, 1),
        Color.fromRGBO(220, 91, 153, 1),
      ],
      stops: [0.1, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  _deviceItemNormal() {
    return const LinearGradient(
      colors: [
        Color.fromRGBO(42, 49, 76, 1),
        Color.fromRGBO(55, 62, 92, 1),
      ],
      stops: [0.1, 1.0],
    );
  }

  _buildMyInfo() {
    return Container(
      height: 10,
    );
  }

  _buildNotice() {
    return _buildSettingItem(
      title: "notice",
      func: () {
        debugPrint("공지사항");
        Get.to(const PageNotice());
      },
    );
  }

  _buildLanguage() {
    return _buildSettingItem(
      title: "language",
      subTitle: getLanguage(),
      func: () {
        debugPrint("언어선택");
        _showBottomSheet();
      },
    );
  }

  _buildVersion() {
    return _buildSettingItem(
      title: "App Version",
      subTitle: "0.0.1",
    );
  }

  _buildVersion2() {
    String appVersion = "0.0.1";

    return Container(
      width: double.infinity,
      height: 30,
      margin: const EdgeInsets.only(bottom: 10),
      child: Center(child: Text("${"App Version".tr} $appVersion", style: tsAppVersion)),
    );
  }

  _buildTheme() {
    return _buildSettingItem(
      title: "dark mode",
      func: () {
        AppController.to.changeTheme(!AppController.to.isDarkMode);
        debugPrint("다크모드");
      },
    );
  }

  _buildLogout() {
    return _buildSettingItem(
      title: "logout",
      func: () {
        Get.offAllNamed("/login");
        debugPrint("로그아웃");
      },
    );
  }

  Container _buildSettingItem({required String title, String subTitle = "", Function()? func}) {
    return Container(
      // height: 50,
      // margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: func,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title.tr, style: tsSettingTitle),
            const Spacer(),
            Text(subTitle.tr, style: tsSettingSubTitle),
            SizedBox(width: subTitle.isEmpty ? 0 : 10),
            func != null ? const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey) : Container(),
          ],
        ),
      ),
    );
  }

  _showBottomSheet() {
    Get.bottomSheet(
      SizedBox(
        height: 200,
        child: Column(
          children: [
            WidgetFactory.gripBar(color: Colors.black12), //
            const SizedBox(height: 10),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                debugPrint("한국어");
                setState(() {
                  AppController.to.changeLanguage(lang: "ko");
                  Get.back();
                });
              },
              child:
                  _buildBottomItem(title: "kor".tr, icon: Utils.ImageAsset("korea_round.png", width: 30, height: 30)),
            ),
            const Divider(height: 1, color: Colors.grey),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                debugPrint("영어");
                setState(() {
                  AppController.to.changeLanguage(lang: "en");
                  Get.back();
                });
              },
              child: _buildBottomItem(title: "eng".tr, icon: Utils.ImageAsset("us_round.png", width: 30, height: 30)),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
        // borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  _buildBottomItem({required String title, Image? icon}) {
    return SizedBox(
      // color: Colors.amber,
      height: 60,
      // color: Colors.orange,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? Container(),
            const SizedBox(width: 10),
            Text(title, style: tsBottomSheetItem),
          ],
        ),
      ),
    );
  }

  getLanguage() {
    String language = AppController.to.language;

    switch (language) {
      case "ko":
        return "kor";
      case "en":
        return "eng";
      case "ja":
        return "jap";
      default:
        return "kor";
    }
  }
}
