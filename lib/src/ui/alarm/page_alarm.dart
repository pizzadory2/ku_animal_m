import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';

class PageAlarm extends StatefulWidget {
  const PageAlarm({super.key});

  @override
  State<PageAlarm> createState() => _PageAlarmState();
}

class _PageAlarmState extends State<PageAlarm> {
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
        title: Text("alarm".tr),
      ),
      body: Container(
        child: Center(
          child: Text("alarm".tr),
        ),
      ),
    );
  }
}
