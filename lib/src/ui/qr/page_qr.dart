import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/text_style_ex.dart';
import 'package:ku_animal_m/src/ui/qr/page_qr_result.dart';
import 'package:ku_animal_m/src/ui/qr/qr_scanner_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PageQR extends StatefulWidget {
  const PageQR({super.key});

  @override
  State<PageQR> createState() => _PageQRState();
}

class _PageQRState extends State<PageQR> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );
  bool _isScanning = false;
  // bool _isTorch = false;
  // bool _cameraFront = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = Get.height;
    double height2 = MediaQuery.of(context).size.height;
    double appbar = kToolbarHeight;
    double appbar2 = AppBar().preferredSize.height;
    double appbar3 = MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scan".tr),
        actions: [
          IconButton(
            // onPressed: () {
            //   setState(() {
            //     _isTorch = !_isTorch;
            //   });
            // },
            onPressed: () => _controller.toggleTorch(),
            icon: ValueListenableBuilder(
              valueListenable: _controller.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off_rounded, color: Colors.white);
                  case TorchState.on:
                    return const Icon(Icons.flash_on_rounded, color: Colors.white);
                  // return const Icon(Icons.flash_on_rounded, color: Colors.yellow);
                }
              },
            ),
          ),
          IconButton(
            // onPressed: () {
            //   setState(() {
            //     _cameraFront = !_cameraFront;
            //   });
            // },
            // // icon: const Icon(Icons.flip_camera_android),
            // // icon: const Icon(Icons.file_upload_rounded),
            // icon: const Icon(Icons.flip_camera_ios_outlined),
            onPressed: () => _controller.switchCamera(),
            icon: ValueListenableBuilder(
              valueListenable: _controller.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.flip_camera_ios_outlined);
                  // return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.flip_camera_ios_outlined);
                  // return const Icon(Icons.camera_rear);
                }
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            // fit: BoxFit.contain,
            // controller: MobileScannerController(
            //   detectionSpeed: DetectionSpeed.normal,
            //   facing: _cameraFront ? CameraFacing.front : CameraFacing.back,
            //   torchEnabled: _isTorch,
            // ),
            controller: _controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              // final Uint8List? image = capture.image;
              for (final barcode in barcodes) {
                debugPrint('Barcode found! ${barcode.rawValue}');
                if (!_isScanning) {
                  _isScanning = true;
                  // Navigator.pop(context, barcode.rawValue);
                  String data = barcode.rawValue ?? "---";
                  Get.to(() => PageQRResult(barcodeData: data));
                }
              }
            },
          ),
          QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.4)),
          Align(
            alignment: Alignment.bottomCenter,
            // top: height - appbar3 - 70,
            // left: 50,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                "Please input QR or Barcode in camera".tr,
                style: tsQRDescription,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
