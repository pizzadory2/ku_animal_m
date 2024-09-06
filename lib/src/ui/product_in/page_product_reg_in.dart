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
import 'package:ku_animal_m/src/ui/dialog/input_count_dialog.dart';
import 'package:ku_animal_m/src/ui/dialog/product_result_data.dart';
import 'package:ku_animal_m/src/ui/login/user_controller.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';
import 'package:ku_animal_m/src/ui/product_in/product_in_reg_controller.dart';
import 'package:ku_animal_m/src/ui/qr/page_qr_2.dart';
import 'package:ku_animal_m/src/ui/search/page_search_select.dart';
import 'package:ku_animal_m/src/ui/search/search_home_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PageProductRegIn extends StatefulWidget {
  const PageProductRegIn({super.key});

  @override
  State<PageProductRegIn> createState() => _PageProductRegInState();
}

class _PageProductRegInState extends State<PageProductRegIn> {
  bool _isLoading = false;

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final TextEditingController _controllerSearch = TextEditingController();
  int _filterIndex = 0;
  // FilterType _filterType = FilterType.Name;

  @override
  void initState() {
    ProductInRegController.to.clearData();
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
              foregroundColor: Colors.white,
              leading: IconButton(
                onPressed: (() => Get.back()),
                icon: const Icon(Icons.close),
              ),
              title: Text("in".tr, style: tsAppbarTitle),
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
                  debugPrint("QR");
                  Utils.keyboardHide();
                  var result = await Get.to(() => PageQR2(useDirect: false, pageType: PageType.ProductRegIn));

                  if (result != null) {
                    _controllerSearch.text = result;
                    _filterIndex = 5;
                    // _filterType = FilterType.Barcode;
                    searchData();
                  }
                },
                child: const Icon(Icons.qr_code_rounded, size: 30, color: Colors.black54),
              ),
            ),
          ],
        ));
  }

  _buildList() {
    int itemCount = ProductInRegController.to.getCount();

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
    bool isEnable = ProductInRegController.to.getCount() > 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 50,
      child: ElevatedButton(
          onPressed: isEnable
              ? () {
                  debugPrint("[animal] 입고등록 버튼 클릭");
                  // _showSelectMonthDialog(context);
                  ProductInRegController.to.regProduct(userSeq: UserController.to.userSeq).then((value) {
                    if (value == true) {
                      Utils.showToast("Stock registration has been completed".tr, isCenter: true);
                      Get.back();
                    }
                  });
                }
              : null,
          child: Center(
            child: Text(
              "in reg".tr,
              style: tsButtonDef,
            ),
          )
          // child: Container(
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     color: ColorsEx.primaryColor,
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Text("입고등록"),
          // ),
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
                pageType: PageType.ProductRegIn,
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

  // _showSelectMonthDialog(context) async {
  //   ProductResultData result = await showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return SelectMonthDialog();
  //       });

  //   // Utils.keyboardHide();

  //   if (result.isNotEmpty) {
  //     // Get.to(PageSearchResult(searchText: result), transition: Transition.fade);
  //     // searchData(result.txt, result.type);
  //   }

  //   // return result;
  // }

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

  // _showInputCountDialog(BuildContext context) async {
  //   ProductResultData result = await showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return InputCountDialog();
  //       });

  //   // Utils.keyboardHide();

  //   if (result.isNotEmpty) {
  //     // Get.to(PageSearchResult(searchText: result), transition: Transition.fade);
  //     // searchData(result.txt, result.type);
  //   }

  //   // return result;
  // }

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

  _buildEmpty() {
    return Container();
  }

  _buildProductItem(int index) {
    if (index >= ProductInRegController.to.getCount()) {
      return Container();
    }

    ProductModel data = ProductInRegController.to.getItem(index);

    return WidgetFactory.regItem(
      data: data,
      index: index,
      countText: "Enter quantity".tr,
      onPress: () {},
      onRemove: () {
        Utils.showYesNoDialog(context).then((value) {
          if (value == true) {
            setState(() {
              ProductInRegController.to.removeProduct(data);
            });
          }
        });
      },
      onChangeQty: () async {
        ProductResultData result = await _showInputCountDialog(context, code: data.mi_code);

        if (result.isNotEmpty) {
          setState(() {
            data.inout_count = result.count;
          });
        }
      },
    );
  }

  // _showYesNoDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(
  //             "Do you want to delete it?".tr,
  //             style: tsDialogBody,
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Get.back(result: false);
  //               },
  //               child: Text("No".tr),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Get.back(result: true);
  //               },
  //               child: Text("Yes".tr),
  //             ),
  //           ],
  //         );
  //       });
  // }
}
