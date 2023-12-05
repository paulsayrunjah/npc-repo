# Mobile National Product Catalog - Flutter App

## Overview

This repository hosts a cross-platform mobile app developed with Flutter, offering a seamless experience for displaying product information. The application features a Barcode-scanning capability, allowing users to effortlessly fetch product details from GS1 barcodes.

## Tech Stack

- **Language:** Dart
- **Framework:** Flutter
- **Data Service:** Akeneo REST APIs

## Libraries

The app integrates the following Flutter packages:

- **akeneo_api_client:** For handling API requests to akeneo.
- **mobile_scanner:** A universal barcode and QR code scanner for Flutter based on MLKit.
- **cached_network_image:** For caching images from the web.

## Getting Started

1. Clone the repository.
   ```bash
   git clone https://github.com/ETdvlpr/npc-mobile-flutter.git
   ```
2. Install the dependencies.
   ```bash
   cd npc-mobile-flutter
   flutter pub get
   ```
3. Run the app.
   ```bash
   flutter run
   ```
4. Enjoy!

## Contributing

Contributions are welcome! If you encounter issues or have improvements, please:

- [Open an issue](https://github.com/ETdvlpr/npc-mobile-flutter/issues/new) describing the bug or feature request.
- If you'd like to contribute code changes, Fork the repository, make changes, and submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
