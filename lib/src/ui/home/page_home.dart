import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:ku_animal_m/src/common/dimens.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/chart/chart_sample.dart';
import 'package:ku_animal_m/src/ui/product/product_history_model.dart';
import 'package:ku_animal_m/src/ui/search/page_search.dart';
import 'package:ku_animal_m/src/ui/setting/page_setting.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final List<ProductHistoryModel> _listDummy = [];

  @override
  void initState() {
    _funcMakeDummyData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  _buildGreeting() {
    String name = "홍길동";
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Row(
        children: [
          const FaIcon(FontAwesomeIcons.thumbsUp, color: ColorsEx.primaryColor),
          const SizedBox(width: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              color: ColorsEx.primaryColorBold,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const Text("님 안녕하세요", style: TextStyle(fontSize: 22, height: 1.3)),
          // const FaIcon(FontAwesomeIcons.faceGrin, color: ColorsEx.primaryColor),
        ],
      ),
    );
  }

  _buildProductInOutStatus() {
    String start = "2021-09-01";
    String end = "2021-09-07";

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
                  Text("물품 입출고 현황", style: tsMainBoxTitle),
                  Text("최근 1주일", style: tsMainBoxNormal),
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
                        const Icon(Icons.arrow_downward, color: Colors.blue),
                        SizedBox(
                          height: 40,
                          child: Text("187", style: tsMainBoxInOutCount),
                        ),
                        const SizedBox(
                          height: 20,
                          child: Text("입고"),
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
                        const Icon(Icons.arrow_upward, color: Colors.red),
                        SizedBox(
                          height: 40,
                          child: Text("356", style: tsMainBoxInOutCount),
                        ),
                        const SizedBox(
                          height: 20,
                          child: Text("출고"),
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
              child: Text("제품 현황", style: tsMainBoxTitle),
            ),
            const SizedBox(height: 10),
            _buildSelectItem(
              title: "안전재고 미충족",
              count: 10,
              func: () {
                // Get.toNamed("/inven");
                debugPrint("안전재고 미충족");
              },
            ),
            _buildSelectItem(
              title: "전체 품목수",
              count: 256,
              func: () {
                debugPrint("전체 품목수");
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
      padding: const EdgeInsets.symmetric(horizontal: Dimens.boxPadding, vertical: Dimens.boxPadding),
      decoration: WidgetFactory.boxDecoration(),
      child: Center(
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            Expanded(
              child: GestureDetector(
                onTap: () => Get.to(const PageSearch()),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 20,
                  child: const Text("제품을 검색해 주세요", style: TextStyle(color: Colors.grey, fontSize: 18)),
                ),
              ),
            ),
            WidgetFactory.dividerVer(color: Colors.grey, height: 20, margin: 10),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                debugPrint("검색");
              },
              child: const Icon(Icons.qr_code_scanner_sharp, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  _buildRecentlyInOut() {
    // 최대 5개
    int recentlyCount = _listDummy.length;

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
              child: Text("최근 입출고 제품", style: tsMainBoxTitle),
            ),
            const SizedBox(height: 10),
            recentlyCount == 0
                ? const Text("최근 입출고 제품이 없습니다.")
                : Column(
                    children: List.generate(recentlyCount, (i) {
                      return _buildProductInfo(
                        data: _listDummy[i],
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
  _buildProductInfo({required ProductHistoryModel data, required int index}) {
    // ProductHistoryModel model = ProductHistoryModel(
    //   name: "맥시부펜",
    //   company: "한국제약",
    //   inoutCount: "30",
    //   totalCount: "200",
    //   regDate: "2021-09-01",
    //   regUser: "superman",
    // );

    return Container(
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
                  data.name,
                  style: tsMainRecentlyName,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                alignment: Alignment.centerRight,
                width: 100,
                child: Text(
                  data.regDate,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              data.productIn
                  ? const Icon(Icons.keyboard_double_arrow_down, color: Colors.blue)
                  : const Icon(Icons.keyboard_double_arrow_up, color: Colors.red),
              //const FaIcon(FontAwesomeIcons.arrow, color: Colors.blue)
              // : const FaIcon(FontAwesomeIcons.arrowUp, color: Colors.red),
              Text(
                data.productIn ? "입고 ${data.inoutCount}건" : "출고 ${data.inoutCount}건",
                style: tsMainRecentlyCount,
              ),
              Text(
                "/전체 ${data.totalCount}개",
                style: tsMainRecentlyCount,
              ),
              const Spacer(),
              Text(
                data.regUser,
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
      _listDummy.add(ProductHistoryModel(
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
}
