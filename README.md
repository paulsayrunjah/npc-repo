# Mobile National Product Catalog - Flutter App

## Overview

This repository hosts a cross-platform mobile app developed with Flutter, designed for browsing and displaying product information. The app includes features like barcode scanning and product data retrieval, ensuring users can easily access product details.

## Tech Stack

- **Language:** Dart
- **Framework:** Flutter
- **Data Service:** Akeneo REST APIs

## Libraries Used

The app utilizes the following Flutter packages:

- **`akeneo_api_client`:** Handles API requests to Akeneo.
- **`mobile_scanner`:** A universal barcode and QR code scanner based on MLKit.
- **`gs1_barcode_parser`:** Parses GS1 barcodes.
- **`cached_network_image`:** Caches and displays images from the web.
- **`url_launcher`:** Launches URLs in the mobile platform's default browser.
- **`image_picker`:** Picks images from the gallery or camera.
- **`intl`:** Provides internationalization and localization utilities.
- **`package_info_plus`:** Retrieves package information like app version and build number.
- **`flutter_spinkit`:** Displays loading animations.
- **`flutter_dotenv`:** Loads environment variables from a `.env` file.

## Development Tools

The app also integrates the following tools for development and maintenance:

- **`flutter_lints`:** Provides linting rules to maintain code quality.
- **`change_app_package_name`:** Changes the app's package name.
- **`flutter_launcher_icons`:** Generates app launcher icons.
- **`flutter_native_splash`:** Creates a native splash screen for the app.

## Getting Started

To set up and run the app, follow these steps:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ETdvlpr/npc-mobile-flutter.git
   ```
2. **Navigate to the project directory:**
   ```bash
   cd npc_mobile_flutter
   ```
3. **Install the dependencies:**
   ```bash
   flutter pub get
   ```
4. **Set up environment variables:**
   Create a `.env` file in the root directory using the `.env.example` file as a template. The `.env` file should include:
   ```bash
   AKENEO_API_BASE_URL=https://your-akeneo-instance.com
   AKENEO_API_CLIENT_ID=your-client-id
   AKENEO_API_CLIENT_SECRET=your-client-secret
   ```
5. **Run the app:**
   ```bash
   flutter run
   ```

## Customization Options

You can customize various aspects of the application to suit your needs. Here are some optional instructions:

### 1. **Change App Package Name**
   To change the app's package name (e.g., `com.etdvlpr.npc_mobile_flutter`):
   ```bash
   dart run change_app_package_name:main com.yourdomain.yourappname
   ```

### 2. **Customize App Icon**
   To customize the app icon, replace the image at `assets/images/app_icon.png` with your desired icon. Then, run:
   ```bash
   dart run flutter_launcher_icons:main
   ```

### 3. **Create a Custom Splash Screen**
   To customize the splash screen, replace the images in the `assets/images/` directory and update the `flutter_native_splash` section in `pubspec.yaml`. After making changes, run:
   ```bash
   dart run flutter_native_splash:create
   ```

## Contributing

Contributions are welcome! If you encounter issues or have suggestions for improvements:

- [Open an issue](https://github.com/ETdvlpr/npc-mobile-flutter/issues/new) to describe the bug or feature request.
- If you'd like to contribute code changes, fork the repository, make your changes, and submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.