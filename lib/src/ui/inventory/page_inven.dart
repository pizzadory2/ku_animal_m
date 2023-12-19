import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/dimens.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';

class PageInven extends StatefulWidget {
  const PageInven({super.key});

  @override
  State<PageInven> createState() => _PageInvenState();
}

class _PageInvenState extends State<PageInven> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildSearch(),
          Divider(height: 1, color: Colors.grey[400]),
          _buildList(),
        ],
      ),
    );
  }

  _buildSearch() {
    return Container(
        color: Colors.white,
        height: 50,
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "search".tr,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
            ],
          ),
        ));
  }

  _buildList() {
    return Expanded(
      child: ListView.builder(
        itemCount: 35,
        itemBuilder: (context, index) {
          return _buildProductItem(index);
        },
      ),
    );
  }

  _buildProductItem(int index) {
    ProductModel data = ProductModel(
      id: "1",
      name: "맥시부펜",
      company: "한미양행",
      safeCount: "30",
      quantity: "275",
      element: "염산, 요오드, 토마토",
      regDate: "2021-09-01",
      description: "오늘 내일 매일 사용",
      // mainIngredient: "염산, 요오드, 토마토",
    );

    return GestureDetector(
      onTap: () {
        //
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
        padding: const EdgeInsets.all(15),
        height: 150,
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
                    Text(data.name, style: tsInvenItemName),
                    Text(data.company, style: tsInvenItemCompany),
                    const Spacer(),
                    Text("안전재고 (${data.safeCount})", style: tsInvenItemCompany),
                    Text("주요성분 (${data.element})", style: tsInvenItemCompany),
                    const SizedBox(height: 5),
                    Text("등록일 (${data.regDate})", style: tsInvenItemCompany.copyWith(color: Colors.black)),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(width: 1, color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(45),
              ),
              width: 90,
              height: 90,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("quantity".tr, style: tsInvenItemTotalCount),
                    Text("275", style: tsInvenItemTotalCount),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
