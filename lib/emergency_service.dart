import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

import 'main.dart';
import 'notification_service.dart';

Future<void> triggerSOS(BuildContext context) async {
  final Stopwatch sosTimer = Stopwatch()..start();
  debugPrint('SOS timing: button pressed (0 ms)');

  void logTiming(String stage) {
    debugPrint('SOS timing: $stage (${sosTimer.elapsedMilliseconds} ms)');
  }

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
    logTiming('contacts loaded');

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

    // This notification does not depend on location, so let it complete while
    // the location checks and GPS acquisition are running.
    final Future<void> emergencyStartedNotification =
        notifications.showEmergencyStarted();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await emergencyStartedNotification;
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
      await emergencyStartedNotification;
      await notifications.showLocationSharingFailed(
        strings.locationPermissionDenied,
      );
      showMessage(strings.locationPermissionDenied);
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      await emergencyStartedNotification;
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
      await emergencyStartedNotification;
      await notifications.showLocationSharingFailed(e.toString());
      rethrow;
    }

    final double latitude = position.latitude;
    final double longitude = position.longitude;
    logTiming('GPS location acquired');

    final Telephony telephony = Telephony.instance;
    final Future<bool?> smsPermissionRequest = telephony.requestSmsPermissions;

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
    logTiming('address resolved');

    final String mapLink = "https://maps.google.com/?q=$latitude,$longitude";

    final String emergencyMessage = '''🚨 EMERGENCY ALERT / TAHADHARI YA DHARURA

ENGLISH
I need urgent medical assistance.
My current location is:
$placeText

Coordinates:
$latitude, $longitude

Map:
$mapLink

SWAHILI
Nahitaji msaada wa haraka wa matibabu.
Eneo nilipo ni:
$placeText

Kuratibu:
$latitude, $longitude

Ramani:
$mapLink

Sent via AfyaSOS''';

    await emergencyStartedNotification;
    final bool? smsPermissionGranted = await smsPermissionRequest;

    if (smsPermissionGranted != true) {
      showMessage(strings.smsPermissionDenied);
      return;
    }

    await Future.wait(
      allPhones.map(
        (phone) => telephony.sendSms(
          to: phone,
          message: emergencyMessage,
          isMultipart: true,
        ),
      ),
    );
    logTiming('SMS sent');

    await notifications.showLocationShared();

    if (mainContactPhone.isNotEmpty) {
      final call = FlutterPhoneDirectCaller.callNumber(mainContactPhone);
      logTiming('phone call initiated');
      await call;
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
  } finally {
    logTiming('total execution time');
    sosTimer.stop();
  }
}
