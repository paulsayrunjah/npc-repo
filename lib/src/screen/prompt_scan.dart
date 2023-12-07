import 'package:flutter/material.dart';
import 'package:npc_mobile_flutter/src/widget/custom_loader.dart';

class PromptScan extends StatelessWidget {
  final VoidCallback onScanButtonPressed;
  final bool isLoading;
  const PromptScan({
    required this.onScanButtonPressed,
    required this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          // Enable scrolling with a bouncing effect
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // Ensure that the content is scrollable, taking into account the app bar and bottom navigation bar
              minHeight: MediaQuery.of(context).size.height - 56 - 56 - 24,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App splash image
                    Image.asset(
                      'assets/images/splash.png',
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    const SizedBox(height: 16),
                    // Welcome message
                    const Text(
                      'GS1 GTIN Verification App',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Start Scan button
                    ElevatedButton(
                      onPressed: onScanButtonPressed,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 4.0,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 40),
                      ),
                      child: const Text(
                        'Start Scan',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 20), // Instructions for barcode scanning
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Press the ',
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(color: Colors.black87),
                        children: const [
                          TextSpan(
                            text: 'Start Scan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                              text: ' button to begin scanning GS1 barcodes. '),
                          TextSpan(
                              text: 'You will need an internet connection.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading) const CustomLoader()
      ],
    );
  }
}
