// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Utils {
  static Image ImageAsset(String filename, {double? width, double? height, bool isFill = true}) {
    String defaultSuffix = ".png";
    if (!filename.endsWith(defaultSuffix)) {
      filename += defaultSuffix;
    }

    String fullFilePath = "assets/images/$filename";
    return Image.asset(
      fullFilePath,
      width: width,
      height: height,
      fit: isFill ? BoxFit.cover : BoxFit.none,
    );
  }

  static Image ImageAssetJpg(String filename, {double? width, double? height, bool isFill = true}) {
    String defaultSuffix = ".jpg";
    if (!filename.endsWith(defaultSuffix)) {
      filename += defaultSuffix;
    }

    String fullFilePath = "assets/images/$filename";
    return Image.asset(
      fullFilePath,
      width: width,
      height: height,
      fit: isFill ? BoxFit.cover : BoxFit.none,
    );
  }

  static Image ImageAsset3(String filename, {double? width, double? height, bool isFill = true}) {
    String defaultSuffix = ".png";
    if (!filename.endsWith(defaultSuffix)) {
      filename += defaultSuffix;
    }

    String fullFilePath = "assets/$filename";
    return Image.asset(
      fullFilePath,
      width: width,
      height: height,
      fit: isFill ? BoxFit.cover : BoxFit.none,
    );
  }

  static Image ImageIcon(String filename, {double? width, double? height, bool isFill = true, Color? color}) {
    String defaultSuffix = ".png";
    if (!filename.endsWith(defaultSuffix)) {
      filename += defaultSuffix;
    }

    String fullFilePath = "assets/icons/$filename";
    return Image.asset(
      fullFilePath,
      width: width,
      height: height,
      color: color,
      fit: isFill ? BoxFit.cover : BoxFit.none,
    );
  }

  static Image ImageGif(String filename, {double? width, double? height, bool isFill = true}) {
    String defaultSuffix = ".gif";
    if (!filename.endsWith(defaultSuffix)) {
      filename += defaultSuffix;
    }

    String fullFilePath = "assets/gif/$filename";
    return Image.asset(
      fullFilePath,
      width: width,
      height: height,
      fit: isFill ? BoxFit.cover : BoxFit.none,
    );
  }

  static Image NetworkImage(
      {required String? url,
      double? width,
      double? height,
      BoxFit fit = BoxFit.fitWidth,
      double emptyImgWidth = 80,
      double emptyImgHeight = 80}) {
    String imgUrl = url ?? "";
    if (imgUrl.isEmpty) {
      return Image.asset(
        "assets/images/icon.png",
        width: emptyImgWidth,
        height: emptyImgHeight,
        fit: BoxFit.contain,
      );
    }

    return Image.network(
      imgUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // return Text("에러에러");
        return Container(
          padding: const EdgeInsets.all(20),
          // child: Util.ImageAsset("icon.png", width: 60, height: 80),
          child: Image.asset(
            "assets/images/icon.png",
            width: emptyImgWidth,
            height: emptyImgHeight,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  static Image ImageFile(File file, {BoxFit fit = BoxFit.cover}) {
    Image result = Image.file(
      file,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(color: Colors.grey[300], child: const Center(child: Text("Load Failed(Image)")));
      },
    );

    // ui.ImageDescriptor
    // result.image.loadImage(key, (buffer, {getTargetSize}) => null)

    return result;
  }

  static AssetImage ImageAsset2(String filename) {
    String defaultSuffix = ".png";
    if (!filename.endsWith(defaultSuffix)) {
      filename += defaultSuffix;
    }

    String fullFilePath = "assets/images/$filename";
    return AssetImage(fullFilePath);
  }

  static ImageSvg(String filename, {double? width, double? height, Color? color}) {
    String defaultSuffix = ".svg";
    if (!filename.endsWith(defaultSuffix)) {
      filename += defaultSuffix;
    }

    String fullFilePath = "assets/$filename";

    return SvgPicture.asset(
      fullFilePath,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(color ?? Colors.transparent, BlendMode.srcIn),
    );
  }

  static bool validateFormat(String data) {
    if (data.isEmpty) {
      return true;
    }

    String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";

    RegExp regex = RegExp(pattern);
    return (data.isEmpty || !regex.hasMatch(data)) ? false : true;
  }

  static bool validateAmericanAge(String data) {
    if (data.isEmpty) return false;

    final DateTime today = DateTime.now();
    // DateFormat dateFormat = DateFormat("yyyyMMdd");
    // DateTime dateTime = dateFormat.parse(data);
    // DateTime dateTime = DateFormat("yyyy-MM-dd").parse("2020-01-14");
    DateTime dateTime = DateTime.parse(data);

    // int monthToday = today.month;
    // int monthBirth = dateTime.month;
    int diffMonth = today.month - dateTime.month;
    int dayToday = today.day;
    int dayBirth = dateTime.day;
    int age = today.year - dateTime.year;
    if (diffMonth < 0 || (diffMonth == 0 && dayToday < dayBirth)) {
      age--;
    }

    debugPrint("$age");

    bool finalResult = age >= 14;

    return finalResult;
  }

  static bool validateBirth(String data) {
    if (data.isEmpty) return false;

    String pattern = r"^(19[0-9][0-9]|20\d{2})(0[0-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])$";

    RegExp regex = RegExp(pattern);

    bool condition01 = regex.hasMatch(data);

    bool finalResult = condition01;
    return finalResult;
  }

  static bool validatePw(String data) {
    if (data.isEmpty) return false;

    String pattern = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{1,}$";
    String pattern2 = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[~/<>!@#$%^&*()_+=-])[A-Za-z~/<>!@#$%^&*()_+=-]{1,}$";
    String pattern3 = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[~/<>!@#$%^&*()_+=-])[A-Za-z\d~/<>!@#$%^&*()_+=-]{1,}$";
    // String pattern = r"^(?=.*[a-z])(?=.*[A-Z])[a-zA-Z\d]{1,}$";
    // String pattern2 = r"^(?=.*\d)[\d]{1,}$";
    // String pattern3 = r"^(?=.*[@$!%*?&])[\d]{1,}$";

    RegExp regex = RegExp(pattern);
    RegExp regex2 = RegExp(pattern2);
    RegExp regex3 = RegExp(pattern3);

    bool condition01 = regex.hasMatch(data);
    bool condition02 = regex2.hasMatch(data);
    bool condition03 = regex3.hasMatch(data);

    bool finalResult = condition01 || condition02 || condition03;
    return finalResult;
  }

  static void keyboardHide() {
    // 키보드 내려가~
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static showToast(String msg, {bool isCenter = false, bool isShotTime = true}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: isShotTime ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      fontSize: 14,
      backgroundColor: const Color(0xB2727277),
      gravity: isCenter ? ToastGravity.CENTER : ToastGravity.BOTTOM,
    );
  }

  static getColor() {
    final Random random = Random();
    Color randomColor = Color.fromRGBO(
      random.nextInt(255),
      random.nextInt(255),
      random.nextInt(255),
      1,
    );

    return randomColor;
  }

  static String getFormatDate(DateTime dateTime, {String format = "yyyy-MM-dd"}) {
    String result = DateFormat(format).format(dateTime);
    return result;
  }
}
