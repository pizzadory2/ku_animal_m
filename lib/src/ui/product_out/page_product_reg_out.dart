import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/constants.dart';
import 'package:ku_animal_m/src/common/enums.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/dialog/input_count_dialog.dart';
import 'package:ku_animal_m/src/ui/dialog/product_result_data.dart';
import 'package:ku_animal_m/src/ui/login/user_controller.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';
import 'package:ku_animal_m/src/ui/product_out/product_out_reg_controller.dart';
import 'package:ku_animal_m/src/ui/search/page_search_select.dart';
import 'package:ku_animal_m/src/ui/search/search_home_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PageProductRegOut extends StatefulWidget {
  const PageProductRegOut({super.key});

  @override
  State<PageProductRegOut> createState() => _PageProductRegOutState();
}

class _PageProductRegOutState extends State<PageProductRegOut> {
  bool _isLoading = false;

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final TextEditingController _controllerSearch = TextEditingController();
  int _filterIndex = 0;

  @override
  void initState() {
    ProductOutRegController.to.clearData();
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
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                onPressed: (() => Get.back()),
                icon: const Icon(Icons.close),
              ),
              title: Text("out".tr, style: tsAppbarTitle),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
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
                  // Row(children: [
                  //   Container(
                  //     alignment: Alignment.center,
                  //     margin: EdgeInsets.only(left: 10),
                  //     child: Text("입고월".tr, style: tsBold),
                  //   ),
                  //   Expanded(child: _buildFilter()),
                  // ]),
                  Divider(height: 1, color: Colors.grey[400]),
                  _buildList(),
                  _buildRegButton(),
                ],
              ),
            )),
        WidgetFactory.loadingWidget(isLoading: _isLoading, title: "Loading...".tr, isBackground: false),
      ],
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
                onTap: () {
                  debugPrint("QR");
                },
                child: const Icon(Icons.qr_code_rounded, size: 30, color: Colors.black54),
              ),
            ),
          ],
        ));
  }

  _buildList() {
    int itemCount = ProductOutRegController.to.getCount();

    return Expanded(
      child: itemCount == 0
          ? _buildEmpty()
          : ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return _buildProductItem(index);
              },
            ),
    );
  }

  _buildRegButton() {
    bool isEnable = ProductOutRegController.to.getCount() > 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 50,
      child: ElevatedButton(
          onPressed: isEnable
              ? () {
                  debugPrint("[animal] 출고등록 버튼 클릭");
                  ProductOutRegController.to.regProduct(userSeq: UserController.to.userSeq).then((value) {
                    if (value == true) {
                      Utils.showToast("Delivery registration has been completed".tr, isCenter: true);
                      Get.back();
                    }
                  });
                }
              : null,
          child: Center(
            child: Text(
              "out reg".tr,
              style: tsButtonDef,
            ),
          )),
    );
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

  _buildEmpty() {
    return Container();
  }

  _buildProductItem(int index) {
    if (index >= ProductOutRegController.to.getCount()) {
      return Container();
    }

    ProductModel data = ProductOutRegController.to.getItem(index);
    String amount = data.mi_content.isEmpty ? "-" : "(${data.mi_content})";
    String regDate = data.reg_date;
    if (regDate.isNotEmpty) {
      var date = DateTime.parse(regDate);
      regDate = "등록일 ${date.year}.${date.month}.${date.day}";
    }

    return GestureDetector(
      onTap: () {
        debugPrint("[animal] ::추가된 아이템 클릭(${index})");
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
        padding: const EdgeInsets.all(15),
        height: 150,
        decoration: WidgetFactory.boxDecoration(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text(data.mi_name, style: tsInvenItemName)),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Utils.showYesNoDialog(context).then((value) {
                      if (value == true) {
                        setState(() {
                          ProductOutRegController.to.removeProduct(data);
                        });
                      }
                    });
                  },
                  child: Icon(Icons.close, size: 20, color: Colors.grey),
                ),
                SizedBox(width: 5),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 3, right: 45),
              child:
                  Text("${data.mi_manufacturer} / ${data.mi_type_name} / ${data.mi_class_name}", style: tsProductItem),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(data.mi_manufacturer, style: tsProductItem),
                          const Spacer(),
                          // Text("(${data.mi_type_name}/${data.mi_class_name})", style: tsProductItem),
                          Text("주요성분 (${data.mi_ingredients})", style: tsProductItem),
                          const SizedBox(height: 5),
                          Text("함량 ${amount}", style: tsProductItem),
                        ],
                      ),
                    ),
                  ),
                  _buildInOutCount(data),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildInOutCount(ProductModel data) {
    String dspCount = Utils.numberFormatMoney(data.inout_count);

    return Container(
      width: 120,
      margin: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          ProductResultData result = await _showInputCountDialog(context, code: data.mi_code);

          if (result.isNotEmpty) {
            setState(() {
              data.inout_count = result.count;
            });
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: 7, right: 7, top: 1, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "${"Enter quantity".tr} ${dspCount}",
                style: tsProductItemBold,
              ),
              SizedBox(width: 5),
              Container(padding: EdgeInsets.only(top: 2), child: Icon(Icons.edit, color: Colors.black54, size: 16)),
            ],
          ),
        ),
      ),
    );
  }

  searchData() {
    Utils.keyboardHide();

    if (_controllerSearch.text.isEmpty) {
      Utils.showToast("Please input product name".tr);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String type = Utils.getSearchType(filterIndex: _filterIndex);

    debugPrint("[animal] 검색어는: ${_controllerSearch.text}, 타입은: $type");

    SearchHomeController.to.searchData(type: type, searchData: _controllerSearch.text).then((value) {
      setState(() {
        _controllerSearch.clear();
        _isLoading = false;
      });

      if (SearchHomeController.to.getCount() == 0) {
        // Get.snackbar("KU VMTH", "No search results".tr);
        Utils.showToast("No search results".tr, isCenter: true);
        return;
      }

      Get.to(
              PageSearchSelect(
                title: "Please select the product you wish to stock".tr,
                pageType: PageType.ProductRegOut,
              ),
              transition: Transition.fade)
          ?.then((value) {
        setState(() {
          // _controllerSearch.clear();
          // _isLoading = false;
          debugPrint("[animal] 입고등록창에서 제품검색 후 돌아왔다");
        });
      });
    });
  }

  _showInputCountDialog(BuildContext context, {required String code}) async {
    ProductResultData result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return InputCountDialog();
        });

    // Utils.keyboardHide();

    return result;
  }
}
