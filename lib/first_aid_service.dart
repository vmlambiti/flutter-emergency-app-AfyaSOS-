import 'package:hive/hive.dart';

class FirstAidService {
  static const String boxName = 'firstAidBox';
  static const String dataKey = 'hypertension_first_aid';

  static Future<Box> _openBox() async {
    return await Hive.openBox(boxName);
  }

  static Future<void> saveDefaultFirstAidDataIfNeeded(
    String languageCode,
  ) async {
    final box = await _openBox();

    if (box.containsKey(dataKey)) {
      return;
    }

    final Map<String, dynamic> firstAidData = _buildDefaultFirstAidData(
      languageCode,
    );
    await box.put(dataKey, firstAidData);
  }

  static Future<void> refreshDefaultFirstAidData(String languageCode) async {
    final box = await _openBox();
    final Map<String, dynamic> firstAidData = _buildDefaultFirstAidData(
      languageCode,
    );
    await box.put(dataKey, firstAidData);
  }

  static Map<String, dynamic> _buildDefaultFirstAidData(String languageCode) {
    if (languageCode == 'sw') {
      return {
        'title': 'Shinikizo la Damu Kali',
        'warning':
            'Shinikizo la damu lililo juu sana linaweza kusababisha kiharusi, mshtuko wa moyo, au uharibifu wa viungo. Chukua hatua haraka na tulia.',
        'symptoms': [
          'Maumivu makali ya kichwa',
          'Maumivu ya kifua',
          'Kupumua kwa shida',
          'Kizunguzungu au kuchanganyikiwa',
          'Kuona kwa ukungu au mabadiliko ya kuona',
          'Kutokwa na damu puani',
        ],
        'dos': [
          'Tulia na mhakikishie mgonjwa',
          'Msaidie mgonjwa akae kwa wima kwa utulivu',
          'Legeza nguo zinazombana shingoni au kifuani',
          'Mhamasishe kupumua polepole na kwa utulivu',
          'Fuatilia hali yake kwa karibu',
        ],
        'donts': [
          'Usimpe dawa bila uhakika',
          'Usimpe kafeini au pombe',
          'Usipuuze dalili hatari',
          'Usichelewe kutafuta msaada',
        ],
        'specialNotes': [
          'Wazee wanapaswa kufuatiliwa kwa karibu sana',
          'Wanawake wajawazito wanahitaji msaada wa haraka wa kitabibu',
          'Watoto wenye dalili kali wanapaswa kupelekwa hospitali mara moja',
        ],
        'emergencySteps': [
          'Piga huduma za dharura au hospitali iliyo karibu',
          'Msaidie mgonjwa kutumia dawa alizoandikiwa tu kama zipo',
          'Tumia kitufe cha SOS kwenye AfyaSOS',
        ],
      };
    }

    return {
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
  }

  static Future<Map<dynamic, dynamic>?> getFirstAidData() async {
    final box = await _openBox();
    final data = box.get(dataKey);

    if (data is Map) {
      return Map<dynamic, dynamic>.from(data);
    }

    return null;
  }

  static Future<void> clearFirstAidData() async {
    final box = await _openBox();
    await box.delete(dataKey);
  }
}
