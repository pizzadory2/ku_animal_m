import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/style/colors_ex.dart';
import 'package:ku_animal_m/src/ui/qr/page_qr_result.dart';
import 'package:ku_animal_m/src/ui/qr/qr_scanner_overlay3.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PageQR2 extends StatefulWidget {
  const PageQR2({super.key});

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

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        //
        // isPlaying = event == PlayerState.playing;
      });

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
              MobileScanner(
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
                      String alarmName = "sounds/qr_effect_01.wav";
                      await _audioPlayer.play(AssetSource(alarmName), volume: 1);

                      _isScanning = true;
                      _enableScan = false;
                      // Navigator.pop(context, barcode.rawValue);
                      String data = barcode.rawValue ?? "---";
                      debugPrint("[animal] data: $data");
                      var result = await Get.to(() => PageQRResult(barcodeData: data));
                      if (result == null) {
                        setState(() {
                          _isScanning = false;
                          _enableScan = false;
                        });
                      }
                      // Get.off(() => PageQR2Result(barcodeData: data));
                    }
                  }
                },
              ),
              QRScannerOverlay3(
                  overlayColour: Colors.black.withOpacity(0.4), scanWidth: _scanWidth, enableScan: _enableScan),
              // buildMask(),
            ],
          ),
        ),
      ),
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // Get.to(() => PageQRResult(barcodeData: "1234567890"));
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
}
