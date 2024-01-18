import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/enums.dart';
import 'package:ku_animal_m/src/common/permission_manager.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/common/widget_factory.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/alarm/page_alarm.dart';
import 'package:ku_animal_m/src/ui/home/home_controller.dart';
import 'package:ku_animal_m/src/ui/home/page_home.dart';
import 'package:ku_animal_m/src/ui/inventory/page_inven.dart';
import 'package:ku_animal_m/src/ui/product/page_product_in_out.dart';
import 'package:ku_animal_m/src/ui/product_in/page_product_in.dart';
import 'package:ku_animal_m/src/ui/product_out/page_product_out.dart';
import 'package:ku_animal_m/src/ui/setting/page_setting.dart';

class PageApp extends StatefulWidget {
  const PageApp({super.key});

  @override
  State<PageApp> createState() => _PageAppState();
}

class _PageAppState extends State<PageApp> {
  DateTime backPressedTime = DateTime.now();

  int _selectIndex = 0;

  final List<Widget> _pages = [
    const PageHome(),
    const PageProductIn(),
    // const PageProductOut(),
    const PageProductInOut(),
    const PageInven(),
    // const PageSetting(),
  ];

  @override
  void initState() {
    refreshData();
    PermissionManager().requestCameraPermission(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: willPopAction,
          child: Scaffold(
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
                    refreshData();
                  });
                },
                items: [
                  // BottomNavigationBarItem(
                  //   icon: const Icon(Icons.home),
                  //   label: "home".tr,
                  // ),
                  _buildBottomItem(label: "home".tr, icon: FontAwesomeIcons.house, index: 0),
                  // _buildBottomItem(label: "inout".tr, icon: FontAwesomeIcons.arrowsUpDown, index: 1),
                  _buildBottomItem(label: "in".tr, icon: FontAwesomeIcons.download, index: 1),
                  _buildBottomItem(label: "out".tr, icon: FontAwesomeIcons.upload, index: 2),
                  // _buildBottomItem(label: "out".tr, icon: FontAwesomeIcons.inbox, index: 2),
                  _buildBottomItem(label: "inven".tr, icon: FontAwesomeIcons.boxesStacked, index: 3),
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
              )),
        ),
        Obx(() => WidgetFactory.loadingWidget(isLoading: AppController.to.isLoading.value, title: "로딩중입니다.")),
      ],
    );
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

  // true는 종료, false는 안종료
  Future<bool> willPopAction() async {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    bool backButton = currentTime.difference(backPressedTime) > const Duration(seconds: 3);

    if (backButton) {
      backPressedTime = currentTime;
      Utils.showToast("뒤로 버튼을 한 번 더 누르시면 종료됩니다.");
      return false;
    }

    return true;
  }

  void refreshData() async {
    AppController.to.setLoading(true);

    var result = false;

    switch (PageType.values[_selectIndex]) {
      case PageType.Home:
        result = await HomeController.to.refreshData();
        break;
      case PageType.ProductIn:
        // await AppController.to.getInData();
        break;
      case PageType.ProductOut:
        // await AppController.to.getOutData();
        break;
      case PageType.ProductInven:
        // await AppController.to.getInvenData();
        break;
      case PageType.Setting:
        // await AppController.to.getSettingData();
        break;
    }

    if (result == false) {
      Utils.showToast("데이터를 가져오는데 실패했습니다.");
    }

    AppController.to.setLoading(false);

    // Future.delayed(const Duration(seconds: 3), () {
    //   AppController.to.setLoading(false);
    // });
  }
}
