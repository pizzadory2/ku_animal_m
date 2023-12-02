import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/network/rest_client.dart';

class PageSetting extends StatefulWidget {
  const PageSetting({super.key});

  @override
  State<PageSetting> createState() => _PageSettingState();
}

class _PageSettingState extends State<PageSetting> {
  final TextEditingController _controllerIP = TextEditingController();

  int _selectClass = -1;
  bool _isLoading = true;

  @override
  void initState() {
    _controllerIP.text = RestClient().dio.options.baseUrl;
    super.initState();

    _loadData();
  }

  @override
  void dispose() {
    _controllerIP.dispose();
    super.dispose();
  }

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
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("환경설정"),
      ),
      body: Container(
        color: Colors.black,
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 700,
                  color: Colors.grey,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _controllerIP,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "ip를 입력해주세요",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    RestClient().updateDio(_controllerIP.text);
                    Utils.showToast("적용되었습니다.");

                    setState(() {
                      _loadData();
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    color: Colors.pink,
                    child: const Text(
                      "적용",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            // Text(
            //   "${RestClient().dio.options.baseUrl}",
            //   style: TextStyle(color: Colors.red, fontSize: 30),
            // ),
            GestureDetector(
              onTap: () {
                // RestClient().updateDio(_controllerIP.text);
                Utils.showToast("저장되었습니다.");
                Get.back();

                // setState(() {
                //   _loadData();
                // });
              },
              child: Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                width: 300,
                height: 50,
                alignment: Alignment.center,
                color: Colors.pink,
                child: const Text(
                  "SAVE",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            _buildClassList(),
          ],
        ),
      ),
    );
  }

  _buildClassList() {
    return Container();
  }

  BoxDecoration _defaultDecoration(bool select) {
    return BoxDecoration(
      gradient: select ? _deviceItemSelect() : _deviceItemNormal(),
      color: const Color.fromRGBO(54, 60, 92, 1),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 3,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  void _loadData() {
    if (_controllerIP.text.isEmpty) {
      Utils.showToast("ip를 입력후 저장을 눌러주세요.");
      return;
    }

    // ClassController.to.readAll().then((value) {
    //   setState(() {
    //     _isLoading = false;

    //     if (value == true) {
    //     } else {
    //       Utils.showToast("호실 정보를 가져오는데 실패하였습니다.");
    //     }
    //   });
    // });
  }

  _deviceItemSelect() {
    return const LinearGradient(
      colors: [
        Color.fromRGBO(144, 125, 221, 1),
        Color.fromRGBO(220, 91, 153, 1),
      ],
      stops: [0.1, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  _deviceItemNormal() {
    return const LinearGradient(
      colors: [
        Color.fromRGBO(42, 49, 76, 1),
        Color.fromRGBO(55, 62, 92, 1),
      ],
      stops: [0.1, 1.0],
    );
  }
}
