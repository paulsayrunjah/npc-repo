import 'dart:developer';

import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:npc_mobile_flutter/src/data/gs1_properties.dart';

class GS1ParserService {
  static const int minLength = 13;
  static const int maxLength = 14;

  static GS1Properties? getGTIN(Barcode barcode) {
    if (isValidLength(barcode.rawBytes)) {
      return GS1Properties(GTIN: String.fromCharCodes(barcode.rawBytes!));
    } else if (barcode.rawValue != null &&
        (barcode.rawValue!.length == minLength ||
            barcode.rawValue!.length == maxLength)) {
      return GS1Properties(GTIN: barcode.rawValue!);
    } else if (barcode.format == BarcodeFormat.dataMatrix &&
        barcode.rawValue != null) {
      final parser = GS1BarcodeParser.defaultParser();
      final String code =
          barcode.rawValue!.replaceAll(RegExp(r'(\(|\)|\s)'), '');
      log('code: $code');
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

  static bool isValidLength(List<int>? bytes) {
    return bytes != null &&
        (bytes.length == minLength || bytes.length == maxLength);
  }
}
