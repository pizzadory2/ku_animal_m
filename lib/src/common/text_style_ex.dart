// 스타일 모음집~
import 'package:flutter/material.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';

TextStyle get tsDefault => const TextStyle(
      fontFamily: "Pretendard",
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: Colors.black,
    );

TextStyle get tsDefault500 => const TextStyle(
      fontFamily: "Pretendard",
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );

TextStyle get tsBold => const TextStyle(
      fontFamily: "Pretendard",
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

TextStyle get tsBoldWhite => const TextStyle(
      fontFamily: "Pretendard",
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

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
    fontFamily: "Pretendard",
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    overflow: TextOverflow.ellipsis);

TextStyle get tsInvenItemNameRequest => const TextStyle(
      fontFamily: "Pretendard",
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );

TextStyle get tsInvenItemCompany => const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.black54,
      overflow: TextOverflow.ellipsis,
    );

TextStyle get tsInvenItemCompanyFull => const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.black54,
    );

TextStyle get tsInvenItemTotalCount => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: ColorsEx.primaryColorBold, //Color.fromARGB(255, 0, 17, 13),
      overflow: TextOverflow.ellipsis,
    );

TextStyle get tsInvenItemType => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 14,
      fontWeight: FontWeight.w500,
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

// 메인 main
TextStyle get tsMainFabTitle => const TextStyle(
      fontFamily: "Pretendard",
      fontSize: 18,
      fontWeight: FontWeight.bold,
      // color: Color.fromRGBO(36, 41, 40, 1),
      color: Colors.white,
    );

// 설정
// TextStyle get tsSettingTitle => const TextStyle(
//       fontFamily: "NanumSquare",
//       fontSize: 18,
//       fontWeight: FontWeight.w500,
//       color: Colors.black, //Color.fromARGB(255, 0, 17, 13),
//     );
TextStyle get tsSettingTitle => const TextStyle(
      fontFamily: "NotoSansKR",
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
      fontWeight: FontWeight.w500,
      color: Colors.black54, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsBottomSheetItem => const TextStyle(
      fontFamily: "NotoSansKR",
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.black87, //Color.fromARGB(255, 0, 17, 13),
    );

// QR
TextStyle get tsQRTitle => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.black, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsQRDescription => const TextStyle(
      fontFamily: "NotoSansKR",
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black, //Color.fromARGB(255, 0, 17, 13),
    );

// dialog
TextStyle get tsDialogTitle => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.black, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsDialogBody => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.black, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsDialogBody2 => const TextStyle(
      fontFamily: "Pretendard",
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.black, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsDialogButton => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsDialogHint => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.black, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsDialogMiribogi => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 12,
      fontWeight: FontWeight.w300,
      color: Colors.black, //Color.fromARGB(255, 0, 17, 13),
    );

// 회원
TextStyle get tsMemberName => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsMemberPhone => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.grey, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsMemberEmail => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.grey, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsMemberTeam => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.black, //Color.fromARGB(255, 0, 17, 13),
    );

TextStyle get tsMemberId => const TextStyle(
      fontFamily: "SCoreDream",
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.black, //Color.fromARGB(255, 0, 17, 13),
    );

// 제품(입고,출고)
TextStyle get tsProductItemTitle => const TextStyle(
    // fontFamily: "SCoreDream",
    // fontFamily: "GmarketSans",
    // fontFamily: "NotoSansKR",
    fontFamily: "Pretendard",
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    overflow: TextOverflow.ellipsis);

TextStyle get tsProductItemTitleFull => const TextStyle(
      fontFamily: "Pretendard",
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );

TextStyle get tsProductItem => const TextStyle(
      // fontFamily: "Pretendard",
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.black54,
      overflow: TextOverflow.ellipsis,
    );

TextStyle get tsProductItemBold => const TextStyle(
      fontFamily: "Pretendard",
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
      overflow: TextOverflow.ellipsis,
    );

// 안전재고
TextStyle get tsSafeListItemName => const TextStyle(
      fontFamily: "Pretendard",
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black,
      overflow: TextOverflow.ellipsis,
    );

TextStyle get tsSafeListItemNameRequest => const TextStyle(
      fontFamily: "Pretendard",
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
