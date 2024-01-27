import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ku_animal_m/src/common/dimens.dart';
import 'package:ku_animal_m/src/common/enums.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/dialog/search_dialog.dart';
import 'package:ku_animal_m/src/ui/dialog/search_filter_dialog.dart';
import 'package:ku_animal_m/src/ui/dialog/search_result_data.dart';
import 'package:ku_animal_m/src/ui/home/home_controller.dart';
import 'package:ku_animal_m/src/ui/home/home_model.dart';
import 'package:ku_animal_m/src/ui/login/user_controller.dart';
import 'package:ku_animal_m/src/ui/product/page_product_list.dart';
import 'package:ku_animal_m/src/ui/product/product_recently_model.dart';
import 'package:ku_animal_m/src/ui/product_in/page_product_reg_in.dart';
import 'package:ku_animal_m/src/ui/product_out/page_product_reg_out.dart';
import 'package:ku_animal_m/src/ui/qr/page_qr_2.dart';
import 'package:ku_animal_m/src/ui/safe/page_safe_list.dart';
import 'package:ku_animal_m/src/ui/search/page_search_result.dart';
import 'package:ku_animal_m/src/ui/search/search_home_controller.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final List<ProductRecentlyModel> _listDummy = [];

  bool _isLoading = true;

  @override
  void initState() {
    _funcMakeDummyData();

    // refreshData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: _buildFAB(),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Column(
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 10),
                  _buildProductInOutStatus(),
                  const SizedBox(height: 20),
                  _buildInventoryStatus(),
                  const SizedBox(height: 20),
                  _buildSearch(),
                  const SizedBox(height: 20),
                  _buildRecentlyInOut(),
                ],
              ),
            ],
          ),
        ),
        // const Loading(),
      ],
    );
  }

  _buildGreeting() {
    String name = UserController.to.userName;
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Row(
        children: [
          const FaIcon(FontAwesomeIcons.thumbsUp, color: ColorsEx.primaryColor),
          const SizedBox(width: 10),
          _buildHello(name: name),
        ],
      ),
    );
  }

  _buildProductInOutStatus() {
    String start = HomeController.to.homeModel.monthData.start;
    String end = HomeController.to.homeModel.monthData.end;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.boxPadding, vertical: Dimens.boxPadding),
      height: 200,
      decoration: WidgetFactory.boxDecoration(),
      child: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: double.infinity,
              height: Dimens.boxTitleHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Status of in and out".tr, style: tsMainBoxTitle),
                  // Text("Last week".tr, style: tsMainBoxNormal),
                ],
              ),
            ),
            Container(
              // child: ChartSample(),
              child: Row(children: [
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        // const Icon(Icons.arrow_downward, color: Colors.blue),
                        const Icon(Icons.file_download_rounded, color: Colors.blue),
                        SizedBox(
                          height: 40,
                          child: Text("${HomeController.to.homeModel.monthData.inCount}", style: tsMainBoxInOutCount),
                        ),
                        SizedBox(
                          height: 20,
                          child: Text("in".tr),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        // const Icon(Icons.arrow_upward, color: Colors.red),
                        const Icon(Icons.file_upload_rounded, color: Colors.red),
                        SizedBox(
                          height: 40,
                          child: Text("${HomeController.to.homeModel.monthData.outCount}", style: tsMainBoxInOutCount),
                        ),
                        SizedBox(
                          height: 20,
                          child: Text("out".tr),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text("($start ~ $end)", style: const TextStyle(fontSize: 17)),
            ),
          ],
        ),
      ),
    );
  }

  _buildInventoryStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.boxPadding, vertical: Dimens.boxPadding),
      decoration: WidgetFactory.boxDecoration(),
      child: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: double.infinity,
              height: Dimens.boxTitleHeight,
              child: Text("Product Status".tr, style: tsMainBoxTitle),
            ),
            const SizedBox(height: 10),
            _buildSelectItem(
              title: "Safety stock not met".tr,
              count: HomeController.to.homeModel.itemStatusData.safeCount,
              func: () {
                // Get.toNamed("/inven");
                debugPrint("안전재고 미충족");
                Get.to(PageSafeList());
              },
            ),
            _buildSelectItem(
              title: "Product Total Count".tr,
              count: HomeController.to.homeModel.itemStatusData.totalCount,
              func: () {
                debugPrint("전체 품목수");
                Get.to(PageProductList());
              },
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildSelectItem({required String title, int count = -1, required Function() func}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: func,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          // FaIcon(FontAwesomeIcons.chevronRight, color: ColorsEx.primaryColor),
          const Spacer(),
          count == -1
              ? Container()
              : Text(
                  "$count건",
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 30),
        ],
      ),
    );
  }

  _buildSearch() {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: Dimens.boxPadding, vertical: Dimens.boxPadding),
      padding: const EdgeInsets.symmetric(horizontal: Dimens.boxPadding),
      height: 60,
      decoration: WidgetFactory.boxDecoration(),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.search, color: Colors.grey),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                // onTap: () => Get.to(const PageSearch()),
                onTap: () {
                  _showDirectInputDialog(context);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text("search hint".tr, style: tsSearchHint),
                ),
              ),
            ),
            WidgetFactory.dividerVer(color: Colors.grey, height: 20, margin: 0),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                debugPrint("[animal] 바코드(QR) 검색");
                Get.to(() => PageQR2(useDirect: false, pageType: PageType.Home));
              },
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                color: Colors.white,
                height: double.infinity,
                // width: 50,
                child: const Icon(Icons.qr_code_scanner_sharp, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildRecentlyInOut() {
    // 최대 5개
    // int recentlyCount = _listDummy.length;
    int recentlyCount = HomeController.to.homeModel.recentDatas.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.boxPadding, vertical: Dimens.boxPadding),
      decoration: WidgetFactory.boxDecoration(),
      child: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: double.infinity,
              height: Dimens.boxTitleHeight,
              child: Text("Recently shipped products".tr, style: tsMainBoxTitle),
            ),
            const SizedBox(height: 10),
            recentlyCount == 0
                ? const Text("최근 입출고 제품이 없습니다.")
                : Column(
                    children: List.generate(recentlyCount, (i) {
                      return _buildProductInfo(
                        index: i,
                      );
                    }),
                  ),
          ],
        ),
      ),
    );
  }

  // 품명, 입고/출고, 수량, 총수량, 날짜
  _buildProductInfo({required int index}) {
    // ProductRecentlyModel model = ProductRecentlyModel(
    //   name: "맥시부펜",
    //   company: "한국제약",
    //   inoutCount: "30",
    //   totalCount: "200",
    //   regDate: "2021-09-01",
    //   regUser: "superman",
    // );

    RecentData data = HomeController.to.homeModel.recentDatas[index];
    String date = Utils.getFormatDate(DateTime.parse(data.msr_date));

    return SizedBox(
      height: 80,
      // color: Colors.amber,
      // margin: EdgeInsets.only(bottom: index == 4 ? 0 : 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  data.mi_name,
                  style: tsMainRecentlyName,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                alignment: Alignment.centerRight,
                width: 100,
                child: Text(
                  date,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Utils.ImageAsset("product_in.png", width: 20, height: 20),
              data.msr_type == "IN"
                  ? const Icon(Icons.keyboard_double_arrow_down, color: Colors.blue)
                  : const Icon(Icons.keyboard_double_arrow_up, color: Colors.red),
              //const FaIcon(FontAwesomeIcons.arrow, color: Colors.blue)
              // : const FaIcon(FontAwesomeIcons.arrowUp, color: Colors.red),
              Text(
                data.msr_type == "IN" ? "입고 ${data.msr_qty}건" : "출고 ${data.msr_qty}건",
                style: tsMainRecentlyCount,
              ),
              // Text(
              //   "/전체 ${data.totalCount}개",
              //   style: tsMainRecentlyCount,
              // ),
              const Spacer(),
              Text(
                data.msr_man,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 5),
          WidgetFactory.dividerDash(),
        ],
      ),
    );
  }

  void _funcMakeDummyData() {
    List<String> listName = ["맥시부펜", "타이레놀", "아스피린", "펜타졸린", "펜토스틴"];
    List<String> listCompany = ["한국제약", "한국제약", "한국제약", "한국제약", "한국제약"];
    List<String> listInoutCount = ["30", "20", "10", "50", "100"];
    List<String> listTotalCount = ["200", "100", "50", "300", "500"];
    List<String> listRegDate = ["2021-09-01", "2021-09-02", "2021-09-03", "2021-09-04", "2021-09-05"];
    List<String> listUser = ["superman", "ironman", "spiderman", "sandman", "kuman"];
    List<bool> listProductIn = [true, false, true, false, true];

    for (int i = 0; i < 5; i++) {
      _listDummy.add(ProductRecentlyModel(
        name: listName[i],
        company: listCompany[i],
        inoutCount: listInoutCount[i],
        totalCount: listTotalCount[i],
        regDate: listRegDate[i],
        regUser: listUser[i],
        productIn: listProductIn[i],
      ));
    }
  }

  _buildHello({required String name}) {
    if (AppController.to.language == "ko") {
      return Row(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              color: ColorsEx.primaryColorBold,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          Text("Hello".tr, style: const TextStyle(fontSize: 22, height: 1.3)),
          // const FaIcon(FontAwesomeIcons.faceGrin, color: ColorsEx.primaryColor),
        ],
      );
    } else {
      return Row(
        children: [
          Text("Hello".tr, style: const TextStyle(fontSize: 22, height: 1.3)),
          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              color: ColorsEx.primaryColorBold,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          // const FaIcon(FontAwesomeIcons.faceGrin, color: ColorsEx.primaryColor),
        ],
      );
    }
  }

  _showDirectInputDialog(BuildContext context) async {
    SearchResultData result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          // return SearchDialog();
          return SearchFilterDialog();
        });

    // Utils.keyboardHide();

    if (result.isNotEmpty) {
      // Get.to(PageSearchResult(searchText: result), transition: Transition.fade);
      searchData(result.txt, result.type);
    }

    return result;
  }

  void searchData(String searchText, String type) {
    if (searchText.isEmpty) {
      Utils.showToast("Please input product name".tr);
      return;
    }

    AppController.to.setLoading(true);

    SearchHomeController.to.searchData(type: type, searchData: searchText).then((value) {
      setState(() {
        AppController.to.setLoading(false);
        Get.to(PageSearchResult(searchText: searchText), transition: Transition.rightToLeft);
      });
    });
  }

  _buildFAB() {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: UserController.to.userData.inReg,
            child: FloatingActionButton(
              // mini: true,
              heroTag: "fab_out",
              backgroundColor: ColorsEx.clrOut,
              onPressed: () {
                // Get.bottomSheet();
                Get.to(() => const PageProductRegOut());
                // var result = _showDirectInputDialog(context);
              },
              child: Text("out".tr, style: tsMainFabTitle),
            ),
          ),
          SizedBox(height: 10),
          Visibility(
            visible: UserController.to.userData.outReg,
            child: FloatingActionButton(
              // mini: true,
              heroTag: "fab_in",
              backgroundColor: ColorsEx.clrIn,
              onPressed: () {
                // Get.bottomSheet();
                Get.to(() => const PageProductRegIn());
                // var result = _showDirectInputDialog(context);
              },
              child: Text("in".tr, style: tsMainFabTitle),
            ),
          ),
        ],
      ),
    );
  }

  // void refreshData() async {
  //   AppController.to.setLoading(true);

  //   Future.delayed(const Duration(seconds: 3), () {
  //     AppController.to.setLoading(false);
  //   });
  // }
}
