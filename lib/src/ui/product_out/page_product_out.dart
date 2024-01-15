import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageProductOut extends StatefulWidget {
  const PageProductOut({super.key});

  @override
  State<PageProductOut> createState() => _PageProductOutState();
}

class _PageProductOutState extends State<PageProductOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("out".tr),
      ),
    );
  }
}
