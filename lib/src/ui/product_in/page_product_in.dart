import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';

// 입고 페이지
class PageProductIn extends StatefulWidget {
  const PageProductIn({super.key});

  @override
  State<PageProductIn> createState() => _PageProductInState();
}

class _PageProductInState extends State<PageProductIn> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("in".tr),
      ),
    );
  }

  void initData() async {
    AppController.to.setLoading(true);

    Future.delayed(const Duration(seconds: 3), () {
      AppController.to.setLoading(false);
    });
  }
}
