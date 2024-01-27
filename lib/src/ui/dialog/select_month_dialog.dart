// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/constants.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/dialog/product_result_data.dart';

class SelectMonthDialog extends StatefulWidget {
  SelectMonthDialog({super.key});

  @override
  State<SelectMonthDialog> createState() => _SelectMonthDialogState();
}

class _SelectMonthDialogState extends State<SelectMonthDialog> {
  String positiveMsg = "apply".tr;

  String negativeMsg = "cancel".tr;

  final double _buttonHeight = 45;

  int _selectYear = 1900;
  int _selectMonth = 1;

  final TextEditingController _controllerInput = TextEditingController();

  @override
  void initState() {
    DateTime now = DateTime.now();
    _selectYear = now.year;
    _selectMonth = now.month;

    super.initState();
  }

  @override
  void dispose() {
    _controllerInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: _buildMain(),
    );
  }

  _buildMain() {
    double btnMargin = 10;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(top: 40),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text("${_selectYear}${"year".tr}", style: tsDialogTitle.copyWith(fontSize: 22)),
              ),
              Spacer(),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() {
                  _selectYear--;
                }),
                child: Container(
                    decoration: BoxDecoration(
                      // color: ColorsEx.primaryColorGrey,
                      color: ColorsEx.primaryColorLowGreen,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Icon(Icons.keyboard_arrow_down_sharp, color: ColorsEx.primaryColorBold)),
              ),
              SizedBox(width: 5),
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() {
                        _selectYear++;
                      }),
                  child: Container(
                      decoration: BoxDecoration(
                        // color: ColorsEx.primaryColorGrey,
                        color: ColorsEx.primaryColorLowGreen,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Icon(Icons.keyboard_arrow_up_sharp, color: ColorsEx.primaryColorBold))),
            ],
          ),
          // child: Text("Please enter the quantity received".tr, style: tsDialogTitle),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: _buildMonthData(),
        ),
        _buildMiriBogi(),
        SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.back(result: getResultData(isCancel: true));
                },
                child: Container(
                  margin: EdgeInsets.only(left: btnMargin, right: btnMargin / 2, bottom: btnMargin),
                  height: _buttonHeight,
                  decoration: BoxDecoration(
                    color: ColorsEx.primaryColorGrey,
                    // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  alignment: Alignment.center,
                  child: Text(negativeMsg, style: tsDialogButton),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.back(result: getResultData());
                },
                child: Container(
                  margin: EdgeInsets.only(left: btnMargin / 2, right: btnMargin, bottom: btnMargin),
                  height: _buttonHeight,
                  decoration: BoxDecoration(
                    color: ColorsEx.primaryColorBold,
                    // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  alignment: Alignment.center,
                  child: Text(positiveMsg, style: tsDialogButton.copyWith(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildMonthData() {
    int currentMonthIndex = _selectMonth - 1;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: List.generate(4, (idxCol) {
          return Row(
            children: List.generate(3, (idxRow) {
              int idx = idxCol * 3 + idxRow;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectMonth = idx + 1;
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    // decoration: BoxDecoration(
                    //   color: idx == currentMonthIndex ? ColorsEx.primaryColor : Colors.white,
                    //   borderRadius: BorderRadius.all(Radius.circular(5)),
                    // ),
                    decoration: BoxDecoration(
                      color: idx == currentMonthIndex ? ColorsEx.primaryColor : Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                        child: Text(Constants.monthList[idx],
                            style: tsDialogHint.copyWith(
                              fontWeight: idx == currentMonthIndex ? FontWeight.w500 : FontWeight.w400,
                              color: idx == currentMonthIndex ? Colors.white : Colors.black,
                            ))),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  getResultData({bool isCancel = false}) {
    if (isCancel) {
      return ProductResultData();
    }

    if (_controllerInput.text.isEmpty) {
      _controllerInput.text = "0";
    }

    int value = int.parse(_controllerInput.text);
    if (value == 0) {
      return ProductResultData();
    }

    DateTime now = DateTime.now();
    return ProductResultData(year: now.year.toString(), month: now.month.toString(), count: value);
  }

  _buildMiriBogi() {
    String month = _selectMonth.toString().padLeft(2, "0");

    return Center(
      child: Text("${_selectYear}.${month}", style: tsDialogMiribogi),
    );

    // return Container(
    //   margin: EdgeInsets.symmetric(horizontal: 30),
    //   child: Text().richText(
    //     [
    //       TextSpan(text: msg, style: tsDialogHint),
    //       TextSpan(text: " (miri-bogi)", style: tsDialogHint.copyWith(color: Colors.red)),
    //     ],
    //   )
    // );
  }

  // _buildMiriBogi() {
  //   return Container(
  //     width: 72,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text("${_selectYear}년", style: tsDialogMiribogi),
  //         Text("${Constants.monthList[_selectMonth - 1]}", style: tsDialogMiribogi),
  //       ],
  //     ),
  //   );
  // }
}
