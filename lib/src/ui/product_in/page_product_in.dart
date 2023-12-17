import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 입고 페이지
class PageProductIn extends StatefulWidget {
  const PageProductIn({super.key});

  @override
  State<PageProductIn> createState() => _PageProductInState();
}

class _PageProductInState extends State<PageProductIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("in".tr),
        ),
      ),
    );
  }
}
