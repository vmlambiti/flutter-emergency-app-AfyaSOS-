import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

enum AfyaBluetoothConnectionState {
  disconnected,
  scanning,
  connecting,
  connected,
}

class SensorReading {
  const SensorReading({required this.heartRate, required this.spo2});

  final int heartRate;
  final int spo2;

  static SensorReading? fromRawJson(String rawMessage) {
    try {
      final decoded = jsonDecode(rawMessage);
      if (decoded is! Map) return null;

      final heartRate = _asInt(decoded['heartRate']);
      final spo2 = _asInt(decoded['spo2']);

      if (heartRate == null || spo2 == null) return null;

      return SensorReading(heartRate: heartRate, spo2: spo2);
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  static int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num && value.isFinite) return value.toInt();
    return null;
  }
}

class AfyaBluetoothService extends ChangeNotifier {
  AfyaBluetoothService._() {
    _rawMessageSubscription = rawMessageStream.listen(_handleRawMessage);
  }

  static final AfyaBluetoothService instance = AfyaBluetoothService._();

  AfyaBluetoothConnectionState _connectionState =
      AfyaBluetoothConnectionState.disconnected;
  BluetoothDevice? _connectedDevice;
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
  StreamSubscription<String>? _rawMessageSubscription;
  final StreamController<String> _rawMessageController =
      StreamController<String>.broadcast();
  final StreamController<SensorReading> _sensorReadingController =
      StreamController<SensorReading>.broadcast();
  final List<StreamSubscription<List<int>>> _valueSubscriptions = [];
  final List<BluetoothCharacteristic> _notifyingCharacteristics = [];
  DeviceIdentifier? _dataDeviceId;
  bool _isStartingDataReception = false;
  String _lineBuffer = '';

  AfyaBluetoothConnectionState get connectionState => _connectionState;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  Stream<String> get rawMessageStream => _rawMessageController.stream;
  Stream<SensorReading> get sensorReadingStream =>
      _sensorReadingController.stream;

  String get connectionStatusText {
    switch (_connectionState) {
      case AfyaBluetoothConnectionState.disconnected:
        return 'Disconnected';
      case AfyaBluetoothConnectionState.scanning:
        return 'Scanning';
      case AfyaBluetoothConnectionState.connecting:
        return 'Connecting';
      case AfyaBluetoothConnectionState.connected:
        return 'Connected';
    }
  }

  Future<bool> get isBluetoothAvailable async {
    if (kIsWeb) return false;

    try {
      return await FlutterBluePlus.isSupported;
    } catch (_) {
      return false;
    }
  }

