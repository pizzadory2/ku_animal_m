import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';

class PageProductInOut extends StatefulWidget {
  const PageProductInOut({super.key});

  @override
  State<PageProductInOut> createState() => _PageProductInOutState();
}

class _PageProductInOutState extends State<PageProductInOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: _buildFAB(),
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            children: [
              _buildSearch(),
              Divider(height: 1, color: Colors.grey[400]),
              _buildList(),
              _buildInOut(),
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
            SizedBox(
              width: 90,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        debugPrint("입고");
                      },
                      child: Container(
                          decoration: WidgetFactory.boxDecoration(radius: 10),
                          height: 50,
                          child: Center(
                            child: Text(
                              "입고",
                              style: tsInvenItemTotalCount.copyWith(color: Colors.red),
                            ),
                          )),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        debugPrint("출고");
                      },
                      child: Container(
                          decoration: WidgetFactory.boxDecoration(radius: 10),
                          height: 50,
                          child: Center(
                            child: Text(
                              "출고",
                              style: tsInvenItemTotalCount.copyWith(color: Colors.blue),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildSearch() {
    return Container(
      color: Colors.white,
      height: 50,
    );
  }

  _buildInOut() {
    return Container(
      color: Colors.white,
      height: 80,
      child: Row(children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: ElevatedButton(
              onPressed: () {
                _showBottomSheet();
              },
              child: Text("in".tr),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: ElevatedButton(
              onPressed: () {},
              child: Text("out".tr),
            ),
          ),
        ),
      ]),
    );
  }

  _showBottomSheet() {
    Get.bottomSheet(
      SizedBox(
        height: 150,
        child: Column(
          children: [
            WidgetFactory.gripBar(color: Colors.black12), //
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.back();
                    },
                    child: _buildBottomItem(title: "QR 스캔", icon: Icons.qr_code),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.back();
                    },
                    child: _buildBottomItem(title: "직접 등록", icon: Icons.list_alt_sharp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
        // borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  _buildBottomItem({required String title, required IconData icon}) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 50),
            Text(title),
          ],
        ),
      ),
    );
  }

  // _buildFAB() {
  //   return Padding(
  //     padding: const EdgeInsets.all(1.0),
  //     child: Wrap(
  //       direction: Axis.vertical,
  //       children: <Widget>[
  //         FloatingActionButton(
  //           mini: true,
  //           heroTag: "fab_add",
  //           backgroundColor: ColorsEx.primaryColorBold,
  //           onPressed: () {
  //             // Get.bottomSheet();
  //           },
  //           child: const Icon(Icons.add, color: Colors.white, size: 35),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
