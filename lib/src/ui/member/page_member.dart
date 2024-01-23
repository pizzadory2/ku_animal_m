import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';

class PageMember extends StatefulWidget {
  const PageMember({super.key});

  @override
  State<PageMember> createState() => _PageMemberState();
}

class _PageMemberState extends State<PageMember> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("member".tr, style: tsAppbarTitle),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearch(),
            Divider(height: 1, color: Colors.grey[400]),
            _buildList(),
          ],
        ),
      ),
    );
  }

  _buildSearch() {
    return Container();
  }

  _buildList() {
    return Container();
  }
}