  Future<void> initialize() async {
    _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.off ||
          state == BluetoothAdapterState.unavailable ||
          state == BluetoothAdapterState.unauthorized) {
        _setConnectionState(AfyaBluetoothConnectionState.disconnected);
      }
    });
  }

  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;
    if (Platform.isIOS || Platform.isMacOS) return true;

    if (!Platform.isAndroid) return true;

    final statuses = await <Permission>[
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  Future<List<ScanResult>> scanForDevices({
    Duration timeout = const Duration(seconds: 8),
  }) async {
    await initialize();

    final available = await isBluetoothAvailable;
    final permissionsGranted = await requestPermissions();

    if (!available || !permissionsGranted) {
      _setConnectionState(AfyaBluetoothConnectionState.disconnected);
      return const [];
    }

    _setConnectionState(AfyaBluetoothConnectionState.scanning);

    final results = <String, ScanResult>{};
    await _scanResultsSubscription?.cancel();
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((
      scanResults,
    ) {
      for (final result in scanResults) {
        results[result.device.remoteId.str] = result;
      }
    });

    try {
      await FlutterBluePlus.startScan(timeout: timeout);
      await Future<void>.delayed(timeout);
      await FlutterBluePlus.stopScan();
    } finally {
      await _scanResultsSubscription?.cancel();
      _scanResultsSubscription = null;
      if (_connectionState == AfyaBluetoothConnectionState.scanning) {
        _setConnectionState(AfyaBluetoothConnectionState.disconnected);
      }
    }

    return results.values.toList(growable: false);
  }

  Future<bool> connectToDevice(BluetoothDevice device) async {
    await initialize();

    final permissionsGranted = await requestPermissions();
    if (!permissionsGranted) {
      _setConnectionState(AfyaBluetoothConnectionState.disconnected);
      return false;
    }

    _setConnectionState(AfyaBluetoothConnectionState.connecting);

    await _connectionSubscription?.cancel();
    _connectionSubscription = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.connected) {
        _connectedDevice = device;
        _setConnectionState(AfyaBluetoothConnectionState.connected);
        unawaited(_startListeningForIncomingData(device));
      } else if (state == BluetoothConnectionState.disconnected) {
        if (_connectedDevice?.remoteId == device.remoteId) {
          _connectedDevice = null;
        }
        unawaited(_stopListeningForIncomingData());
        _setConnectionState(AfyaBluetoothConnectionState.disconnected);
      }
    });

    try {
      await device.connect(
        license: License.nonprofit,
        timeout: const Duration(seconds: 12),
      );
      _connectedDevice = device;
      _setConnectionState(AfyaBluetoothConnectionState.connected);
      unawaited(_startListeningForIncomingData(device));
      return true;
    } catch (_) {
      _connectedDevice = null;
      unawaited(_stopListeningForIncomingData());
      _setConnectionState(AfyaBluetoothConnectionState.disconnected);
      return false;
    }
  }

  Future<bool> scanAndConnectToEsp32Sensor({
    Duration scanTimeout = const Duration(seconds: 8),
  }) async {
    final results = await scanForDevices(timeout: scanTimeout);

    for (final result in results) {
      if (_isEsp32Sensor(result)) {
        return connectToDevice(result.device);
      }
    }

    _setConnectionState(AfyaBluetoothConnectionState.disconnected);
    return false;
  }

  Future<void> disconnect() async {
    final device = _connectedDevice;
    if (device != null) {
      await device.disconnect();
    }

    await _stopListeningForIncomingData();
    _connectedDevice = null;
    _setConnectionState(AfyaBluetoothConnectionState.disconnected);
  }

  Future<void> _startListeningForIncomingData(BluetoothDevice device) async {
    if (_isStartingDataReception ||
        (_dataDeviceId == device.remoteId && _valueSubscriptions.isNotEmpty)) {
      return;
    }

    _isStartingDataReception = true;
    await _stopListeningForIncomingData();
    _dataDeviceId = device.remoteId;

    try {
      final services = await device.discoverServices();

      for (final service in services) {
        for (final characteristic in service.characteristics) {
          final properties = characteristic.properties;
          if (!properties.notify && !properties.indicate) continue;

          final subscription = characteristic.onValueReceived.listen(
            _handleIncomingBytes,
            onError: (Object error, StackTrace stackTrace) {
              debugPrint('Bluetooth data stream error: $error');
              _rawMessageController.addError(error, stackTrace);
            },
            cancelOnError: false,
          );

          _valueSubscriptions.add(subscription);

          try {
            await characteristic.setNotifyValue(true);
            _notifyingCharacteristics.add(characteristic);
          } catch (error, stackTrace) {
            debugPrint('Failed to enable Bluetooth notifications: $error');
            _rawMessageController.addError(error, stackTrace);
            await subscription.cancel();
            _valueSubscriptions.remove(subscription);
          }
        }
      }

      if (_valueSubscriptions.isEmpty) {
        debugPrint('No notifiable Bluetooth characteristics found.');
      }
    } catch (error, stackTrace) {
      debugPrint('Failed to start Bluetooth data reception: $error');
      _rawMessageController.addError(error, stackTrace);
      await _stopListeningForIncomingData();
    } finally {
      _isStartingDataReception = false;
    }
  }

  Future<void> _stopListeningForIncomingData() async {
    for (final subscription in List<StreamSubscription<List<int>>>.from(
      _valueSubscriptions,
    )) {
      await subscription.cancel();
    }
    _valueSubscriptions.clear();

    for (final characteristic in List<BluetoothCharacteristic>.from(
      _notifyingCharacteristics,
    )) {
      try {
        await characteristic.setNotifyValue(false);
      } catch (error) {
        debugPrint('Failed to disable Bluetooth notifications: $error');
      }
    }
    _notifyingCharacteristics.clear();
    _dataDeviceId = null;
    _isStartingDataReception = false;
    _lineBuffer = '';
  }

  void _handleIncomingBytes(List<int> bytes) {
    if (bytes.isEmpty) return;

    String chunk;
    try {
      chunk = utf8.decode(bytes);
    } on FormatException catch (error, stackTrace) {
      debugPrint('Malformed Bluetooth data received: $error');
      _rawMessageController.addError(error, stackTrace);
      return;
    }

    _lineBuffer += chunk;
    final lines = _lineBuffer.split('\n');
    _lineBuffer = lines.removeLast();

    for (final line in lines) {
      final message = line.trimRight();
      if (message.isEmpty) continue;

      debugPrint('Received:\n$message');
      _rawMessageController.add(message);
    }
  }

  void _handleRawMessage(String message) {
    final reading = SensorReading.fromRawJson(message);
    if (reading == null) return;

    debugPrint('Heart Rate: ${reading.heartRate}\nSpO2: ${reading.spo2}');
    _sensorReadingController.add(reading);
  }

  bool _isEsp32Sensor(ScanResult result) {
    final advertisedName = result.advertisementData.advName.toLowerCase();
    final platformName = result.device.platformName.toLowerCase();
    final combinedName = '$advertisedName $platformName';

    return combinedName.contains('esp32') ||
        combinedName.contains('afyasos') ||
        combinedName.contains('sensor');
  }

  void _setConnectionState(AfyaBluetoothConnectionState state) {
    if (_connectionState == state) return;

    _connectionState = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanResultsSubscription?.cancel();
    _connectionSubscription?.cancel();
    _rawMessageSubscription?.cancel();
    for (final subscription in _valueSubscriptions) {
      subscription.cancel();
    }
    _rawMessageController.close();
    _sensorReadingController.close();
    super.dispose();
  }
}
