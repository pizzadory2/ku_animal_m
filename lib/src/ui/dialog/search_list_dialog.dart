// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/constants.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/dialog/search_result_data.dart';

class SearchListDialog extends StatefulWidget {
  SearchListDialog({super.key});

  @override
  State<SearchListDialog> createState() => _SearchListDialogState();
}

class _SearchListDialogState extends State<SearchListDialog> {
  int _filterIndex = 0;
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
          child: Text("Direct search".tr, style: tsDialogTitle),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Text("Please select search conditions".tr, style: tsDialogBody),
        ),
        Row(
          children: [
            Expanded(
              child: _buildFilter(),
            ),
          ],
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom: 40, top: 10),
          child: _buildInputData(),
        ),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          WidgetFactory.inputText(
              autoFocus: true,
              controller: _controllerInput,
              onSubmit: (value) {
                Get.back(result: getResultData());
              }),
          SizedBox(height: 1, child: Divider(color: Colors.black, thickness: 1)),
        ],
      ),
    );
  }

  _buildFilter() {
    return Container(
      height: 42,
      margin: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      color: Colors.white,
      // color: Colors.grey[100],
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFilterItem(0),
            _buildFilterItem(1),
            _buildFilterItem(2),
            _buildFilterItem(3),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildFilterItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterIndex = index;
        });
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(left: index == 0 ? 0 : 5, top: 3, bottom: 3),
        decoration: BoxDecoration(
          color: _filterIndex == index ? ColorsEx.primaryColorLowGreen : Colors.grey[100],
          border: Border.all(width: 1, color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(45),
        ),
        child: Text(
          Constants.filterList[index],
          style: tsDefault.copyWith(
            color: _filterIndex == index ? Colors.black : Colors.grey,
            fontWeight: _filterIndex == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  getResultData({bool isCancel = false}) {
    if (isCancel) {
      return SearchResultData();
    }
    String type = Utils.getSearchType(filterIndex: _filterIndex);
    return SearchResultData(type: type, txt: _controllerInput.text);
  }
}
