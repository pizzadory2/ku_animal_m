import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  final _isDarkMode = false.obs;
  final _isEnglish = true.obs;
  final _isSystemTheme = true.obs;

  bool get isDarkMode => _isDarkMode.value;
  bool get isEnglish => _isEnglish.value;
  bool get isSystemTheme => _isSystemTheme.value;

  String classSeq = "";
  String className = "";
  String language = "ko";

  // String serverUrl = "http://ctl.today25.com/Ajax/AjaxApi";
  String serverUrl = "";

  void changeTheme(bool value) {
    _isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  // void changeLanguage(bool value) {
  //   _isEnglish.value = value;
  //   Get.updateLocale(value ? const Locale('en', 'US') : const Locale('id', 'ID'));
  // }

  /// 언어 변경
  /// ko - 한국어, en - 영어, ja - 일본어
  void changeLanguage({String lang = "ko"}) {
    // _isEnglish.value = value;
    language = lang;
    switch (lang) {
      case "ko":
        _isEnglish.value = false;
        Get.updateLocale(const Locale('ko', 'KR'));
        break;
      case "en":
        _isEnglish.value = true;
        Get.updateLocale(const Locale('en', 'US'));
        break;
      case "ja":
        _isEnglish.value = false;
        Get.updateLocale(const Locale('ja', 'JP'));
        break;
    }
  }

  void changeThemeBySystem(bool value) {
    _isSystemTheme.value = value;
    Get.changeThemeMode(value ? ThemeMode.system : ThemeMode.light);
  }
}
