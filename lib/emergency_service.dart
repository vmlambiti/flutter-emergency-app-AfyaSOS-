import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

import 'main.dart';
import 'notification_service.dart';

Future<void> triggerSOS(BuildContext context) async {
  final strings = MyApp.of(context)!.strings;
  final notifications = NotificationService.instance;

  void showMessage(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  try {
    final box = await Hive.openBox('userBox');
    final savedContacts = box.get('emergency_contacts');

    if (savedContacts == null ||
        savedContacts is! List ||
        savedContacts.isEmpty) {
      showMessage(strings.noEmergencyContactsFound);
      return;
    }

    final List<Map<String, String>> contacts = savedContacts
        .map<Map<String, String>>((item) {
          final map = Map<String, dynamic>.from(item);
          return {
            "name": map["name"]?.toString() ?? "",
            "relationship": map["relationship"]?.toString() ?? "",
            "phone": map["phone"]?.toString() ?? "",
            "altPhone": map["altPhone"]?.toString() ?? "",
            "email": map["email"]?.toString() ?? "",
            "address": map["address"]?.toString() ?? "",
          };
        })
        .toList();

    final Map<String, String> mainContact = contacts.first;
    final String mainContactName = mainContact["name"] ?? "";
    final String mainContactPhone = (mainContact["phone"] ?? "").trim();

    final List<String> allPhones = contacts
        .map((contact) => (contact["phone"] ?? "").trim())
        .where((phone) => phone.isNotEmpty)
        .toList();

    if (allPhones.isEmpty) {
      showMessage(strings.noValidPhoneNumbers);
      return;
    }

    await notifications.showEmergencyStarted();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await notifications.showLocationSharingFailed(
        strings.turnOnLocationServices,
      );
      showMessage(strings.turnOnLocationServices);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      await notifications.showLocationSharingFailed(
        strings.locationPermissionDenied,
      );
      showMessage(strings.locationPermissionDenied);
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      await notifications.showLocationSharingFailed(
        strings.locationPermissionDeniedForever,
      );
      showMessage(strings.locationPermissionDeniedForever);
      return;
    }

    late final Position position;

    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      await notifications.showLocationSharingFailed(e.toString());
      rethrow;
    }

    final double latitude = position.latitude;
    final double longitude = position.longitude;

    String placeText = strings.addressNotAvailable;

    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;

        final List<String> addressParts = [
          place.street ?? "",
          place.subLocality ?? "",
          place.locality ?? "",
          place.administrativeArea ?? "",
          place.country ?? "",
        ].where((part) => part.trim().isNotEmpty).toList();

        if (addressParts.isNotEmpty) {
          placeText = addressParts.join(', ');
        }
      }
    } catch (_) {
      placeText = strings.addressNotAvailable;
    }

    final String mapLink = "https://maps.google.com/?q=$latitude,$longitude";

    final String emergencyMessage =
        '''
${strings.emergencyMessageLine1}
${strings.myLocationLabel}: $placeText
${strings.coordinatesLabel}: $latitude, $longitude
Map: $mapLink
''';

    final Telephony telephony = Telephony.instance;
    final bool? smsPermissionGranted = await telephony.requestSmsPermissions;

    if (smsPermissionGranted != true) {
      showMessage(strings.smsPermissionDenied);
      return;
    }

    for (final phone in allPhones) {
      await telephony.sendSms(
        to: phone,
        message: emergencyMessage,
        isMultipart: true,
      );
    }

    await notifications.showLocationShared();

    if (mainContactPhone.isNotEmpty) {
      await FlutterPhoneDirectCaller.callNumber(mainContactPhone);
    }

    debugPrint("Main Contact Name: $mainContactName");
    debugPrint("Main Contact Phone: $mainContactPhone");
    debugPrint("All Emergency Phones: $allPhones");
    debugPrint("Latitude: $latitude");
    debugPrint("Longitude: $longitude");
    debugPrint("Place: $placeText");
    debugPrint("Emergency Message: $emergencyMessage");

    showMessage("${strings.emergencySmsSentCalling} $mainContactName...");
    await notifications.showEmergencyCompleted();
  } catch (e) {
    showMessage('${strings.sosError}: $e');
  }
}
