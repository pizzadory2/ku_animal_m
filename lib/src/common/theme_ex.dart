import 'package:flutter/material.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';

class ThemeEx {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    // 1. 커서 및 텍스트 선택 핸들(물방울) 색상 변경
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ColorsEx.primaryColor, // 커서 막대 색상
      selectionColor: Color(0x66679E7D), // 텍스트 드래그 영역 (반투명 그린)
      selectionHandleColor: ColorsEx.primaryColor, // 커서 아래 물방울 핸들 색상
    ),

    // 2. 시스템 전역 포인트 컬러 설정 (보라색 제거의 핵심)
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsEx.primaryColor,
      primary: ColorsEx.primaryColor,
      // 필요 시 secondary 등 추가 설정 가능
    ),
    textTheme: textTheme,
    primaryColor: ColorsEx.primaryColor,
    primaryColorLight: ColorsEx.primaryColor,
    buttonTheme: const ButtonThemeData(
      buttonColor: ColorsEx.primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsEx.primaryColor,
        foregroundColor: const Color(0xffffffff),
        disabledBackgroundColor: Color(0xffe0e0e0),
        disabledForegroundColor: Color(0xffa0a0a0),
      ),
      //  ButtonStyle(
      //   backgroundColor: MaterialStateProperty.all<Color>(
      //     ColorsEx.primaryColor,
      //   ), //button color
      //   foregroundColor: MaterialStateProperty.all<Color>(
      //     const Color(0xffffffff),
      //   ), //text (and icon)
      // ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorsEx.primaryColor,
      ),
    ),
    // 3. 체크박스 테두리 및 내부 색상 디테일 수정
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return ColorsEx.primaryColor; // 체크 시 그린
        }
        return Colors.transparent; // 언체크 시 투명
      }),
      side: const BorderSide(color: ColorsEx.primaryColor, width: 1.5), // 언체크 시 테두리 그린
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // 4. 입력창 커서 및 강조색을 위한 추가 설정
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorsEx.primaryColor, width: 1.5),
      ),
    ),
    appBarTheme: AppBarTheme(
      // backgroundColor: Colors.deepOrange,
      backgroundColor: ColorsEx.primaryColor,
      titleTextStyle: textTheme.displayLarge?.copyWith(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: ColorsEx.primaryColor,
      unselectedItemColor: Colors.black,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.deepOrange,
    ),
  );

  // 다크 테마
  static final ThemeData dark = ThemeData(
    textTheme: textTheme,
    scaffoldBackgroundColor: const Color.fromRGBO(31, 31, 31, 1),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color.fromRGBO(51, 51, 51, 1),
      titleTextStyle: textTheme.displayLarge?.copyWith(color: Colors.green),
      iconTheme: const IconThemeData(color: Colors.green),
      // titleTextStyle: textTheme.displayLarge?.copyWith(color: Colors.deepOrange),
      // iconTheme: const IconThemeData(color: Colors.deepOrange),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromRGBO(41, 41, 41, 1),
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.white,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsEx.primaryColor,
        foregroundColor: const Color(0xffffffff),
        disabledBackgroundColor: Color(0xffe0e0e0),
        disabledForegroundColor: Color(0xffa0a0a0),
      ),
      //  ButtonStyle(
      //   backgroundColor: MaterialStateProperty.all<Color>(
      //     ColorsEx.primaryColor,
      //   ), //button color
      //   foregroundColor: MaterialStateProperty.all<Color>(
      //     const Color(0xffffffff),
      //   ), //text (and icon)
      // ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorsEx.primaryColor,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all<Color>(
        ColorsEx.primaryColor,
      ),
    ),
  );

  static const TextTheme textTheme = TextTheme(
      // headline1: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
      );
}
