// ignore_for_file: must_be_immutable

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/enums.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/dialog/search_dialog.dart';
import 'package:ku_animal_m/src/ui/home/home_controller.dart';
import 'package:ku_animal_m/src/ui/inventory/inven_controller.dart';
import 'package:ku_animal_m/src/ui/product_in/product_in_controller.dart';
import 'package:ku_animal_m/src/ui/product_in/product_in_reg_controller.dart';
import 'package:ku_animal_m/src/ui/product_out/product_out_controller.dart';
import 'package:ku_animal_m/src/ui/product_out/product_out_reg_controller.dart';
import 'package:ku_animal_m/src/ui/qr/qr_scanner_overlay3.dart';
import 'package:ku_animal_m/src/ui/search/page_search_result.dart';
import 'package:ku_animal_m/src/ui/search/search_home_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PageQR2 extends StatefulWidget {
  PageQR2({super.key, this.useDirect = true, required this.pageType});
  bool useDirect;
  PageType pageType;

  @override
  State<PageQR2> createState() => _PageQR2State();
}

class _PageQR2State extends State<PageQR2> {
  final _audioPlayer = AudioPlayer();

  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );
  bool _isScanning = false;
  bool _enableScan = false;
  // bool _isTorch = false;
  // bool _cameraFront = false;

  double _scanWidth = 300;

  final String _alarmName = "sounds/qr_effect_01.wav";

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((event) {
      // setState(() {
      //   //
      //   // isPlaying = event == PlayerState.playing;
      // });

      setAudio();
    });
  }

  Future setAudio() async {
    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    // final player = AudioCache(prefix: "assets/sounds/");
    // final url = await player.load("page_effect_02.mp3");
    // _audioPlayer.setSourceAsset(url.path);
  }

  @override
  Widget build(BuildContext context) {
    // double height = Get.height;
    // double height2 = MediaQuery.of(context).size.height;
    // double appbar = kToolbarHeight;
    // double appbar2 = AppBar().preferredSize.height;
    double appbar3 = MediaQuery.of(context).padding.top + kToolbarHeight;

    _scanWidth = Get.width * 0.8;
    double padding = Get.width * 0.1;
    // _scanWidth = 300; //Get.width * 0.8;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: padding),
        margin: EdgeInsets.only(top: appbar3, bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDescription(),
            _buildScanArea(),
            Row(
              children: [
                Expanded(child: Container()),
                _buildScanButton(),
                Expanded(child: _buildDirectInputButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildDescription() {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorsEx.primaryColorGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _enableScan ? "Scanning...".tr : "Ready".tr,
            style: tsQRTitle,
          ),
          const SizedBox(height: 15),
          Text(
            "Please input QR or Barcode in camera".tr,
            style: tsQRDescription,
          ),
        ],
      ),
    );
  }

  _buildScanArea() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          width: _scanWidth,
          height: _scanWidth,
          child: Stack(
            children: [
              AppController.to.isEmulator ? _buildGaraScanner() : _buildScanner(),
              QRScannerOverlay3(
                  overlayColour: Colors.black.withOpacity(0.4), scanWidth: _scanWidth, enableScan: _enableScan),
              // buildMask(),
            ],
          ),
        ),
      ),
    );
  }

  MobileScanner _buildScanner() {
    return MobileScanner(
      controller: _controller,
      onDetect: (capture) async {
        if (_enableScan == false) {
          return;
        }

        final List<Barcode> barcodes = capture.barcodes;
        // final Uint8List? image = capture.image;
        for (final barcode in barcodes) {
          debugPrint('Barcode found! ${barcode.rawValue}');
          if (!_isScanning) {
            // String alarmName = "sounds/sori.mp3";
            await _audioPlayer.play(AssetSource(_alarmName), volume: 1);

            _isScanning = true;
            _enableScan = false;
            // Navigator.pop(context, barcode.rawValue);
            // String data = barcode.rawValue ?? "---";
            String data = barcode.rawValue ?? "";
            debugPrint("[animal] data: $data");
            searchData(data);
            // Get.off(() => PageQR2Result(barcodeData: data));
            // var result = await Get.to(() => PageQRResult(barcodeData: data));
            // if (result == null) {
            //   setState(() {
            //     _isScanning = false;
            //     _enableScan = false;
            //   });
            // }

            // Get.off(() => PageQR2Result(barcodeData: data));
          }
        }
      },
    );
  }

  _buildScanButton() {
    return SizedBox(
        height: 70,
        child: GestureDetector(
          onTapDown: (details) {
            debugPrint("onTapDown");
            setState(() {
              _enableScan = true;
              if (AppController.to.isEmulator) {
                searchData("0108806536028011172402111021C0012110575573251751");
              }
            });
          },
          onTapUp: (details) => setState(() {
            debugPrint("onTapUp");
            setState(() {
              _enableScan = false;
            });
          }),
          // onTap: () {
          //   setState(() {
          //     _enableScan = !_enableScan;
          //   });
          // },
          child: Container(
            width: 150,
            decoration: BoxDecoration(
              color: _enableScan ? ColorsEx.primaryColor.withOpacity(0.5) : Colors.grey,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 45,
            ),
          ),
        ));
  }

  buildMask() {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white, width: 3),
                  left: BorderSide(color: Colors.white, width: 3),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white, width: 3),
                  right: BorderSide(color: Colors.white, width: 3),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white, width: 3),
                  left: BorderSide(color: Colors.white, width: 3),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white, width: 3),
                  right: BorderSide(color: Colors.white, width: 3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildDirectInputButton() {
    if (widget.useDirect == false) {
      return Container();
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // Get.to(() => PageQRResult(barcodeData: "1234567890"));
        // var result = _showDirectInputDialog(context);
        _showDirectInputDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.keyboard,
          color: ColorsEx.primaryColorGrey,
          size: 50,
        ),
      ),
    );
  }

  _showDirectInputDialog(BuildContext context) async {
    bool result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SearchDialog();
        });

    if (result) {}

    return result;
  }

  getController() {
    return switch (widget.pageType) {
      PageType.Home => HomeController.to,
      PageType.ProductIn => ProductInController.to,
      PageType.ProductOut => ProductOutController.to,
      PageType.ProductInven => InvenController.to,
      PageType.ProductRegIn => ProductInRegController.to,
      PageType.ProductRegOut => ProductOutRegController.to,
      PageType.Setting => HomeController.to
    };
  }

  void searchData(String searchText) {
    AppController.to.setLoading(true);

    switch (widget.pageType) {
      case (PageType.Home):
        {
          SearchHomeController.to.searchBarcode(searchData: searchText).then((value) {
            setState(() {
              AppController.to.setLoading(false);
              // Get.off(PageSearchResult(searchText: searchText), transition: Transition.rightToLeft);
              Get.off(PageSearchResult(searchText: searchText));
            });
          });
          break;
        }
      case (PageType.ProductIn):
      case (PageType.ProductOut):
      case (PageType.ProductInven):
      case (PageType.ProductRegIn):
      case (PageType.ProductRegOut):
        {
          AppController.to.setLoading(false);
          Get.back(result: searchText);
          break;
        }
      case (PageType.Setting):
        {
          break;
        }
    }
  }

  _buildGaraScanner() {
    return Center(
      child: SizedBox(
        width: _scanWidth - 100,
        height: _scanWidth - 100,
        child: Utils.ImageAsset("qr_code.png"),
      ),
    );
  }
}
