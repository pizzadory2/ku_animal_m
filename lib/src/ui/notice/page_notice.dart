import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageNotice extends StatefulWidget {
  const PageNotice({super.key});

  @override
  State<PageNotice> createState() => _PageNoticeState();
}

class _PageNoticeState extends State<PageNotice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("notice".tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Text("notice".tr),
          ),
        ),
      ),
    );
  }
}
