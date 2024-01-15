import 'package:flutter/material.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';

class ThemeEx {
  static final ThemeData light = ThemeData(
    textTheme: textTheme,
    primaryColor: ColorsEx.primaryColor,
    primaryColorLight: ColorsEx.primaryColor,
    buttonTheme: const ButtonThemeData(
      buttonColor: ColorsEx.primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          ColorsEx.primaryColor,
        ), //button color
        foregroundColor: MaterialStateProperty.all<Color>(
          const Color(0xffffffff),
        ), //text (and icon)
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all<Color>(
        ColorsEx.primaryColor,
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
      titleTextStyle: textTheme.displayLarge?.copyWith(color: Colors.deepOrange),
      iconTheme: const IconThemeData(color: Colors.deepOrange),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromRGBO(41, 41, 41, 1),
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.white,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.white,
    ),
  );

  static const TextTheme textTheme = TextTheme(
      // headline1: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
      );
}
