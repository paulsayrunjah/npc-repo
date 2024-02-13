import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

/// The AboutPage widget displays information about the National Product Catalog app.
///
/// It includes a splash image, app version, a brief description of the app's purpose,
/// and links to the privacy policy and terms of use.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? country = dotenv.env['COUNTRY'];
    return SingleChildScrollView(
      // Enable scrolling with a bouncing effect
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                const SizedBox(height: 64),
                // App version
                const Text(
                  'National Product Catalog 1.0',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // App description
                (country == null)
                    ? const Text(
                        'This app scans GS1 barcodes for health commodities and displays product information from the National Product Catalog.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      )
                    : RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text:
                                  'This app scans GS1 barcodes for health commodities and displays product information from the National Product Catalog of ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: country,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: '.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 12),
                // Privacy policy and terms of use buttons
                TextButton(
                  onPressed: () {
                    final privacyUrl = dotenv.env['PRIVACY_URL']!;
                    launchUrl(Uri.parse(privacyUrl));
                  },
                  child: const Text('Privacy Policy'),
                ),
                TextButton(
                  onPressed: () {
                    final termsUrl = dotenv.env['TERMS_URL']!;
                    launchUrl(Uri.parse(termsUrl));
                  },
                  child: const Text('Terms of Use'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
