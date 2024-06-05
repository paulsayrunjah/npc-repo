import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TorchButton extends StatelessWidget {
  final MobileScannerController controller;

  const TorchButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final IconData icon;
        switch (state.torchState) {
          case TorchState.auto:
            icon = Icons.flash_auto;
            break;
          case TorchState.off:
            icon = Icons.flash_off;
            break;
          case TorchState.on:
            icon = Icons.flash_on;
            break;
          case TorchState.unavailable:
          default:
            return const Icon(Icons.no_flash, color: Colors.grey);
        }

        return IconButton(
          color: Colors.white,
          iconSize: 32.0,
          icon: Icon(icon),
          onPressed: () async {
            await controller.toggleTorch();
          },
        );
      },
    );
  }
}
