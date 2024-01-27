// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/dialog/product_result_data.dart';

class InputCountDialog extends StatefulWidget {
  InputCountDialog({super.key});

  @override
  State<InputCountDialog> createState() => _InputCountDialogState();
}

class _InputCountDialogState extends State<InputCountDialog> {
  String positiveMsg = "apply".tr;

  String negativeMsg = "cancel".tr;

  final double _buttonHeight = 45;

  final TextEditingController _controllerInput = TextEditingController();

  @override
  void initState() {
    _controllerInput.addListener(() {
      setState(() {});
    });
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
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 40),
          child: Text("Please enter the quantity received".tr, style: tsDialogTitle),
          // child: Text("Please enter the shipment quantity".tr, style: tsDialogTitle),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: _buildInputData(),
        ),
        _buildMiriBogi(),
        SizedBox(height: 20),
        _buildPlusMinusButton(),
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

  _buildInputData() {
    _controllerInput.selection = TextSelection.fromPosition(TextPosition(offset: _controllerInput.text.length));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: TextField(
                controller: _controllerInput,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                autofocus: true,
                // onSubmitted: onSubmit,
                maxLines: 1,
                maxLength: 3,
                readOnly: false,
                cursorColor: Colors.black,
                obscureText: false,
                style: tsMainBoxInOutCount,
                decoration: InputDecoration(
                  // hintText: "${title}을 입력해 주세요",
                  hintStyle: tsDialogHint,
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  // enabledBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide(width: 1, color: Colors.grey),
                  // ),
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  counterText: "",
                )),
          ),
          SizedBox(height: 1, child: Divider(color: Colors.black, thickness: 1)),
        ],
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

  _buildPlusMinusButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (_controllerInput.text.isEmpty) {
              _controllerInput.text = "0";
            } else {
              int value = int.parse(_controllerInput.text);
              value--;
              if (value < 0) {
                value = 0;
              }
              _controllerInput.text = value.toString();
            }
          },
          child: Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: ColorsEx.primaryColorGrey,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Icon(Icons.remove, color: Colors.white),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (_controllerInput.text.isEmpty) {
              _controllerInput.text = "1";
            } else {
              int value = int.parse(_controllerInput.text);
              value++;
              if (value > 999) {
                value = 999;
              }

              _controllerInput.text = value.toString();
            }
          },
          child: Container(
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: ColorsEx.primaryColorBold,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  _buildMiriBogi() {
    if (_controllerInput.text.isEmpty) {
      return Container();
    }

    int value = int.parse(_controllerInput.text);
    String msg = Utils.numberFormatMoney(value);

    return Center(
      child: Text(msg, style: tsDialogHint),
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
}
