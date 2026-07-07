import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const MethodChannel _channel = MethodChannel(
    'afya_sos/notifications',
  );

  Future<void> initialize() async {
    try {
      await _channel.invokeMethod<void>('initialize');
      await requestPermission();
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }

  Future<bool> requestPermission() async {
    try {
      final granted = await _channel.invokeMethod<bool>('requestPermission');
      return granted ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> get isEmergencyAlertsEnabled async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('emergencyAlerts') ?? true;
  }

  Future<bool> get isSosConfirmationEnabled async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('sosConfirmation') ?? true;
  }

  Future<bool> get isLocationSharingAlertsEnabled async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('locationSharingAlerts') ?? true;
  }

  Future<void> showEmergencyStarted() async {
    if (!await isEmergencyAlertsEnabled) return;

    await _showNotification(
      id: 1001,
      title: 'Emergency alert started',
      body: 'AfyaSOS is sending emergency alerts to your trusted contacts.',
      importance: 'high',
    );
  }

  Future<void> showEmergencyCompleted() async {
    if (!await isEmergencyAlertsEnabled) return;

    await _showNotification(
      id: 1002,
      title: 'Emergency alert completed',
      body: 'Emergency SMS and call workflow has completed.',
      importance: 'high',
    );
  }

  Future<void> showLocationShared() async {
    if (!await isLocationSharingAlertsEnabled) return;

    await _showNotification(
      id: 2001,
      title: 'Location shared',
      body: 'Your current location was included in the emergency alert.',
      importance: 'default',
    );
  }

  Future<void> showLocationSharingFailed(String reason) async {
    if (!await isLocationSharingAlertsEnabled) return;

    await _showNotification(
      id: 2002,
      title: 'Location sharing failed',
      body: reason,
      importance: 'default',
    );
  }

  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    required String importance,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await _channel.invokeMethod<void>('showNotification', {
        'id': id,
        'title': title,
        'body': body,
        'importance': importance,
        'sound': prefs.getBool('soundEnabled') ?? true,
        'vibration': prefs.getBool('vibrationEnabled') ?? true,
      });
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }
}
