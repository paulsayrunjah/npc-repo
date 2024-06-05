import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraSwitchButton extends StatelessWidget {
  final MobileScannerController controller;

  const CameraSwitchButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized ||
            !state.isRunning ||
            (state.availableCameras != null && state.availableCameras! < 2)) {
          return const SizedBox.shrink();
        }

        final IconData icon = state.cameraDirection == CameraFacing.front
            ? Icons.camera_front
            : Icons.camera_rear;

        return IconButton(
          color: Colors.white,
          iconSize: 32.0,
          icon: Icon(icon),
          onPressed: () => controller.switchCamera(),
        );
      },
    );
  }
}
