import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class FirstAidService {
  static const String boxName = 'firstAidBox';
  static const String dataKey = 'hypertension_first_aid';
  static const int _schemaVersion = 2;

  static const Map<String, dynamic> _englishContent = {
    'title': 'Hypertensive Crisis',
    'warning':
        'Very high blood pressure can lead to stroke, heart attack, or organ damage. Act quickly and stay calm.',
    'symptoms': [
      'Severe headache',
      'Chest pain',
      'Shortness of breath',
      'Dizziness or confusion',
      'Blurred vision or vision changes',
      'Nosebleeds',
    ],
    'dos': [
      'Stay calm and reassure the person',
      'Help the person sit upright comfortably',
      'Loosen tight clothing around the neck or chest',
      'Encourage slow and calm breathing',
      'Monitor the condition closely',
    ],
    'donts': [
      'Do not give random medicine',
      'Do not give caffeine or alcohol',
      'Do not ignore serious symptoms',
      'Do not delay calling for help',
    ],
    'specialNotes': [
      'Older adults should be monitored very closely',
      'Pregnant women need urgent medical attention',
      'Children with severe symptoms should be taken for medical help immediately',
    ],
    'emergencySteps': [
      'Call emergency services or a nearby hospital',
      'Help the person use only prescribed medication if available',
      'Use the SOS button in AfyaSOS',
    ],
  };

  static const Map<String, dynamic> _swahiliContent = {
    'title': 'Shinikizo la Damu Kali',
    'warning':
        'Shinikizo la damu lililo juu sana linaweza kusababisha kiharusi, mshtuko wa moyo, au uharibifu wa viungo. Chukua hatua haraka na utulie.',
    'symptoms': [
      'Maumivu makali ya kichwa',
      'Maumivu ya kifua',
      'Kupumua kwa shida',
      'Kizunguzungu au kuchanganyikiwa',
      'Kuona kwa ukungu au mabadiliko ya uwezo wa kuona',
      'Kutokwa na damu puani',
    ],
    'dos': [
      'Tulia na umtulize mgonjwa',
      'Msaidie mgonjwa akae wima kwa starehe',
      'Legeza nguo zinazombana shingoni au kifuani',
      'Mhimize apumue polepole na kwa utulivu',
      'Fuatilia hali yake kwa karibu',
    ],
    'donts': [
      'Usimpe dawa yoyote bila maelekezo',
      'Usimpe kafeini au pombe',
      'Usipuuze dalili hatari',
      'Usichelewe kuita msaada',
    ],
    'specialNotes': [
      'Wazee wanapaswa kufuatiliwa kwa karibu sana',
      'Wanawake wajawazito wanahitaji huduma ya matibabu ya haraka',
      'Watoto wenye dalili kali wanapaswa kupelekwa kupata matibabu mara moja',
    ],
    'emergencySteps': [
      'Piga simu kwa huduma za dharura au hospitali iliyo karibu',
      'Msaidie mgonjwa kutumia dawa alizoandikiwa pekee, ikiwa zinapatikana',
      'Tumia kitufe cha SOS katika AfyaSOS',
    ],
  };

  static Future<Box> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }
    return Hive.openBox(boxName);
  }

  static Map<String, dynamic> _defaultPayload() => {
    'schemaVersion': _schemaVersion,
    'languages': {
      'en': Map<String, dynamic>.from(_englishContent),
      'sw': Map<String, dynamic>.from(_swahiliContent),
    },
  };

  static bool _isBilingualPayload(dynamic value) {
    if (value is! Map) return false;
    final languages = value['languages'];
    return languages is Map && languages['en'] is Map && languages['sw'] is Map;
  }

  static String _legacyLanguage(Map<dynamic, dynamic> data) {
    final title = data['title']?.toString().toLowerCase() ?? '';
    return title.contains('shinikizo') ? 'sw' : 'en';
  }

  /// Converts the former single-language record into a bilingual record.
  /// Existing values are retained in the language they belong to.
  static Map<String, dynamic> _migrate(dynamic stored) {
    final payload = _defaultPayload();
    if (stored is! Map) return payload;

    if (_isBilingualPayload(stored)) {
      final storedLanguages = stored['languages'] as Map;
      final languages = payload['languages'] as Map<String, dynamic>;
      for (final code in const ['en', 'sw']) {
        final existing = storedLanguages[code];
        if (existing is Map) {
          languages[code] = {
            ...(languages[code] as Map<String, dynamic>),
            ...Map<String, dynamic>.from(existing),
          };
        }
      }
      return payload;
    }

    final language = _legacyLanguage(stored);
    final languages = payload['languages'] as Map<String, dynamic>;
    languages[language] = {
      ...(languages[language] as Map<String, dynamic>),
      ...Map<String, dynamic>.from(stored),
    };
    return payload;
  }

  static Future<Map<String, dynamic>> _ensureBilingualData() async {
    final box = await _openBox();
    final stored = box.get(dataKey);
    final payload = _migrate(stored);

    if (!_isBilingualPayload(stored) ||
        stored['schemaVersion'] != _schemaVersion) {
      await box.put(dataKey, payload);
    }
    return payload;
  }

  static Future<void> saveDefaultFirstAidDataIfNeeded(
    String languageCode,
  ) async {
    await _ensureBilingualData();
  }

  static Future<void> refreshDefaultFirstAidData(String languageCode) async {
    final box = await _openBox();
    await box.put(dataKey, _defaultPayload());
  }

  static Future<Map<dynamic, dynamic>?> getFirstAidData([
    String languageCode = 'en',
  ]) async {
    return getOrInitializeFirstAidData(languageCode);
  }

  static Future<Map<dynamic, dynamic>?> getOrInitializeFirstAidData(
    String languageCode,
  ) async {
    try {
      final payload = await _ensureBilingualData();
      final languages = payload['languages'] as Map;
      final content = languages[languageCode] ?? languages['en'];
      return content is Map ? Map<dynamic, dynamic>.from(content) : null;
    } catch (error, stackTrace) {
      debugPrint('FirstAidService: error loading first aid data: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  static Future<void> clearFirstAidData() async {
    final box = await _openBox();
    await box.delete(dataKey);
  }
}
