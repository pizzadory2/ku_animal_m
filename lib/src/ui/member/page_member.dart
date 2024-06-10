import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/dimens.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/ui/member/member_controller.dart';
import 'package:ku_animal_m/src/ui/member/member_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PageMember extends StatefulWidget {
  const PageMember({super.key});

  @override
  State<PageMember> createState() => _PageMemberState();
}

class _PageMemberState extends State<PageMember> {
  bool _isLoading = true;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final TextEditingController _controllerSearch = TextEditingController();
  // int _filterIndex = 0;

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _controllerSearch.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              onPressed: (() => Get.back()),
              icon: const Icon(Icons.close),
            ),
            title: Text("member".tr, style: tsAppbarTitle),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // _buildSearch(),
                // const SizedBox(height: Dimens.searchHeight),
                // Divider(height: 1, color: Colors.grey[400]),
                _buildList(),
                // SizedBox(height: 10),
              ],
            ),
          ),
        ),
        WidgetFactory.loadingWidget(isLoading: _isLoading, title: "Loading...".tr, isBackground: false),
      ],
    );
  }

  // _buildSearch() {
  //   return Container(
  //       height: Dimens.searchHeight,
  //       padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Container(
  //               padding: const EdgeInsets.only(right: 10),
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[100],
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: Row(
  //                 children: [
  //                   IconButton(
  //                     onPressed: () {},
  //                     icon: const Icon(Icons.search),
  //                   ),
  //                   Expanded(
  //                     child: TextField(
  //                       controller: _controllerSearch,
  //                       onChanged: (value) {
  //                         setState(() {});
  //                       },
  //                       onSubmitted: (value) {
  //                         searchData();
  //                       },
  //                       cursorColor: Colors.black,
  //                       decoration: InputDecoration(
  //                         border: InputBorder.none,
  //                         focusedBorder: InputBorder.none,
  //                         hintText: "search hint".tr,
  //                         hintStyle: tsSearchHint,
  //                       ),
  //                     ),
  //                   ),
  //                   _controllerSearch.text.isNotEmpty
  //                       ? GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               _controllerSearch.clear();
  //                             });
  //                           },
  //                           child: WidgetFactory.searchClearButton(),
  //                         )
  //                       : Container(),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           const SizedBox(width: 10),
  //           SizedBox(
  //             width: AppController.to.language == "ko" ? 80 : 90,
  //             child: ElevatedButton(
  //               onPressed: () {
  //                 searchData();
  //               },
  //               child: Text(
  //                 "search".tr,
  //                 style: tsSearch,
  //               ),
  //             ),
  //           ),
  //           WidgetFactory.dividerVer(height: 30, color: Colors.black12, margin: 10),
  //           SizedBox(
  //             // width: 50,
  //             child: GestureDetector(
  //               behavior: HitTestBehavior.translucent,
  //               onTap: () {
  //                 debugPrint("QR");
  //               },
  //               child: const Icon(Icons.qr_code_rounded, size: 30, color: Colors.black54),
  //             ),
  //           ),
  //         ],
  //       ));
  // }

  _buildList() {
    int itemCount = MemberController.to.getCount();

    return Expanded(
      child: itemCount == 0
          ? WidgetFactory.emptyWidget()
          : ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return _buildMemberItem(index);
              },
            ),
    );
  }

  _buildMemberItem(int index) {
    MemberModel item = MemberController.to.getItem(index);

    String name = item.tu_name;
    // String phone = item.tu_phone;
    String team = item.si_name;
    String email = item.tu_email;

    return Container(
        height: Dimens.memberItemHeight,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          // color: Colors.grey[100],
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey[300]!)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: tsMemberName),
                    Text(team, style: tsMemberPhone),
                    Spacer(),
                    Text(email, style: tsMemberEmail),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(team, style: tsMemberTeam),
            ),
          ],
        ));
  }

  void searchData() {}

  refreshData() async {
    setState(() {
      _isLoading = true;
    });
    //
    // Future.delayed(Duration(seconds: 3)).then((value) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });

    await MemberController.to.refreshData().then(
          (value) => setState(
            () {
              _isLoading = false;
            },
          ),
        );
  }
}
