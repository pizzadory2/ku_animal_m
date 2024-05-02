// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/login/user_controller.dart';

class WithdrawDialog extends StatelessWidget {
  WithdrawDialog({super.key});

  String positiveMsg = "ok".tr;
  String negativeMsg = "cancel".tr;
  final double _buttonHeight = 45;

  final TextEditingController _controllerInput = TextEditingController();

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
          child: Text("withdraw".tr, style: tsDialogTitle),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Text("please input password".tr, style: tsDialogBody),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom: 40),
          child: _buildInputData(),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.back(result: "");
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
                  String password = _controllerInput.text;
                  // Get.back(result: _controllerInput.text);
                  UserController.to.withdraw(id: UserController.to.userID, pw: password).then((value) {
                    if (value == true) {
                      Get.back(result: true);
                    }
                  });
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          WidgetFactory.inputText(
              autoFocus: true,
              controller: _controllerInput,
              pw: true,
              onSubmit: (value) {
                String password = _controllerInput.text;
                // Get.back(result: _controllerInput.text);
                UserController.to.withdraw(id: UserController.to.userID, pw: password).then((value) {
                  if (value == true) {
                    Get.back(result: true);
                  }
                });
              }),
          SizedBox(height: 1, child: Divider(color: Colors.black, thickness: 1)),
        ],
      ),
    );
  }
}
