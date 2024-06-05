import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:npc_mobile_flutter/src/data/gs1_properties.dart';
import 'package:npc_mobile_flutter/src/screen/scanner_buttons/camera_switch_button.dart';
import 'package:npc_mobile_flutter/src/screen/scanner_buttons/gallery_button.dart';
import 'package:npc_mobile_flutter/src/screen/scanner_buttons/torch_button.dart';
import 'package:npc_mobile_flutter/src/util/gs1_parser_service.dart';
import 'package:npc_mobile_flutter/src/widget/scanner_error_widget.dart';

/// A page for scanning barcodes using the mobile device's camera.
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  ScannerPageState createState() => ScannerPageState();
}

class ScannerPageState extends State<ScannerPage> {
  final MobileScannerController controller = MobileScannerController();
  Barcode? barcode;
  BarcodeCapture? capture;
  DateTime? showingError;

  /// Callback function triggered when a barcode is detected.
  Future<void> onDetect(BuildContext context, BarcodeCapture barcode) async {
    capture = barcode;
    if (barcode.barcodes.isEmpty) return;
    final detectedBarcode = barcode.barcodes.first;
    setState(() => this.barcode = detectedBarcode);
    for (final barcode in barcode.barcodes) {
      try {
        final GS1Properties? properties = GS1ParserService.getGTIN(barcode);
        controller.stop();
        Navigator.pop(context, properties);
      } catch (e) {
        debugPrint(e.toString());
        if (showingError == null ||
            DateTime.now().difference(showingError!) >
                const Duration(seconds: 2)) {
          showingError = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid barcode!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: MediaQuery.of(context).size.width,
      height: 300,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: MobileScanner(
              fit: BoxFit.contain,
              scanWindow: scanWindow,
              controller: controller,
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
              onDetect: (barcode) => onDetect(context, barcode),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if (!value.isInitialized ||
                  !value.isRunning ||
                  value.error != null) {
                return const SizedBox();
              }

              return CustomPaint(
                painter: ScannerOverlay(scanWindow: scanWindow),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 25),
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TorchButton(controller: controller),
                  CameraSwitchButton(controller: controller),
                  GalleryButton(controller: controller, onDetect: onDetect),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

/// Custom painter for drawing the scanner overlay on the camera preview.
class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);

    // Create the path for the cutout with rounded corners
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    // Define the paint for the background with cutout
    final backgroundPaint = Paint()
      ..color = Colors.green.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    // Combine the paths to create a cutout effect
    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    // Define the paint for the border
    final borderPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Draw the background with the cutout on the canvas
    canvas.drawPath(backgroundWithCutout, backgroundPaint);

    // Draw the border around the scan window
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        scanWindow,
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
        bottomLeft: Radius.circular(borderRadius),
        bottomRight: Radius.circular(borderRadius),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}
