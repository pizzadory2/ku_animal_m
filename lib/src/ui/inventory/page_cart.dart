import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/inventory/inven_controller.dart';
import 'package:ku_animal_m/src/ui/inventory/order_model.dart';

class PageCart extends StatefulWidget {
  const PageCart({super.key});

  @override
  State<PageCart> createState() => _PageCartState();
}

class _PageCartState extends State<PageCart> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerReason = TextEditingController();

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerReason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // Navigator.pop(context);
              Get.back();
            },
            child: const Icon(Icons.arrow_back)),
        backgroundColor: ColorsEx.primaryColor,
        centerTitle: true,
        title: Text("request list".tr),
      ),
      body: _buildList(),
    );
  }

  _buildList() {
    int itemCount = InvenController.to.getOrderCount();
    return Container(
      child: Column(
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
          SizedBox(height: 20),
          _buildBottom(),
        ],
      ),
    );
  }

  _buildItem(int index) {
    OrderModel order = InvenController.to.getOrder(index);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(order.name, style: tsDefault500.copyWith(fontSize: 20))),
              GestureDetector(
                onTap: () {
                  Utils.showYesNoDialog(context, title: "Do you want to delete it?".tr).then((value) {
                    if (value == true) {
                      setState(() {
                        InvenController.to.removeOrder(index);
                      });
                    }
                  });
                },
                child: SizedBox(width: 22, child: Utils.ImageSvg("icons/ic_trash.svg", color: Colors.grey, width: 20)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text("${"quantity".tr} : ${order.orderCount}", style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  _buildBottom() {
    return Column(
      children: [
        WidgetFactory.divider(color: Colors.grey),
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

  _buildTitle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 30),
        child: TextField(
          controller: _controllerTitle,
          decoration: InputDecoration(
            hintText: "제목을 입력해주세요".tr,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  _buildReason() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _controllerReason,
        decoration: InputDecoration(
          hintText: "내용을 입력해주세요".tr,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
