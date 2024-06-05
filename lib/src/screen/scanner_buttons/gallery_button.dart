import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class GalleryButton extends StatelessWidget {
  final MobileScannerController controller;
  final Future<void> Function(BuildContext context, BarcodeCapture barcode)
      onDetect;

  const GalleryButton({super.key, required this.controller, required this.onDetect});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      icon: const Icon(Icons.image),
      iconSize: 32.0,
      onPressed: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);

        if (image?.path != null) {
          final BarcodeCapture? barcodes =
              await controller.analyzeImage(image!.path);

          if (!context.mounted) return;

          if (barcodes == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No barcode found!'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            await onDetect(context, barcodes);
          }
        }
      },
    );
  }
}
