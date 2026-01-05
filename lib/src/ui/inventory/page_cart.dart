import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/index/index_common.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/inventory/inven_controller.dart';
import 'package:ku_animal_m/src/ui/inventory/order_model.dart';

// 요청 리스트
class PageCart extends StatefulWidget {
  const PageCart({super.key});

  @override
  State<PageCart> createState() => _PageCartState();
}

class _PageCartState extends State<PageCart> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerReason = TextEditingController();

  int _totalCnt = 0;

  @override
  void initState() {
    _totalCnt = InvenController.to.getTotalOrderCount();

    super.initState();
  }

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerReason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // Navigator.pop(context);
              Get.back();
            },
            child: const Icon(Icons.arrow_back, color: Colors.white)),
        backgroundColor: ColorsEx.primaryColor,
        centerTitle: true,
        title: Text("request list".tr),
      ),
      body: SafeArea(
        child: _buildList(),
      ),
    );
  }

  _buildList() {
    int itemCount = InvenController.to.getOrderCount();
    return Column(
      children: [
        Expanded(
            child: itemCount > 0
                ? ListView.builder(
                    itemCount: InvenController.to.getOrderCount(),
                    itemBuilder: (context, index) {
                      return _buildItem(index);
                    },
                  )
                : Center(
                    child: Text("no data".tr),
                  )),
        // _buildTitle(),
        // _buildReason(),
        // SizedBox(height: 10),
        _buildBottom(),
      ],
    );
  }

  _buildItem(int index) {
    OrderModel order = InvenController.to.getOrder(index);

    // 출고타입 PK, BOX, EA
    String type = order.type.isEmpty ? "(-)" : "(${order.type})";
    // String type = "(EA)";

    return Container(
      padding: EdgeInsets.only(left: 30, top: 20, right: 30, bottom: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Container(
              //     decoration: BoxDecoration(
              //       color: Colors.grey.withOpacity(0.3),
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(5.0),
              //       child: Text("${index + 1}", style: tsDefault500.copyWith(fontSize: 20)),
              //     )),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Utils.showYesNoDialog(context, title: "Do you want to delete it?".tr).then((value) {
                    if (value == true) {
                      setState(() {
                        InvenController.to.removeOrder(index);
                      });
                    }
                  });
                },
                child: Row(
                  children: [
                    Text("delete".tr, style: tsDefault500.copyWith(color: Colors.grey)),
                    Icon(Icons.close, color: Colors.grey, size: 16),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(order.name, style: tsDefault500.copyWith(fontSize: 18))),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${"quantity".tr}  ${order.orderCount}", style: TextStyle(fontSize: 15)),
              Text("${"unit".tr} ${type}", style: tsProductItemBold),
            ],
          ),
        ],
      ),
    );
  }

  // _buildItem(int index) {
  //   OrderModel order = InvenController.to.getOrder(index);

  //   // 출고타입 PK, BOX, EA
  //   // String type = data.mst_type.isEmpty ? "" : "(${data.mst_type})";
  //   String type = "(EA)";

  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     padding: EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.grey),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Expanded(child: Text(order.name, style: tsDefault500.copyWith(fontSize: 20))),
  //             GestureDetector(
  //               onTap: () {
  //                 Utils.showYesNoDialog(context, title: "Do you want to delete it?".tr).then((value) {
  //                   if (value == true) {
  //                     setState(() {
  //                       InvenController.to.removeOrder(index);
  //                     });
  //                   }
  //                 });
  //               },
  //               child: SizedBox(width: 22, child: Utils.ImageSvg("icons/ic_trash.svg", color: Colors.grey, width: 20)),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 8),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text("${"quantity".tr} : ${order.orderCount}", style: TextStyle(fontSize: 15)),
  //             Text("${"unit".tr} ${type}", style: tsProductItemBold),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  _buildBottom() {
    return Column(
      children: [
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 20),
          // child: WidgetFactory.divider(color: Colors.black, weight: 3),
          child: WidgetFactory.divider(color: ColorsEx.clrDivider, weight: 1),
        ),
        _buildRequestInfo(),
        WidgetFactory.divider(color: ColorsEx.clrDivider, weight: 1),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          height: 45,
          child: ElevatedButton(
            onPressed: InvenController.to.getOrderCount() > 0
                ? () {
                    // Get.back(result: OrderModel(orderCount: 10, filePath: ""));
                    InvenController.to.checkOrder().then((value) {
                      if (value == null) {
                        Get.snackbar("error".tr, "error".tr);
                      } else {
                        if (value.result == "SUCCESS") {
                          // 바로 발주요청 API 호출
                          // InvenController.to.clearOrderList();
                          // Get.back();
                          InvenController.to.orderStock().then((value) {
                            if (value == true) {
                              Utils.showToast("done".tr);
                              InvenController.to.clearOrderList();
                              Get.back();
                            }
                          });
                        } else if (value.result == "EXIST") {
                          Utils.showYesNoDialog(context,
                                  title: // 설정
                                      value.msg,
                                  content: "Would you still like to request it?".tr)
                              .then((valueDlg) {
                            if (valueDlg == true) {
                              InvenController.to.orderStock().then((value) {
                                if (value == true) {
                                  Utils.showToast("done".tr);
                                  InvenController.to.clearOrderList();
                                  Get.back();
                                }
                              });
                            }
                          });
                        } else {
                          Get.snackbar("error".tr, "error".tr);
                        }
                      }
                    });
                  }
                : null,
            child: Center(
              child: Text("make a request".tr),
            ),
          ),
        ),
      ],
    );
  }

  // _buildTitle() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
  //     child: Container(
  //       // margin: EdgeInsets.symmetric(horizontal: 30),
  //       child: TextField(
  //         controller: _controllerTitle,
  //         decoration: InputDecoration(
  //           hintText: "제목을 입력해주세요".tr,
  //           border: OutlineInputBorder(),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // _buildReason() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 30),
  //     child: TextField(
  //       controller: _controllerReason,
  //       decoration: InputDecoration(
  //         hintText: "내용을 입력해주세요".tr,
  //         border: OutlineInputBorder(),
  //       ),
  //     ),
  //   );
  // }

  _buildRequestInfo() {
    int itemCount = InvenController.to.getOrderCount();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: ColorsEx.clrDivider, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("total count".tr, style: tsDefault),
              Text("${itemCount}", style: tsDefault),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("total quantity".tr, style: tsDefault),
              Text("${_totalCnt}", style: tsDefault),
            ],
          ),
        ],
      ),
    );
  }
}
