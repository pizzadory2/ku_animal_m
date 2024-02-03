import 'package:flutter/material.dart';
import 'package:ku_animal_m/src/common/dimens.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';

class WidgetFactory {
  static Widget divider({double weight = 1, Color color = Colors.white, double topMargin = 0}) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      width: double.infinity,
      height: weight,
      color: color,
    );
  }

  static Widget dividerVer({double width = 1, double height = double.infinity, Color? color, double margin = 0}) {
    return Container(
      color: color ?? const Color(0xFF606066),
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: margin),
    );
  }

  static circleIcon({required int color}) {
    return Container(
      width: 12.0,
      height: 12.0,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: Color(color),
        shape: BoxShape.circle,
      ),
    );
  }

  static circleIcon2({required Color color}) {
    return Container(
      width: 12.0,
      height: 12.0,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  static circleIconRepeat({required int color, bool repeat = false}) {
    return Container(
      width: 15.0,
      height: 15.0,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: Color(color),
        shape: BoxShape.circle,
      ),
      child: repeat
          ? const Icon(
              Icons.cached,
              size: 12,
              color: Colors.white,
            )
          : null,
    );
  }

  static circleIcon2Repeat({required Color color, bool repeat = false}) {
    return Container(
      width: 12.0,
      height: 12.0,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: repeat
          ? const Icon(
              Icons.cached,
              size: 11,
              color: Colors.white,
            )
          : null,
    );
  }

  static Widget gripBar({double width = 32, Color color = Colors.white60, double bottomMargin = 12}) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: bottomMargin),
      child: Container(
          width: width,
          height: 3,
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ))),
    );
  }

  static Widget emptyWidget({String title = ""}) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontSize: 30, fontFamily: "KCCEunyoung"),
      ),
    );
  }

  static Widget emptyWidgetWithFunc({required Function() onTap, String title = ""}) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Utils.ImageAsset("empty_box.png", width: 100, height: 100),
        SizedBox(height: 20),
        GestureDetector(
          onTap: onTap,
          child: Icon(
            Icons.refresh,
            color: Colors.grey,
            size: 50,
          ),
        ),
        // Text("empty".tr),
      ],
    ));
  }

  static Widget dividerDash({double width = 0.5, Color color = Colors.black}) {
    return Row(
      children: [
        for (int i = 0; i < 50; i++)
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: color,
                    thickness: width,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static Widget selectPen({required Function() onTap, Color bgColor = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: bgColor,
        child: Container(
          width: 40,
          height: 7,
          decoration: const BoxDecoration(
            color: Colors.black,
            // border: Border.all(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }

  static BoxDecoration boxDecoration({double radius = 15}) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 7,
          offset: const Offset(4, 0),
        )
      ],
      color: Colors.white,
      // border: Border.all(
      //   width: 1,
      // ),
      borderRadius: BorderRadius.circular(radius),
    );
    // return BoxDecoration(
    //   color: Colors.white,
    //   borderRadius: BorderRadius.circular(10),
    //   boxShadow: [
    //     BoxShadow(
    //       color: Colors.grey.withOpacity(0.5),
    //       spreadRadius: 1,
    //       blurRadius: 3,
    //       offset: Offset(0, 1), // changes position of shadow
    //     ),
    //   ],
    // );
  }

  static loadingWidget({String? title, bool isLoading = true, bool isBackground = true}) {
    if (!isLoading) {
      return Container();
    }

    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: isBackground ? Colors.black.withOpacity(0.5) : null,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: isBackground ? Colors.white : Colors.black,
              ),
              if (title != null) const SizedBox(height: 20),
              if (title != null) Text(title, style: TextStyle(color: isBackground ? Colors.white : Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  static Widget inputText(
      {required TextEditingController controller,
      String value = "",
      bool autoFocus = false,
      TextInputType inputType = TextInputType.text,
      Function(String)? onSubmit,
      bool readOnly = false}) {
    controller.text = value;

    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));

    return SizedBox(
      height: 45,
      child: TextField(
          controller: controller,
          keyboardType: inputType,
          autofocus: autoFocus,
          onSubmitted: onSubmit,
          maxLines: 1,
          readOnly: readOnly,
          cursorColor: Colors.black,
          obscureText: false,
          decoration: InputDecoration(
            // hintText: "${title}을 입력해 주세요",
            hintStyle: tsDialogHint,
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            // enabledBorder: UnderlineInputBorder(
            //   borderSide: BorderSide(width: 1, color: Colors.grey),
            // ),
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            border: InputBorder.none,
          )),
    );
  }

  static searchClearButton() {
    Color colorBack = Colors.black54;
    Color colorFront = Colors.white;

    // Color colorBack = Colors.white;
    // Color colorFront = Colors.black54;

    return Container(
        decoration: BoxDecoration(
          color: colorBack,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.clear,
          size: 24,
          color: colorFront,
        ));
  }

  static regItem({
    required ProductModel data,
    required int index,
    required String countText,
    required Function() onPress,
    required Function() onRemove,
    required Function() onChangeQty,
  }) {
    String dspCount = Utils.numberFormatMoney(data.inout_count);
    String amount = data.mi_content.isEmpty ? "-" : "(${data.mi_content})";
    // String regDate = data.reg_date;
    // if (regDate.isNotEmpty) {
    //   var date = DateTime.parse(regDate);
    //   regDate = "등록일 ${date.year}.${date.month}.${date.day}";
    // }

    return GestureDetector(
      onTap: () {
        debugPrint("[animal] ::추가된 아이템 클릭(${index})");
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey[300]!)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text(data.mi_name, style: tsProductItemTitle)),
                SizedBox(width: 10),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onRemove,
                  child: Icon(Icons.close, size: 20, color: Colors.grey),
                ),
                SizedBox(width: 5),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 3, right: 45),
              child:
                  Text("${data.mi_manufacturer} / ${data.mi_type_name} / ${data.mi_class_name}", style: tsProductItem),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(data.mi_manufacturer, style: tsProductItem),
                        const Spacer(),
                        // Text("(${data.mi_type_name}/${data.mi_class_name})", style: tsProductItem),
                        Text("주요성분 (${data.mi_ingredients})", style: tsProductItem),
                        const SizedBox(height: 5),
                        Text("함량 ${amount}", style: tsProductItem),
                      ],
                    ),
                  ),
                  Container(
                    width: Dimens.qtyButtonWidth,
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: onChangeQty,
                      child: Container(
                        height: 25,
                        decoration: BoxDecoration(
                          color: data.inout_count == 0 ? Colors.red[500] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.only(left: 10, right: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${countText} ${dspCount}",
                              style: data.inout_count == 0
                                  ? tsProductItemBold.copyWith(color: Colors.white)
                                  : tsProductItemBold,
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.edit, color: data.inout_count == 0 ? Colors.white : Colors.black54, size: 16),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget get spacerWidth => const SizedBox(width: 5);
  static Widget get spacerHeight => const SizedBox(height: 5);
}
