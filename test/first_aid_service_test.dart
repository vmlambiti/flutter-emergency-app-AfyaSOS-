import 'dart:io';

import 'package:afya_sos/first_aid_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp('first_aid_test_');
    Hive.init(hiveDirectory.path);
  });

  setUp(() async {
    await FirstAidService.clearFirstAidData();
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  test('returns complete content for both supported languages', () async {
    final english = await FirstAidService.getOrInitializeFirstAidData('en');
    final swahili = await FirstAidService.getOrInitializeFirstAidData('sw');

    expect(english?['title'], 'Hypertensive Crisis');
    expect(swahili?['title'], 'Shinikizo la Damu Kali');
    for (final key in const [
      'warning',
      'symptoms',
      'dos',
      'donts',
      'specialNotes',
      'emergencySteps',
    ]) {
      expect(english?[key], isNotEmpty, reason: 'Missing English $key');
      expect(swahili?[key], isNotEmpty, reason: 'Missing Swahili $key');
    }
  });

  test('migrates a legacy English record without losing its values', () async {
    final box = Hive.box(FirstAidService.boxName);
    await box.put(FirstAidService.dataKey, {
      'title': 'Hypertensive Crisis',
      'warning': 'Existing English warning',
      'symptoms': ['Existing symptom'],
    });

    final english = await FirstAidService.getOrInitializeFirstAidData('en');
    final swahili = await FirstAidService.getOrInitializeFirstAidData('sw');

    expect(english?['warning'], 'Existing English warning');
    expect(english?['symptoms'], ['Existing symptom']);
    expect(swahili?['title'], 'Shinikizo la Damu Kali');

    final migrated = box.get(FirstAidService.dataKey) as Map;
    expect(migrated['schemaVersion'], 2);
    expect((migrated['languages'] as Map).keys, containsAll(['en', 'sw']));
  });
}
