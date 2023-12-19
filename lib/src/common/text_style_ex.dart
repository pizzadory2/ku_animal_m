// 스타일 모음집~
import 'package:flutter/material.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';

// 메인
TextStyle get tsAppbarTitle => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );

TextStyle get tsMainBoxTitle => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );

TextStyle get tsMainBoxNormal => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );

TextStyle get tsMainBoxInOutCount => const TextStyle(
      fontFamily: "GmarketSans",
      fontSize: 32,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );

TextStyle get tsMainRecentlyName => const TextStyle(
    // fontFamily: "SCoreDream",
    // fontFamily: "GmarketSans",
    // fontFamily: "NotoSansKR",
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: Colors.black,
    overflow: TextOverflow.ellipsis);

TextStyle get tsMainRecentlyCount => const TextStyle(
      // fontFamily: "SCoreDream",
      // fontFamily: "GmarketSans",
      fontFamily: "NotoSansKR",
      fontSize: 15,
      fontWeight: FontWeight.w300,
      color: Colors.black87,
    );

TextStyle get tsSettingItem => const TextStyle(
      fontFamily: "NotoSansKR",
      fontSize: 18,
      fontWeight: FontWeight.w300,
      color: Colors.black,
    );

// 재고
TextStyle get tsInvenItemName => const TextStyle(
    // fontFamily: "SCoreDream",
    // fontFamily: "GmarketSans",
    // fontFamily: "NotoSansKR",
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: Colors.black,
    overflow: TextOverflow.ellipsis);

TextStyle get tsInvenItemCompany => const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.black54,
      overflow: TextOverflow.ellipsis,
    );

TextStyle get tsInvenItemTotalCount => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: ColorsEx.primaryColorBold, //Color.fromARGB(255, 0, 17, 13),
      overflow: TextOverflow.ellipsis,
    );

TextStyle get tsSearch => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.white, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsSearchHint => const TextStyle(
      fontSize: 18,
      color: Colors.grey,
    );

TextStyle get tsButtonDef => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white, //Color.fromRGBA(0, 17, 13, 1),
    );

// 설정
TextStyle get tsSettingTitle => const TextStyle(
      fontFamily: "NanumSquare",
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsSettingSubTitle => const TextStyle(
      fontFamily: "NotoSansKR",
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.grey, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsSettingContent => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsAppVersion => const TextStyle(
      fontFamily: "NotoSansKR",
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: Colors.black54, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsBottomSheetItem => const TextStyle(
      fontFamily: "NotoSansKR",
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.black87, //Color.fromARGB(255, 0, 17, 13),
    );

// QR
TextStyle get tsQRDescription => const TextStyle(
      fontFamily: "NotoSansKR",
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.white, //Color.fromARGB(255, 0, 17, 13),
    );
