import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/ui/search/search_home_controller.dart';

// 전체 품목수
// 메인화면(대시보드)에서 표시되는 전체 품목수 선택시 이동되는 화면
class PageProductList extends StatefulWidget {
  const PageProductList({super.key});

  @override
  State<PageProductList> createState() => _PageProductListState();
}

class _PageProductListState extends State<PageProductList> {
  bool _isLoading = true;

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = SearchHomeController.to.getCount();
    String title = "${"product list".tr}(${itemCount})";

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            foregroundColor: Colors.white,
            title: Text(title),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        return _buildProductItem(index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        WidgetFactory.loadingWidget(isLoading: _isLoading, title: "Loading...".tr),
      ],
    );
  }

  void refreshData() {
    SearchHomeController.to.searchData(type: "", searchData: "").then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  _buildProductItem(int index) {
    var item = SearchHomeController.to.getItem(index);
    String title = item.mi_name;
    // title += "동해물과 백두산이 마르고 닳도록";

    return GestureDetector(
      onTap: () {
        //
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("No.${index + 1}"),
              ],
            ),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              item.mi_content,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 5),
            Text(
              item.reg_date,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
