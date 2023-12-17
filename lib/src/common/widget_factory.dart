import 'package:flutter/material.dart';

class WidgetFactory {
  static Widget divider({double weight = 1, Color color = Colors.white, double topMargin = 0}) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      width: double.infinity,
      height: weight,
      color: color,
    );
  }

  static Widget dividerVer({double width = 1, double height = double.infinity, Color? color, double margin = 0}) {
    return Container(
      color: color ?? Color(0xFF606066),
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: margin),
    );
  }

  static circleIcon({required int color}) {
    return Container(
      width: 12.0,
      height: 12.0,
      margin: EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: Color(color),
        shape: BoxShape.circle,
      ),
    );
  }

  static circleIcon2({required Color color}) {
    return Container(
      width: 12.0,
      height: 12.0,
      margin: EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  static circleIconRepeat({required int color, bool repeat = false}) {
    return Container(
      width: 15.0,
      height: 15.0,
      margin: EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: Color(color),
        shape: BoxShape.circle,
      ),
      child: repeat
          ? Icon(
              Icons.cached,
              size: 12,
              color: Colors.white,
            )
          : null,
    );
  }

  static circleIcon2Repeat({required Color color, bool repeat = false}) {
    return Container(
      width: 12.0,
      height: 12.0,
      margin: EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: repeat
          ? Icon(
              Icons.cached,
              size: 11,
              color: Colors.white,
            )
          : null,
    );
  }

  static Widget gripBar({double width = 32, Color color = Colors.white60, double bottomMargin = 12}) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: bottomMargin),
      child: Container(
          width: width,
          height: 3,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ))),
    );
  }

  static Widget emptyWidget({String title = ""}) {
    return Container(
      // color: Colors.amber,
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.grey, fontSize: 30, fontFamily: "KCCEunyoung"),
        ),
      ),
    );
  }

  static Widget dividerDash({double width = 0.5, Color color = Colors.black}) {
    return Row(
      children: [
        for (int i = 0; i < 50; i++)
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: color,
                    thickness: width,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static Widget selectPen({required Function() onTap, Color bgColor = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: bgColor,
        child: Container(
          width: 40,
          height: 7,
          decoration: const BoxDecoration(
            color: Colors.black,
            // border: Border.all(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }

  static BoxDecoration boxDecoration({double radius = 15}) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 7,
          offset: const Offset(4, 0),
        )
      ],
      color: Colors.white,
      // border: Border.all(
      //   width: 1,
      // ),
      borderRadius: BorderRadius.circular(radius),
    );
    // return BoxDecoration(
    //   color: Colors.white,
    //   borderRadius: BorderRadius.circular(10),
    //   boxShadow: [
    //     BoxShadow(
    //       color: Colors.grey.withOpacity(0.5),
    //       spreadRadius: 1,
    //       blurRadius: 3,
    //       offset: Offset(0, 1), // changes position of shadow
    //     ),
    //   ],
    // );
  }

  static Widget get spacerWidth => const SizedBox(width: 5);
  static Widget get spacerHeight => const SizedBox(height: 5);
}
