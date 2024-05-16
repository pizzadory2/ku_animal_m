import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/constants.dart';
import 'package:ku_animal_m/src/common/dimens.dart';
import 'package:ku_animal_m/src/common/enums.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/product/product_history_model.dart';
import 'package:ku_animal_m/src/ui/product_in/product_in_controller.dart';
import 'package:ku_animal_m/src/ui/qr/page_qr_2.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// 입고 페이지
class PageProductIn extends StatefulWidget {
  const PageProductIn({super.key});

  @override
  State<PageProductIn> createState() => _PageProductInState();
}

class _PageProductInState extends State<PageProductIn> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final TextEditingController _controllerSearch = TextEditingController();
  int _filterIndex = 0;
  FilterType _filterType = FilterType.Name;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _controllerSearch.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            // floatingActionButton: _buildFAB(),
            backgroundColor: Colors.white,
            body: Column(
              children: [
                _buildSearch(),
                Row(children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 10),
                    child: Text("filter condition".tr, style: tsBold),
                  ),
                  Expanded(child: _buildFilter()),
                ]),
                Divider(height: 1, color: Colors.grey[400]),
                _buildList(),
              ],
            )),
      ],
    );
  }

  void initData() async {
    AppController.to.setLoading(true);

    Future.delayed(const Duration(seconds: 3), () {
      AppController.to.setLoading(false);
    });
  }

  // _buildFAB() {
  //   return Padding(
  //     padding: const EdgeInsets.all(1.0),
  //     child: FloatingActionButton(
  //       // mini: true,
  //       heroTag: "fab_add",
  //       backgroundColor: ColorsEx.primaryColorBold,
  //       onPressed: () {
  //         // Get.bottomSheet();
  //         Get.to(() => PageQR2(pageType: PageType.ProductInven));
  //         // var result = _showDirectInputDialog(context);
  //       },
  //       child: const Icon(Icons.add, color: Colors.white, size: 50),
  //     ),
  //   );
  // }

  _buildSearch() {
    return Container(
        height: Dimens.searchHeight,
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
                        onSubmitted: (value) {
                          searchData();
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
                                refreshData();
                              });
                            },
                            child: WidgetFactory.searchClearButton(),
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
                  searchData();
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
                onTap: () async {
                  debugPrint("[animal] [입고내역] Click QR");
                  // var result = Get.to(() => PageQR2(useDirect: false, pageType: PageType.ProductInven));
                  Utils.keyboardHide();
                  var result = await Get.to(() => PageQR2(useDirect: false, pageType: PageType.ProductIn));

                  if (result != null) {
                    _controllerSearch.text = result;
                    _filterIndex = 5;
                    _filterType = FilterType.Barcode;
                    searchData();
                  }
                },
                child: const Icon(Icons.qr_code_rounded, size: 30, color: Colors.black54),
              ),
            ),
          ],
        ));
  }

  _buildFilter() {
    return Container(
      height: 42,
      margin: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      color: Colors.white,
      // color: Colors.grey[100],
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _filterIndex = index;
                  _filterType = FilterType.values[index];
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
                  Constants.filterListAll[index],
                  style: tsDefault.copyWith(
                    color: _filterIndex == index ? Colors.black : Colors.grey,
                    fontWeight: _filterIndex == index ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
          itemCount: Constants.filterListAll.length),
    );
  }

  _buildList() {
    int itemCount = ProductInController.to.getCount();

    return Expanded(
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: () async {
          _controllerSearch.clear();
          await ProductInController.to.refreshData();
          setState(() {
            debugPrint("0000007777111111");
            debugPrint("0000000777722222");
            _refreshController.refreshCompleted();
            debugPrint("000000777733333");
          });
        },
        onLoading: () {
          _refreshController.loadComplete();
        },
        child: itemCount == 0
            ? WidgetFactory.emptyWidgetWithFunc(onTap: () => refreshData())
            : ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return _buildProductItem(index);
                },
              ),
      ),
    );
  }

  _buildProductItem(int index) {
    if (index >= ProductInController.to.getCount()) {
      return Container();
    }

    ProductHistoryModel data = ProductInController.to.getItem(index);
    // String amount = data.mst_content.isEmpty ? "-" : "(${data.mst_content})";

    // 출고타입 PK, BOX, EA
    // String type = data.mst_type.isEmpty ? "" : "(${data.mst_type})";
    String type = "(EA)";

    String person = data.msr_man.isEmpty ? "-" : data.msr_man;

    return GestureDetector(
      onTap: () {
        Utils.showDetailDlg(context, title: data.mi_name);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
        padding: const EdgeInsets.all(15),
        // height: 130,
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
                    Text(data.mi_name, style: tsInvenItemNameRequest.copyWith(color: ColorsEx.clrIn)),
                    Text("${data.mi_manufacturer} / ${data.mi_type_name} / ${data.mi_class_name}",
                        style: tsInvenItemCompany),
                    // const Spacer(),
                    const SizedBox(height: 10),
                    // Text("안전재고 (${data.mi_safety_stock})", style: tsInvenItemCompany),
                    Text("입고처리  ${person}", style: tsInvenItemCompany),
                    Text("주요성분 (${data.mi_ingredients})", style: tsInvenItemCompany),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${"Enter quantity".tr} (${data.msr_qty})", style: tsProductItemBold),
                        Container(
                            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            width: 90,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text("${"unit".tr} ${type}", style: tsProductItemBold)),
                      ],
                    ),
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

  // void refreshData() {
  //   Utils.keyboardHide();

  //   if (_controllerSearch.text.isEmpty) {
  //     Utils.showToast("Please input product name".tr);
  //     return;
  //   }
  //   _controllerSearch.clear();

  //   AppController.to.setLoading(true);
  //   Future.delayed(Duration(seconds: 3)).then((value) {
  //     setState(() {
  //       AppController.to.setLoading(false);
  //     });
  //   });
  // }

  Future<void> refreshData() async {
    AppController.to.setLoading(true);

    _controllerSearch.clear();
    await ProductInController.to.refreshData().then((value) => setState(() {
          // _controllerSearch.clear();
          AppController.to.setLoading(false);
        }));
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

  void searchData() {
    Utils.keyboardHide();

    if (_controllerSearch.text.isEmpty) {
      Utils.showToast("Please input product name".tr);
      return;
    }

    AppController.to.setLoading(true);

    ProductInController.to.refreshData(searchData: _controllerSearch.text, filterIndex: _filterIndex).then((value) {
      setState(() {
        // _controllerSearch.clear();
        AppController.to.setLoading(false);
      });
    });
  }
}
