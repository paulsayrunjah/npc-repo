import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:npc_mobile_flutter/src/data/gs1_properties.dart';

class GS1ParserService {
  static const int minLength = 12;
  static const int maxLength = 14;

  /// Retrieves the GTIN from the provided barcode.
  ///
  /// Throws an [ArgumentError] if the barcode is invalid.
  static GS1Properties? getGTIN(Barcode barcode) {
    if (isValidLength(barcode.rawBytes) &&
        isNumeric(String.fromCharCodes(barcode.rawBytes!))) {
      return GS1Properties(GTIN: String.fromCharCodes(barcode.rawBytes!));
    } else if (barcode.rawValue != null &&
        isValidLength(barcode.rawValue!.codeUnits) &&
        isNumeric(barcode.rawValue!)) {
      return GS1Properties(GTIN: barcode.rawValue!);
    } else if (barcode.format == BarcodeFormat.dataMatrix &&
        barcode.rawValue != null) {
      final parser = GS1BarcodeParser.defaultParser();
      final String code =
          barcode.rawValue!.replaceAll(RegExp(r'(\(|\)|\s)'), '');
      final result = parser.parse(code, codeType: CodeType.DATAMATRIX);

      return GS1Properties(
        GTIN: result.elements['01']?.data,
        batchOrLotNumber: result.elements['10']?.data,
        productionDate: result.elements['11']?.data,
        expirationDate: result.elements['17']?.data,
      );
    }

    throw ArgumentError('Invalid barcode');
  }

  /// Checks if the length of the bytes is within the valid range.
  static bool isValidLength(List<int>? bytes) {
    return bytes != null &&
        minLength <= bytes.length &&
        bytes.length <= maxLength;
  }

  /// Checks if the provided string is numeric.
  static bool isNumeric(String str) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(str);
  }
}
