import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';

class PageAddProduct extends StatefulWidget {
  const PageAddProduct({super.key});

  @override
  State<PageAddProduct> createState() => _PageAddProductState();
}

class _PageAddProductState extends State<PageAddProduct> {
  final TextEditingController _controllerName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("add product".tr, style: tsAppbarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // _buildMyInfo(),
                  _buildInputItem(
                    title: "product name",
                    hint: "hint product name".tr,
                    controller: _controllerName,
                    inputType: TextInputType.number,
                  ),
                  _buildSaveButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildInputItem(
      {required String title,
      required String hint,
      required TextEditingController controller,
      required TextInputType inputType}) {}

  _buildSaveButton() {}
}
