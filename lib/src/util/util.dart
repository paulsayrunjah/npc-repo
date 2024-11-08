import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

logApp(data, {String? tag = 'NPC-App-Log'}) {
  if (kDebugMode) {
    print("$tag ---> $data");
  }
}

String convertDate(String dateStr) {
  DateTime date = DateFormat("dd/MM/yyyy").parse(dateStr);
  return DateFormat("yyyy-MM-dd").format(date);
}
