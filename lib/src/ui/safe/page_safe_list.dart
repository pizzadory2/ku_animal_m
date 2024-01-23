import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageSafeList extends StatefulWidget {
  const PageSafeList({super.key});

  @override
  State<PageSafeList> createState() => _PageSafeListState();
}

class _PageSafeListState extends State<PageSafeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("safe list".tr),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("title $index"),
                    subtitle: Text("subtitle $index"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
