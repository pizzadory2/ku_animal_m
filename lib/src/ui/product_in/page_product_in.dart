import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/enums.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/qr/page_qr_2.dart';

// 입고 페이지
class PageProductIn extends StatefulWidget {
  const PageProductIn({super.key});

  @override
  State<PageProductIn> createState() => _PageProductInState();
}

class _PageProductInState extends State<PageProductIn> {
  final TextEditingController _controllerSearch = TextEditingController();

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
          ],
        ));
  }

  void initData() async {
    AppController.to.setLoading(true);

    Future.delayed(const Duration(seconds: 3), () {
      AppController.to.setLoading(false);
    });
  }

  _buildFAB() {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: FloatingActionButton(
        // mini: true,
        heroTag: "fab_add",
        backgroundColor: ColorsEx.primaryColorBold,
        onPressed: () {
          // Get.bottomSheet();
          Get.to(() => PageQR2(pageType: PageType.ProductInven));
          // var result = _showDirectInputDialog(context);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 50),
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
                  refreshData();
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
                  debugPrint("[animal] [입고내역] Click QR");
                  Get.to(() => PageQR2(useDirect: false, pageType: PageType.ProductIn));
                },
                child: const Icon(Icons.qr_code_rounded, size: 30, color: Colors.black54),
              ),
            ),
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
    return GestureDetector(
      onTap: () {
        //
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
        padding: const EdgeInsets.all(15),
        height: 130,
        decoration: WidgetFactory.boxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(data.name, style: tsInvenItemName.copyWith(color: ColorsEx.clrIn)),
                    // Text(data.company, style: tsInvenItemCompany),
                    // const Spacer(),
                    // Text("안전재고 (${data.safeCount})", style: tsInvenItemCompany),
                    // Text("주요성분 (${data.element})", style: tsInvenItemCompany),
                  ],
                ),
              ),
            ),
            // Container(
            //     margin: EdgeInsets.only(top: 5),
            //     alignment: Alignment.topRight,
            //     child: Text("등록일 (${data.regDate})", style: tsInvenItemCompany.copyWith(color: Colors.black))),
          ],
        ),
      ),
    );
  }

  void refreshData() {
    Utils.keyboardHide();

    if (_controllerSearch.text.isEmpty) {
      Utils.showToast("Please input product name".tr);
      return;
    }
    _controllerSearch.clear();

    AppController.to.setLoading(true);
    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() {
        AppController.to.setLoading(false);
      });
    });
  }

  // _showDirectInputDialog(BuildContext context) async {
  //   bool result = await showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return SearchDialog();
  //       });

  //   if (result) {}

  //   return result;
  // }
}
