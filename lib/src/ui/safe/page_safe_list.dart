import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/ui/product/inven_model.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';
import 'package:ku_animal_m/src/ui/search/search_home_controller.dart';

class PageSafeList extends StatefulWidget {
  const PageSafeList({super.key});

  @override
  State<PageSafeList> createState() => _PageSafeListState();
}

class _PageSafeListState extends State<PageSafeList> {
  bool _isLoading = true;

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<InvenModel> safeList = SearchHomeController.to.getSafeList();
    int itemCount = safeList.length;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("${"safe list".tr}(${itemCount})"),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    interactive: true,
                    // trackVisibility: true,
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        return generateItem(safeList[index], index);
                        // var data = safeList[index];
                        // return ListTile(
                        //   title: Text("${index + 1}. ${data.mst_name}"),
                        //   subtitle: Text("${data.mst_class}"),
                        // );
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
    SearchHomeController.to.searchSafeMidal().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  generateItem(InvenModel data, int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 1, color: Colors.grey[300]!)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${index + 1}. ${data.mi_name}",
            style: TextStyle(overflow: TextOverflow.ellipsis),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                  width: 100,
                  height: 25,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.red[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "${"safe list".tr} ${data.mi_safety_stock}",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              SizedBox(width: 10),
              Container(
                  width: 100,
                  height: 25,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "${"current qty".tr} ${data.mst_base_stock}",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
