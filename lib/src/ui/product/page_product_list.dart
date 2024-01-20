import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageProductList extends StatefulWidget {
  const PageProductList({super.key});

  @override
  State<PageProductList> createState() => _PageProductListState();
}

class _PageProductListState extends State<PageProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("product list".tr),
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
