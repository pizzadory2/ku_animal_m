// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class PageQRResult extends StatefulWidget {
  PageQRResult({this.barcodeData = "", super.key});

  String barcodeData = "";

  @override
  State<PageQRResult> createState() => _PageQRResultState();
}

class _PageQRResultState extends State<PageQRResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Code")),
      body: Center(
        child: Text(widget.barcodeData),
      ),
    );
  }
}
