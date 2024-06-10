// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/enums.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';
import 'package:ku_animal_m/src/ui/search/search_home_controller.dart';

// 전체검색 결과 화면
// 메인화면에서 검색어를 입력하여 검색시 이동되는 화면
class PageSearchResult extends StatefulWidget {
  PageSearchResult({super.key, required this.searchText, this.pageType = PageType.Home});

  final String searchText;
  PageType pageType;

  @override
  State<PageSearchResult> createState() => _PageSearchResultState();
}

class _PageSearchResultState extends State<PageSearchResult> {
  @override
  Widget build(BuildContext context) {
    int itemCount = SearchHomeController.to.getCount();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "검색어(${widget.searchText})",
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: itemCount == 0
                  ? _buildEmpty()
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        return _buildProductItem(index);
                      },
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
        Utils.showDetailDlg(context, title: data.mi_name, content: regDate);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
        padding: const EdgeInsets.all(15),
        // height: 150,
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
                    // const Spacer(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text("${"current qty".tr} (${data.mst_base_stock})", style: tsInvenItemCompany),
                        Text("/${"safe list".tr} (${data.mi_safety_stock})", style: tsInvenItemCompany),
                      ],
                    ),
                    Text("${"ingredient".tr} (${data.mi_ingredients})", style: tsInvenItemCompany),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${"content".tr} ${amount}", style: tsInvenItemCompany.copyWith(color: Colors.black)),
                        // Text(regDate, style: tsInvenItemCompany.copyWith(color: Colors.black)),
                        Text("${"unit".tr} ${type}", style: tsProductItemBold),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  backAction() {
    // if (widget.pageType == PageType.Home) {
    //   Get.off(PageHome());
    // } else {
    //   Get.back();
    // }

    return false;
  }
}
