import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/dimens.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/dialog/input_count_dialog.dart';
import 'package:ku_animal_m/src/ui/dialog/product_result_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PageProductRegIn extends StatefulWidget {
  const PageProductRegIn({super.key});

  @override
  State<PageProductRegIn> createState() => _PageProductRegInState();
}

class _PageProductRegInState extends State<PageProductRegIn> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final TextEditingController _controllerSearch = TextEditingController();
  int _filterIndex = 0;

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
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (() => Get.back()),
            icon: const Icon(Icons.close),
          ),
          title: Text("in".tr, style: tsAppbarTitle),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildSearch(),
              Divider(height: 1, color: Colors.grey[400]),
              _buildList(),
              _buildRegButton(),
            ],
          ),
        ));
  }

  _buildSearch() {
    return Container(
        color: Colors.white,
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

  _buildList() {
    return Expanded(child: Container());
  }

  _buildRegButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 50,
      child: ElevatedButton(
          onPressed: () {
            _showInputCountDialog(context);
          },
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
    //
  }

  _showInputCountDialog(BuildContext context) async {
    ProductResultData result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return InputCountDialog();
        });

    // Utils.keyboardHide();

    if (result.isNotEmpty) {
      // Get.to(PageSearchResult(searchText: result), transition: Transition.fade);
      // searchData(result.txt, result.type);
    }

    // return result;
  }
}
