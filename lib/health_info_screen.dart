import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'bluetooth_service.dart';
import 'emergency_service.dart';
import 'main.dart';

String calculateHealthStatus({required int heartRate, required int spo2}) {
  final isNormalHeartRate = heartRate >= 60 && heartRate <= 100;
  final isNormalSpo2 = spo2 >= 95;

  return isNormalHeartRate && isNormalSpo2 ? "Normal" : "Abnormal";
}

class HealthInfoScreen extends StatefulWidget {
  const HealthInfoScreen({super.key});

  @override
  State<HealthInfoScreen> createState() => _HealthInfoScreenState();
}

class _HealthInfoScreenState extends State<HealthInfoScreen> {
  static const String boxName = 'userBox';
  static const String healthKey = 'health_info';
  static const String readingsKey = 'health_readings';
  static const int maxStoredReadings = 50;
  static const Duration duplicateReadingWindow = Duration(seconds: 2);
  static const int abnormalReadingsBeforeSos = 3;

  static const List<String> _hypertensionMedications = [
    'Amlodipine',
    'Nifedipine',
    'Enalapril',
    'Lisinopril',
    'Losartan',
    'Hydrochlorothiazide',
    'Atenolol',
    'Other / Not listed',
  ];

  static const List<String> _tanzaniaHospitals = [
    'Muhimbili National Hospital (MNH)',
    'Jakaya Kikwete Cardiac Institute (JKCI)',
    'Aga Khan Hospital Dar es Salaam',
    'Benjamin Mkapa Hospital',
    'Kilimanjaro Christian Medical Centre (KCMC)',
    'Bugando Medical Centre',
    'Tumbi Regional Referral Hospital',
    'Amana Regional Referral Hospital',
    'Temeke Regional Referral Hospital',
    'Mwananyamala Regional Referral Hospital',
    'Other / Not listed',
  ];

  final PageController _pageController = PageController();
  final AfyaBluetoothService _bluetoothService = AfyaBluetoothService.instance;
  StreamSubscription<SensorReading>? _sensorReadingSubscription;
  Future<void> _readingWriteQueue = Future<void>.value();
  SensorReading? _lastSavedSensorReading;
  DateTime? _lastSavedReadingAt;
  int _consecutiveAbnormalReadings = 0;
  bool _autoSosTriggeredForCurrentAbnormalStreak = false;
  int _currentStep = 0;

  String medicalConditions = "";
  String allergies = "";
  String medications = "";
  String doctorName = "";
  String preferredHospital = "";
  String healthNotes = "";

  final TextEditingController conditionController = TextEditingController();
  final TextEditingController allergyController = TextEditingController();
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  bool _isEditingHealthInfo = false;
  TextEditingController? _openHealthDropdownController;

  String connectionStatus = "";
  String heartRate = "";
  String spo2 = "";
  String monitoringMode = "";
  String monitoringStatus = "";
  String lastUpdated = "";

  List<Map<String, dynamic>> recentReadings = [];

  @override
  void initState() {
    super.initState();

    _loadHealthInfo();
    _loadRecentReadings();
    connectionStatus = _bluetoothService.connectionStatusText;
    _applyDisconnectedMonitoringValues();
    _bluetoothService.addListener(_updateBluetoothConnectionStatus);
    _sensorReadingSubscription = _bluetoothService.sensorReadingStream.listen(
      _updateSensorReading,
    );
    _bluetoothService.scanAndConnectToEsp32Sensor();
  }

