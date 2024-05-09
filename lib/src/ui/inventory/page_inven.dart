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
import 'package:ku_animal_m/src/ui/dialog/product_result_data.dart';
import 'package:ku_animal_m/src/ui/dialog/select_month_dialog.dart';
import 'package:ku_animal_m/src/ui/inventory/inven_controller.dart';
import 'package:ku_animal_m/src/ui/inventory/page_inven_order.dart';
import 'package:ku_animal_m/src/ui/product/inven_model.dart';
import 'package:ku_animal_m/src/ui/qr/page_qr_2.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PageInven extends StatefulWidget {
  const PageInven({super.key});

  @override
  State<PageInven> createState() => _PageInvenState();
}

class _PageInvenState extends State<PageInven> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final TextEditingController _controllerSearch = TextEditingController();
  int _filterIndex = 0;
  FilterType _filterType = FilterType.Name;

  String _selectYear = "1900";
  String _selectMonth = "1";

  @override
  void initState() {
    _selectYear = DateTime.now().year.toString();
    _selectMonth = DateTime.now().month.toString();
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
    debugPrint("[animal] 00000인벤을 다시 그려");

    return Stack(
      children: [
        Scaffold(
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
              Row(children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 10),
                  child: Text("filter month".tr, style: tsBold),
                ),
                _buildYearMonth(),
              ]),
              Divider(height: 1, color: Colors.grey[400]),
              _buildList(),
            ],
          ),
        ),
        // Obx(() => Visibility(
        //       visible: InvenController.to.isLoading.value,
        //       child: Container(
        //           // color: Colors.black.withOpacity(0.5),
        //           // child: const Center(
        //           //   child: CircularProgressIndicator(),
        //           // ),
        //           ),
        //     ))
      ],
    );
  }

  // _buildSearch() {
  //   return Container(
  //       color: Colors.white,
  //       height: 50,
  //       child: Container(
  //         margin: const EdgeInsets.only(left: 10, right: 10),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: TextField(
  //                 decoration: InputDecoration(
  //                   border: InputBorder.none,
  //                   hintText: "search".tr,
  //                 ),
  //               ),
  //             ),
  //             IconButton(
  //               onPressed: () {},
  //               icon: const Icon(Icons.search),
  //             ),
  //           ],
  //         ),
  //       ));
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
                          if (_controllerSearch.text.isEmpty) {
                            Utils.showToast("Please input product name".tr);
                            return;
                          }

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
                  if (_controllerSearch.text.isEmpty) {
                    Utils.showToast("Please input product name".tr);
                    return;
                  }

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
                  var result = await Get.to(() => PageQR2(useDirect: false, pageType: PageType.ProductInven));

                  if (result != null) {
                    _controllerSearch.text = result;
                    _filterIndex = 4;
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
    int filterCount = 4;

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
          },
          itemCount: filterCount),
    );
  }

  _buildList() {
    // if (AppController.to.getLoading()) {
    //   return Container();
    // }

    int itemCount = InvenController.to.getCount();

    return Expanded(
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: () async {
          _controllerSearch.clear();
          await InvenController.to.refreshData();
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
    if (index >= InvenController.to.getCount()) {
      return Container();
    }

    InvenModel data = InvenController.to.getItem(index);
    String amount = data.mi_content.isEmpty ? "-" : "(${data.mi_content})";
    String ingredients = data.mi_ingredients.isEmpty ? "-" : data.mi_ingredients;

    int stockCount = data.mst_base_stock.isEmpty ? 0 : int.parse(data.mst_base_stock);
    bool isLongStockCount = data.mst_base_stock.length > 4;

    return GestureDetector(
      onTap: () {
        Utils.showDetailDlg(context, title: data.mi_name);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
        padding: const EdgeInsets.all(15),
        // height: 150,
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
                    Text(data.mi_name, style: tsInvenItemNameRequest),
                    Text(data.mi_manufacturer, style: tsInvenItemCompany),
                    const SizedBox(height: 10),
                    Text("안전재고 (${data.mi_safety_stock})", style: tsInvenItemCompany),
                    Text("주요성분 (${ingredients})", style: tsInvenItemCompany),
                    const SizedBox(height: 5),
                    Text("함량 ${amount}", style: tsInvenItemCompany.copyWith(color: Colors.black)),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    Utils.keyboardHide();
                    var result = await Get.to(PageInvenOrder(data: data));
                    if (result != null) {
                      // AppController.to.setLoading(true);
                      result.name = data.mi_name;
                      result.code = data.mi_code;
                      InvenController.to.addOrderList(data: result);
                      Utils.showToast("Added to order request list".tr, isCenter: true);
                      // AppController.to.setLoading(false);
                    }
                  },
                  child: Container(
                    width: 90,
                    height: 20,
                    alignment: Alignment.topRight,
                    child: Icon(Icons.add_shopping_cart_outlined),
                  ),
                ),
                SizedBox(height: 15),
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
                        Text("${stockCount}",
                            style: tsInvenItemTotalCount.copyWith(fontSize: isLongStockCount ? 18 : 24)),
                        // Text(data.mst_base_stock, style: tsInvenItemTotalCount),
                      ],
                    ),
                  ),
                ),
              ],
            )
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

  void refreshData() async {
    AppController.to.setLoading(true);

    _controllerSearch.clear();
    await InvenController.to.refreshData().then(
          (value) => setState(
            () {
              // _controllerSearch.clear();
              AppController.to.setLoading(false);
            },
          ),
        );
  }

  void searchData() {
    Utils.keyboardHide();

    AppController.to.setLoading(true);

    InvenController.to
        .searchData(
            searchData: _controllerSearch.text, filterIndex: _filterIndex, year: _selectYear, month: _selectMonth)
        .then((value) {
      setState(() {
        // _controllerSearch.clear();
        AppController.to.setLoading(false);
      });
    });

    // setState(() {
    //   AppController.to.setLoading(false);
    // });
  }

  _buildYearMonth() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showSelectMonthDialog(context);
        });
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 10, top: 3, right: 3, bottom: 3),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: ColorsEx.primaryColorLowGreen,
          border: Border.all(width: 1, color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(45),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${_selectYear}년 ${_selectMonth}월",
              style: tsDefault.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.black),
          ],
        ),
      ),
    );
  }

  _showSelectMonthDialog(context) async {
    Utils.keyboardHide();

    ProductResultData result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SelectMonthDialog(year: _selectYear, month: _selectMonth);
        });

    if (result.isNotEmpty) {
      _selectYear = result.year;
      _selectMonth = result.month;

      searchData();
    }

    // return result;
  }
}
