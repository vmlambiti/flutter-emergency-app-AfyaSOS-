import 'package:flutter/material.dart';
import 'first_aid_service.dart';
import 'main.dart';

class FirstAidScreen extends StatefulWidget {
  const FirstAidScreen({super.key});

  @override
  State<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> {
  Map<dynamic, dynamic>? firstAidData;
  bool isLoading = true;
  String? _loadedLanguageCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final languageCode = MyApp.of(context)!.languageCode;
    if (_loadedLanguageCode == languageCode) {
      return;
    }

    _loadedLanguageCode = languageCode;
    isLoading = true;
    loadFirstAidData(languageCode);
  }

  Future<void> loadFirstAidData(String languageCode) async {
    try {
      debugPrint(
        'FirstAidScreen: loading first aid data for $languageCode',
      );
      final data = await FirstAidService.getOrInitializeFirstAidData(
        languageCode,
      );

      if (!mounted || _loadedLanguageCode != languageCode) return;

      setState(() {
        firstAidData = data;
        isLoading = false;
      });
      debugPrint('FirstAidScreen: first aid data loading completed');
    } catch (error, stackTrace) {
      debugPrint('FirstAidScreen: failed to load first aid data: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted || _loadedLanguageCode != languageCode) return;

      setState(() {
        firstAidData = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = MyApp.of(context)!.strings;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(strings.firstAid), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : firstAidData == null
          ? Center(child: Text(strings.noFirstAidDataFound))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWarningCard(colorScheme),
                  const SizedBox(height: 16),

                  _buildSectionTitle(strings.symptoms, colorScheme),
                  _buildListCard(
                    items: List<String>.from(firstAidData!['symptoms'] ?? []),
                    icon: Icons.warning_amber_rounded,
                    colorScheme: colorScheme,
                  ),

                  const SizedBox(height: 16),

                  _buildSectionTitle(strings.whatToDo, colorScheme),
                  _buildListCard(
                    items: List<String>.from(firstAidData!['dos'] ?? []),
                    icon: Icons.check_circle_outline,
                    colorScheme: colorScheme,
                  ),

                  const SizedBox(height: 16),

                  _buildSectionTitle(strings.whatNotToDo, colorScheme),
                  _buildListCard(
                    items: List<String>.from(firstAidData!['donts'] ?? []),
                    icon: Icons.cancel_outlined,
                    colorScheme: colorScheme,
                  ),

                  const SizedBox(height: 16),

                  _buildSectionTitle(strings.specialNotes, colorScheme),
                  _buildListCard(
                    items: List<String>.from(
                      firstAidData!['specialNotes'] ?? [],
                    ),
                    icon: Icons.info_outline,
                    colorScheme: colorScheme,
                  ),

                  const SizedBox(height: 16),

                  _buildSectionTitle(strings.emergencyAction, colorScheme),
                  _buildListCard(
                    items: List<String>.from(
                      firstAidData!['emergencySteps'] ?? [],
                    ),
                    icon: Icons.emergency_outlined,
                    colorScheme: colorScheme,
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(strings.sosActionNext)),
                        );
                      },
                      icon: const Icon(Icons.sos),
                      label: Text(strings.useSos),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildWarningCard(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            firstAidData!['title'] ?? '',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            firstAidData!['warning'] ?? '',
            style: TextStyle(fontSize: 15, color: colorScheme.onErrorContainer),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildListCard({
    required List<String> items,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 15,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
