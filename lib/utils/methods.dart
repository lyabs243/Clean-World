import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:structure/utils/my_material.dart';

openPage(BuildContext context, String page, Map<String, dynamic> arguments) {

}

bool get emulatorOn {
  return kDebugMode && (kIsWeb || Platform.isAndroid);
}

DateTime? dateParsing(String dateString) {
  DateTime? parsedDate;
  try {
    parsedDate = DateTime.parse(dateString);
  }
  catch (err) {
    debugPrint('Error parsing date: $err');
  }

  return parsedDate;
}