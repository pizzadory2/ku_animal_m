// ignore_for_file: must_be_immutable

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/dialog/input_count_ex_dialog.dart';
import 'package:ku_animal_m/src/ui/inventory/order_model.dart';
import 'package:ku_animal_m/src/ui/product/inven_model.dart';

// 발주요청
class PageInvenOrder extends StatefulWidget {
  PageInvenOrder({super.key, required this.data});

  InvenModel data;

  @override
  State<PageInvenOrder> createState() => _PageInvenOrderState();
}

class _PageInvenOrderState extends State<PageInvenOrder> {
  int _orderCount = 0;
  String _filePath = "";
  // String _fileName = "";

  // bool _validCount = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text("inven order".tr, style: tsAppbarTitle),
      ),
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: _buildBody()),
          _buildBottom(),
        ]),
      ),
    );
  }

  _buildBody() {
    // 출고타입 PK, BOX, EA
    String type = widget.data.mi_unit.isEmpty ? "" : "(${widget.data.mi_unit})";

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(widget.data.mi_name, style: tsInvenItemNameRequest),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("${"quantity".tr} : ${widget.data.mst_base_stock}", style: tsDefault),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("${"unit".tr} ${type}", style: tsProductItemBold)),
            ],
          ),
          // Container(
          //   height: 150,
          //   color: Colors.redAccent,
          // ),
          // Container(
          //   height: 150,
          //   color: Colors.greenAccent,
          // ),
          SizedBox(height: 20),
          // WidgetFactory.divider(color: Color.fromARGB(255, 228, 228, 228), weight: 3),
          WidgetFactory.divider(color: ColorsEx.clrDivider, weight: 3),
          _buildOrderCount(),
          _buildWarning(),
          // _fileName.isEmpty ? _buildAddFile() : _buildFileInfo(),
        ],
      ),
    );
  }

  _buildBottom() {
    return Column(
      children: [
        // WidgetFactory.divider(color: Colors.grey),
        WidgetFactory.divider(color: ColorsEx.clrDivider, weight: 1),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          height: 45,
          child: ElevatedButton(
            onPressed: _orderCount > 0
                ? () {
                    Get.back(result: OrderModel(orderCount: _orderCount, filePath: _filePath));
                  }
                : null,
            child: Center(
              child: Text("put".tr),
            ),
          ),
        ),
      ],
    );
  }

  _buildOrderCount() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Requested Quantity".tr, style: tsDefault),
          _buildPlusMinusButton(),
        ],
      ),
    );
  }

  _buildPlusMinusButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (_orderCount > 0) {
                _orderCount--;
              }
            });
          },
          child: Center(
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: ColorsEx.primaryColorGrey,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Icon(Icons.remove, color: Colors.white),
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            //
            int result = await _showInputCountDialog(context, _orderCount);
            if (result != -1) {
              setState(() {
                _orderCount = result;
              });
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 30,
            alignment: Alignment.center,
            child: Text("$_orderCount", style: tsDefault),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if (_orderCount < 999) {
                _orderCount++;
              }
            });
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: ColorsEx.primaryColorBold,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        // type: FileType.image, // select only images
        );

    if (result != null) {
      setState(() {
        // isImageLoading = true;

        String filePath = result.files.single.path!;
        // Utils.showToast("File Path: $filePath");
        if (filePath.isNotEmpty) {
          _filePath = filePath;
          // _fileName = result.files.single.name;
        }
        // imgFile = File(result.files.single.path!); // Make the selected image file
        // print('File Path: ${imgFile!.path}');
      });
    } else {
      // If the user cancels the selection
      debugPrint("No image selected");
    }

    // setState(() {
    //   // isImageLoading = false;
    // });
  }

  // _buildAddFile() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
  //     child: GestureDetector(
  //       behavior: HitTestBehavior.translucent,
  //       onTap: () {
  //         pickFile();
  //       },
  //       child: SizedBox(
  //         width: double.infinity,
  //         height: 100,
  //         child: DottedBorder(
  //           child: Center(
  //               child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text("supporting data".tr, style: tsDefault.copyWith(fontSize: 20)),
  //               SizedBox(height: 10),
  //               Icon(Icons.add, size: 40),
  //             ],
  //           )),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // _buildFileInfo() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
  //     child: SizedBox(
  //       width: double.infinity,
  //       height: 100,
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 SizedBox(width: 40),
  //                 Text("${_fileName}", style: tsDefault.copyWith(fontSize: 20)),
  //                 GestureDetector(
  //                     behavior: HitTestBehavior.translucent,
  //                     onTap: () {
  //                       _filePath = "";
  //                       _fileName = "";
  //                       setState(() {});
  //                     },
  //                     child: Icon(Icons.delete_forever_sharp, color: Colors.grey, size: 40)),
  //               ],
  //             ),
  //             // SizedBox(height: 10),
  //             // Icon(Icons.add, size: 40),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  _buildWarning() {
    return Container();
    // if (_validCount) {
    //   return Container();
    // }

    // return Container(
    //   alignment: Alignment.center,
    //   child: Text("warning".tr, style: tsWarning.copyWith(color: Colors.red)),
    // );
  }

  _showInputCountDialog(BuildContext context, int initCount) async {
    int result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return InputCountExDialog(count: initCount);
        });

    // Utils.keyboardHide();

    return result;
  }
}
