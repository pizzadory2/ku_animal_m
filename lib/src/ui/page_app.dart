import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/enums.dart';
import 'package:ku_animal_m/src/common/permission_manager.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/alarm/page_alarm.dart';
import 'package:ku_animal_m/src/ui/home/page_home.dart';
import 'package:ku_animal_m/src/ui/inventory/page_inven.dart';
import 'package:ku_animal_m/src/ui/product_in/page_product_in.dart';
import 'package:ku_animal_m/src/ui/product_out/page_product_out.dart';
import 'package:ku_animal_m/src/ui/setting/page_setting.dart';

class PageApp extends StatefulWidget {
  const PageApp({super.key});

  @override
  State<PageApp> createState() => _PageAppState();
}

class _PageAppState extends State<PageApp> {
  int _selectIndex = 0;

  final List<Widget> _pages = [
    const PageHome(),
    const PageProductIn(),
    const PageProductOut(),
    // const PageProductInOut(),
    const PageInven(),
    // const PageSetting(),
  ];

  @override
  void initState() {
    super.initState();

    PermissionManager().requestCameraPermission(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(const PageSetting())?.then((value) {
                setState(() {
                  //
                });
              });
            },
          ),
          actions: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.solidBell),
              onPressed: () {
                Get.to(const PageAlarm())?.then((value) {
                  setState(() {
                    //
                  });
                });
              },
            ),
          ],
          title: Text(ePageTitle[_selectIndex].tr, style: tsAppbarTitle),
        ),
        body: IndexedStack(
          index: _selectIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          // elevation: 20,
          currentIndex: _selectIndex,
          enableFeedback: false,
          onTap: (value) {
            setState(() {
              _selectIndex = value;
            });
          },
          items: [
            // BottomNavigationBarItem(
            //   icon: const Icon(Icons.home),
            //   label: "home".tr,
            // ),
            _buildBottomItem(label: "home".tr, icon: FontAwesomeIcons.house, index: 0),
            _buildBottomItem(label: "inout".tr, icon: FontAwesomeIcons.arrowsUpDown, index: 1),
            // _buildBottomItem(label: "out".tr, icon: FontAwesomeIcons.upload, index: 2),
            // _buildBottomItem(label: "inven".tr, icon: FontAwesomeIcons.inbox, index: 2),
            _buildBottomItem(label: "inven".tr, icon: FontAwesomeIcons.boxesStacked, index: 2),
            // _buildBottomItem(label: "setting".tr, icon: FontAwesomeIcons.gear, index: 3),
            // _buildBottomItem(label: "home".tr, icon: "icons/home_3.svg", index: 0),
            // _buildBottomItem(label: "in".tr, icon: "icons/import.svg", index: 1),
            // _buildBottomItem(label: "out".tr, icon: "icons/export.svg", index: 2),
            // _buildBottomItem(label: "inven".tr, icon: "icons/inventory_2.svg", index: 3),
            // BottomNavigationBarItem(
            //   icon: const Icon(Icons.qr_code),
            //   label: "inven".tr,
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.qr_code),
            //   label: "QR",
            // ),
          ],
        ));
  }

  _buildBottomItem({required String label, required IconData icon, required int index}) {
    Color color = index == _selectIndex ? ColorsEx.primaryColor : Colors.grey;

    return BottomNavigationBarItem(
      label: "",
      icon: Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Utils.ImageSvg(icon, color: color, width: 20),
              FaIcon(icon, color: color),
              const SizedBox(height: 5),
              Text(label, style: TextStyle(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
