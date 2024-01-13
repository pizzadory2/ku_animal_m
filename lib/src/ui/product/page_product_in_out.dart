import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';

class PageProductInOut extends StatefulWidget {
  const PageProductInOut({super.key});

  @override
  State<PageProductInOut> createState() => _PageProductInOutState();
}

class _PageProductInOutState extends State<PageProductInOut> {
  final TextEditingController _controllerSearch = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: _buildFAB(),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildSearch(),
            Divider(height: 1, color: Colors.grey[400]),
            _buildList(),
            _buildInOut(),
          ],
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
                              "in".tr,
                              style: tsInvenItemTotalCount.copyWith(color: Colors.blue),
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
                              "out".tr,
                              style: tsInvenItemTotalCount.copyWith(color: Colors.red),
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
        height: 55,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controllerSearch,
                        onChanged: (value) {
                          setState(() {});
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "search hint".tr,
                          hintStyle: tsSearchHint,
                        ),
                      ),
                    ),
                    _controllerSearch.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _controllerSearch.clear();
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.clear,
                                  size: 24,
                                  color: Colors.black54,
                                )),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: AppController.to.language == "ko" ? 80 : 90,
              child: ElevatedButton(
                onPressed: () {
                  //
                },
                child: Text(
                  "search".tr,
                  style: tsSearch,
                ),
              ),
            ),
            WidgetFactory.dividerVer(height: 30, color: Colors.black12, margin: 10),
            SizedBox(
              // width: 50,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  debugPrint("QR");
                },
                child: const Icon(Icons.qr_code_rounded, size: 30, color: Colors.black54),
              ),
            ),
          ],
        ));
  }

  _buildInOut() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      height: 50,
      child: Row(children: [
        Expanded(
          child: SizedBox(
            height: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showBottomSheet();
              },
              child: Text("in".tr, style: tsButtonDef),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showBottomSheet();
              },
              child: Text("out".tr, style: tsButtonDef),
            ),
          ),
        ),
      ]),
    );
  }

  _showBottomSheet() {
    Get.bottomSheet(
      SizedBox(
        height: 170,
        child: Column(
          children: [
            WidgetFactory.gripBar(color: Colors.black12), //
            const SizedBox(height: 5),
            Row(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.back();
                    },
                    child: _buildBottomItem(title: "scan to qr".tr, icon: Icons.qr_code),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.back();
                    },
                    // child: _buildBottomItem(title: "Direct".tr, icon: Icons.list_alt_sharp),
                    child: _buildBottomItem(title: "Direct".tr, icon: Icons.keyboard),
                  ),
                ),
                const SizedBox(width: 10),
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
      height: 80,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(247, 248, 250, 1),
        border: Border.all(color: const Color.fromRGBO(234, 236, 237, 1)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.black54,
            ),
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
