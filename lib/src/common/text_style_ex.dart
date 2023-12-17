// 스타일 모음집~
import 'package:flutter/material.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';

// 메인
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