  @override
  void dispose() {
    _bluetoothService.removeListener(_updateBluetoothConnectionStatus);
    _sensorReadingSubscription?.cancel();
    _pageController.dispose();
    conditionController.dispose();
    allergyController.dispose();
    medicationController.dispose();
    doctorController.dispose();
    hospitalController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _updateBluetoothConnectionStatus() {
    if (!mounted) return;

    setState(() {
      connectionStatus = _bluetoothService.connectionStatusText;
      if (_bluetoothService.connectionState ==
          AfyaBluetoothConnectionState.disconnected) {
        _applyDisconnectedMonitoringValues();
      } else if (_bluetoothService.connectionState ==
          AfyaBluetoothConnectionState.connected) {
        monitoringStatus = "Not available";
      }
    });
  }

  void _updateSensorReading(SensorReading reading) {
    if (!mounted) return;

    final status = calculateHealthStatus(
      heartRate: reading.heartRate,
      spo2: reading.spo2,
    );

    setState(() {
      heartRate = reading.heartRate.toString();
      spo2 = reading.spo2.toString();
      monitoringStatus = status;
    });

    _saveReading(reading: reading, status: status);
    _handleAutomaticEmergencyDetection(status);
  }

  void _applyDisconnectedMonitoringValues() {
    heartRate = "Not available";
    spo2 = "Not available";
    monitoringStatus = "Disconnected";
    _consecutiveAbnormalReadings = 0;
    _autoSosTriggeredForCurrentAbnormalStreak = false;
  }

  void _handleAutomaticEmergencyDetection(String status) {
    if (status == "Normal") {
      _consecutiveAbnormalReadings = 0;
      _autoSosTriggeredForCurrentAbnormalStreak = false;
      return;
    }

    if (status != "Abnormal") return;

    _consecutiveAbnormalReadings += 1;

    if (_consecutiveAbnormalReadings < abnormalReadingsBeforeSos ||
        _autoSosTriggeredForCurrentAbnormalStreak) {
      return;
    }

    _autoSosTriggeredForCurrentAbnormalStreak = true;
    unawaited(triggerSOS(context));
  }

  Future<Box> _openUserBox() async => Hive.openBox(boxName);

  Future<void> _loadHealthInfo() async {
    final box = await _openUserBox();
    final data = box.get(healthKey);

    if (data is Map) {
      setState(() {
        medicalConditions = data['condition']?.toString() ?? "";
        allergies = data['allergy']?.toString() ?? "";
        medications = data['medication']?.toString() ?? "";
        doctorName = data['doctor']?.toString() ?? "";
        preferredHospital = data['hospital']?.toString() ?? "";
        healthNotes = data['healthNotes']?.toString() ?? "";
        _syncHealthInfoControllers();
      });
    }
  }

  void _syncHealthInfoControllers() {
    conditionController.text = medicalConditions;
    allergyController.text = allergies;
    medicationController.text = medications;
    doctorController.text = doctorName;
    hospitalController.text = preferredHospital;
    notesController.text = healthNotes;
  }

  Future<void> _loadRecentReadings() async {
    final box = await _openUserBox();

    List<dynamic> data = box.get(readingsKey, defaultValue: []);

    final readings = List<Map<String, dynamic>>.from(data)
      ..sort((a, b) {
        final aTimestamp = DateTime.tryParse(a['timestamp']?.toString() ?? "");
        final bTimestamp = DateTime.tryParse(b['timestamp']?.toString() ?? "");

        if (aTimestamp == null && bTimestamp == null) return 0;
        if (aTimestamp == null) return 1;
        if (bTimestamp == null) return -1;

        return bTimestamp.compareTo(aTimestamp);
      });

    if (!mounted) return;

    setState(() {
      recentReadings = readings.take(maxStoredReadings).toList();
    });
  }

  Future<void> _saveHealthInfo() async {
    final box = await _openUserBox();

    final Map<String, dynamic> healthData = {
      'condition': medicalConditions,
      'allergy': allergies,
      'medication': medications,
      'doctor': doctorName,
      'hospital': preferredHospital,
      'healthNotes': healthNotes,
    };

    await box.put(healthKey, healthData);
  }

  void _saveReading({required SensorReading reading, required String status}) {
    final timestamp = DateTime.now();

    if (_isDuplicateReading(reading, timestamp)) return;

    _lastSavedSensorReading = reading;
    _lastSavedReadingAt = timestamp;

    final Map<String, dynamic> savedReading = {
      'heartRate': reading.heartRate,
      'spo2': reading.spo2,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };

    setState(() {
      recentReadings = [
        savedReading,
        ...recentReadings,
      ].take(maxStoredReadings).toList();
    });

    final readingsSnapshot = List<Map<String, dynamic>>.from(recentReadings);
    _readingWriteQueue = _readingWriteQueue
        .then((_) => _saveRecentReadingsSnapshot(readingsSnapshot))
        .catchError((Object error, StackTrace stackTrace) {
          debugPrint('Failed to save sensor reading: $error');
        });
  }

  bool _isDuplicateReading(SensorReading reading, DateTime timestamp) {
    final previousReading = _lastSavedSensorReading;
    final previousTimestamp = _lastSavedReadingAt;

    if (previousReading == null || previousTimestamp == null) return false;

    final hasSameValues =
        previousReading.heartRate == reading.heartRate &&
        previousReading.spo2 == reading.spo2;
    final isWithinDuplicateWindow =
        timestamp.difference(previousTimestamp) <= duplicateReadingWindow;

    return hasSameValues && isWithinDuplicateWindow;
  }

  Future<void> _saveRecentReadingsSnapshot(
    List<Map<String, dynamic>> readings,
  ) async {
    final box = await _openUserBox();
    await box.put(readingsKey, readings);
  }

  void _startEditingHealthInfo() {
    _syncHealthInfoControllers();
    setState(() {
      _isEditingHealthInfo = true;
      _openHealthDropdownController = null;
    });
  }

  Future<void> _saveInlineHealthInfo() async {
    setState(() {
      medicalConditions = conditionController.text.trim();
      allergies = allergyController.text.trim();
      medications = medicationController.text.trim();
      doctorName = doctorController.text.trim();
      preferredHospital = hospitalController.text.trim();
      healthNotes = notesController.text.trim();
    });

    await _saveHealthInfo();

    if (!mounted) return;

    setState(() {
      _isEditingHealthInfo = false;
      _openHealthDropdownController = null;
    });
  }

  void _nextPage() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = MyApp.of(context)!.strings;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF7F8FC);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subColor = isDark ? const Color(0xFFB0B0B0) : const Color(0xFF666666);
    const primaryColor = Color(0xFF5B5CEB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          strings.healthInfo,
          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                    height: 8,
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? primaryColor
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    strings.healthProfile,
                    textAlign: TextAlign.start,
                    softWrap: true,
                  ),
                ),
                Expanded(
                  child: Text(
                    strings.liveMonitoring,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                Expanded(
                  child: Text(
                    strings.recentReadings,
                    textAlign: TextAlign.end,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentStep = index);
              },
              children: [
                _healthProfilePage(cardColor, titleColor, subColor, strings),
                _liveMonitoringPage(cardColor, titleColor, subColor, strings),
                _recentReadingsPage(cardColor, titleColor, subColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _healthProfilePage(
    Color cardColor,
    Color titleColor,
    Color subColor,
    dynamic strings,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF3F4F8);
    final borderColor = isDark
        ? const Color(0xFF383838)
        : const Color(0xFFE2E5EE);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _item(
                  cardColor,
                  titleColor,
                  subColor,
                  strings.medicalConditions,
                  medicalConditions,
                  editor: _buildTextField(
                    strings.medicalConditions,
                    conditionController,
                    fillColor,
                    borderColor,
                    maxLines: 2,
                  ),
                ),
                _item(
                  cardColor,
                  titleColor,
                  subColor,
                  strings.allergies,
                  allergies,
                  editor: _buildTextField(
                    strings.allergies,
                    allergyController,
                    fillColor,
                    borderColor,
                    maxLines: 2,
                  ),
                ),
                _item(
                  cardColor,
                  titleColor,
                  subColor,
                  strings.medications,
                  medications,
                  editor: _buildHealthDropdown(
                    strings.medications,
                    medicationController,
                    fillColor,
                    borderColor,
                    _hypertensionMedications,
                  ),
                ),
                _item(
                  cardColor,
                  titleColor,
                  subColor,
                  strings.doctorName,
                  doctorName,
                  editor: _buildTextField(
                    strings.doctorName,
                    doctorController,
                    fillColor,
                    borderColor,
                  ),
                ),
                _item(
                  cardColor,
                  titleColor,
                  subColor,
                  strings.preferredHospitalClinic,
                  preferredHospital,
                  editor: _buildHealthDropdown(
                    strings.preferredHospitalClinic,
                    hospitalController,
                    fillColor,
                    borderColor,
                    _tanzaniaHospitals,
                  ),
                ),
                _item(
                  cardColor,
                  titleColor,
                  subColor,
                  strings.healthNotes,
                  healthNotes,
                  editor: _buildTextField(
                    strings.healthNotes,
                    notesController,
                    fillColor,
                    borderColor,
                    maxLines: 4,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _isEditingHealthInfo
                        ? _saveInlineHealthInfo
                        : _startEditingHealthInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B5CEB),
                    ),
                    child: Text(
                      _isEditingHealthInfo
                          ? "Save Changes"
                          : strings.editHealthInformation,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: _nextPage,
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }

  Widget _liveMonitoringPage(
    Color cardColor,
    Color titleColor,
    Color subColor,
    dynamic strings,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _item(
                  cardColor,
                  titleColor,
                  subColor,
                  strings.connectionStatus,
                  connectionStatus,
                ),
                _item(cardColor, titleColor, subColor, "Heart Rate", heartRate),
                _item(cardColor, titleColor, subColor, "SpO₂", spo2),
                _item(
                  cardColor,
                  titleColor,
                  subColor,
                  "Status",
                  monitoringStatus,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousPage,
                icon: const Icon(Icons.arrow_back_ios),
              ),
              IconButton(
                onPressed: _nextPage,
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recentReadingsPage(
    Color cardColor,
    Color titleColor,
    Color subColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: recentReadings.length,
              itemBuilder: (context, index) {
                final r = recentReadings[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      "Heart Rate: ${r['heartRate']} BPM\nSpO₂: ${r['spo2']}%",
                    ),
                    subtitle: Text(
                      "Status: ${r['status']}\nTime: ${r['timestamp']}",
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: _previousPage,
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
    Color cardColor,
    Color titleColor,
    Color subColor,
    String title,
    String value, {
    Widget? editor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          if (_isEditingHealthInfo && editor != null)
            editor
          else
            Text(
              value.isEmpty ? "Not provided yet" : value,
              style: TextStyle(color: subColor),
            ),
        ],
      ),
    );
  }

  Widget _buildHealthDropdown(
    String hint,
    TextEditingController controller,
    Color fillColor,
    Color borderColor,
    List<String> options,
  ) {
    final savedValue = controller.text.trim();
    final dropdownOptions = List<String>.from(options);
    if (savedValue.isNotEmpty && !dropdownOptions.contains(savedValue)) {
      dropdownOptions.add(savedValue);
    }
    final isOpen = identical(_openHealthDropdownController, controller);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _openHealthDropdownController = isOpen ? null : controller;
            });
          },
          child: InputDecorator(
            isFocused: isOpen,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF5B5CEB),
                  width: 1.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    savedValue.isEmpty ? hint : savedValue,
                    style: savedValue.isEmpty
                        ? TextStyle(color: Theme.of(context).hintColor)
                        : null,
                  ),
                ),
                Icon(isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (isOpen) ...[
          const SizedBox(height: 4),
          Container(
            constraints: const BoxConstraints(maxHeight: 240),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: dropdownOptions.length,
              itemBuilder: (context, index) {
                final option = dropdownOptions[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      controller.text = option;
                      _openHealthDropdownController = null;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Text(option),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

Widget _buildTextField(
  String hint,
  TextEditingController controller,
  Color fillColor,
  Color borderColor, {
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF5B5CEB), width: 1.5),
      ),
    ),
  );
}
