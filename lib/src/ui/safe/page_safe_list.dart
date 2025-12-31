import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/index/index_common.dart';
import 'package:ku_animal_m/src/ui/inventory/inven_controller.dart';
import 'package:ku_animal_m/src/ui/inventory/page_inven_order.dart';
import 'package:ku_animal_m/src/ui/product/inven_model.dart';
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            foregroundColor: Colors.white,
            // title: Text("${"safe list".tr}(${itemCount})"),
            title: Text("${"Safety stock not met".tr}(${itemCount})"),
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
    String type = data.mi_unit.isEmpty ? "" : "(${data.mi_unit})";

    int currentCount = data.mst_base_stock.isNotEmpty ? int.parse(data.mst_base_stock) : 0;
    int safeCount = data.mi_safety_stock.isNotEmpty ? int.parse(data.mi_safety_stock) : 0;

    return GestureDetector(
      onTap: () {
        Utils.showDetailDlg(context, title: data.mi_name, dismissible: true);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        // height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey[300]!)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${index + 1}. ${data.mi_name}",
                    style: tsSafeListItemName,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    // Utils.keyboardHide();
                    var result = await Get.to(PageInvenOrder(data: data));
                    if (result != null) {
                      // AppController.to.setLoading(true);
                      result.name = data.mi_name;
                      result.code = data.mi_code;
                      result.type = type.replaceAll("(", "").replaceAll(")", "");
                      InvenController.to.addOrderList(data: result);
                      Utils.showToast("Added to order request list".tr, isCenter: true);
                      // AppController.to.setLoading(false);
                    }
                  },
                  child: Container(
                    width: 30,
                    height: 20,
                    margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.topRight,
                    child: Icon(Icons.add_shopping_cart_outlined),
                  ),
                ),
              ],
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
                Spacer(),
                Visibility(
                  // visible: currentCount < safeCount,
                  visible: false,
                  child: Container(
                    // width: 100,
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      // color: Colors.green[300],
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "not enough".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
