import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/controllers.dart';
import 'package:ku_animal_m/src/common/enums.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/dialog/input_count_dialog.dart';
import 'package:ku_animal_m/src/ui/dialog/product_result_data.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';
import 'package:ku_animal_m/src/ui/search/search_home_controller.dart';

// 입고, 등록시에 제품을 검색하여 선택하는 화면
class PageSearchSelect extends StatefulWidget {
  const PageSearchSelect({super.key, this.title = "", this.searchText = "", required this.pageType});

  final String title;
  final String searchText;
  final PageType pageType;

  @override
  State<PageSearchSelect> createState() => _PageSearchSelectState();
}

class _PageSearchSelectState extends State<PageSearchSelect> {
  // 입고 : Please select the product you wish to stock
  // 출고 : Please select the product you wish to ship

  bool _isMultiSelect = false;

  @override
  Widget build(BuildContext context) {
    int itemCount = SearchHomeController.to.getCount();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: itemCount == 0
                  ? _buildEmpty()
                  : Column(
                      children: [
                        AppController.to.isMultiSelect ? _buildMultiSelect() : Container(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              return _buildProductItem(index);
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _buildProductItem(int index) {
    if (index >= SearchHomeController.to.getCount()) {
      return Container();
    }

    ProductModel data = SearchHomeController.to.getItem(index);
    String amount = data.mi_content.isEmpty ? "-" : "(${data.mi_content})";
    String regDate = data.reg_date;
    if (regDate.isNotEmpty) {
      var date = DateTime.parse(regDate);
      regDate = "등록일 ${date.year}.${date.month}.${date.day}";
    }

    // 출고타입 PK, BOX, EA
    String type = data.mi_unit.isEmpty ? "" : "(${data.mi_unit})";

    return GestureDetector(
      onTap: () {
        Utils.showDetailDlg(context, title: data.mi_name, dismissible: true);
      },
      child: Row(
        children: [
          // Visibility(child: Icon(Icons.check_box_outline_blank), visible: !_isMultiSelect),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10),
              padding: const EdgeInsets.all(15),
              // height: 150,
              height: 160,
              decoration: WidgetFactory.boxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.mi_name, style: tsInvenItemName),
                          Text(data.mi_manufacturer, style: tsInvenItemCompany),
                          const Spacer(),
                          Row(
                            children: [
                              Text("${"current qty".tr} (${data.mst_base_stock})", style: tsInvenItemCompany),
                              Text("/${"safe list".tr} (${data.mi_safety_stock})", style: tsInvenItemCompany),
                            ],
                          ),
                          Text("${"ingredient".tr} (${data.mi_ingredients})", style: tsInvenItemCompany),
                          const SizedBox(height: 5),
                          Text("${"content".tr} ${amount}", style: tsInvenItemCompany.copyWith(color: Colors.black)),
                          Text("${"unit".tr} ${type}", style: tsProductItemBold),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      ProductResultData result = await _showInputCountDialog(context, code: data.mi_code);

                      if (result.isNotEmpty) {
                        Controllers.getController(type: widget.pageType).addProduct(data, result.count);
                        debugPrint("[animal] result: ${result.toString()}");
                        Get.back();
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 30, right: 10),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColorsEx.primaryColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        // color: Colors.red,
                        alignment: Alignment.centerRight,
                        child:
                            Center(child: Text("Select".tr, style: tsInvenItemCompany.copyWith(color: Colors.white)))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildEmpty() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Utils.ImageAsset("empty_box.png", width: 100, height: 100),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.grey,
            size: 50,
          ),
        ),
        // Text("empty".tr),
      ],
    ));
  }

  _showInputCountDialog(BuildContext context, {required String code}) async {
    bool productIn = false;
    if (widget.pageType == PageType.ProductIn || widget.pageType == PageType.ProductRegIn) {
      productIn = true;
    }

    ProductResultData result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return InputCountDialog(typeIn: productIn);
        });

    // Utils.keyboardHide();

    return result;
  }

  _buildMultiSelect() {
    return SizedBox(
      height: 40,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => setState(() => _isMultiSelect = !_isMultiSelect),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // Icon(_isMultiSelect ? Icons.check_box : Icons.check_box_outline_blank,
              //     color: _isMultiSelect ? ColorsEx.primaryColor : Colors.grey),
              Checkbox(
                onChanged: (value) {
                  setState(() {
                    _isMultiSelect = value ?? false;
                  });
                },
                value: _isMultiSelect,
                activeColor: ColorsEx.primaryColor,
                tristate: false,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              // SizedBox(width: 10),
              Text("Multi select".tr, style: tsDefault),
            ],
          ),
        ),
      ),
      // CheckboxListTile(
      //   controlAffinity: ListTileControlAffinity.leading,
      //   title: Text("Multi select".tr),
      //   value: _isMultiSelect,
      //   // contentPadding: EdgeInsets.zero,
      //   onChanged: (value) {
      //     setState(() {
      //       _isMultiSelect = value ?? false;
      //     });
      //   },
      // ),
    );
  }
}
