import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:structure/utils/my_material.dart';

openPage(BuildContext context, String page, Map<String, dynamic> arguments) {
  if (page == pageHome) {
    Navigator.of(context).pushNamedAndRemoveUntil(pageHome, (route) => false, arguments: arguments);
  }
  else {
    Navigator.of(context).pushNamed(page, arguments: arguments);
  }
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

// get device current position
Future<Position?> getCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    debugPrint('=========> Location services are disabled.');
    return null;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      debugPrint('=========> Location permissions are denied.');
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    debugPrint('=========> Location permissions are denied forever.');
    return null;
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}