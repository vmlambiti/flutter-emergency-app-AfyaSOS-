import 'package:flutter/material.dart';
import 'main.dart';

class LanguageSettingScreen extends StatefulWidget {
  const LanguageSettingScreen({super.key});

  @override
  State<LanguageSettingScreen> createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
  String selectedLanguage = 'en';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedLanguage = MyApp.of(context)?.languageCode ?? 'en';
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      selectedLanguage = languageCode;
    });
    MyApp.of(context)?.changeLanguage(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final strings = MyApp.of(context)!.strings;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF7F8FC);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color titleColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final Color subTitleColor = isDark
        ? const Color(0xFFB0B0B0)
        : const Color(0xFF666666);
    final Color primaryColor = const Color(0xFF5B5CEB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        title: Text(
          strings.language,
          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: titleColor),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.chooseLanguage,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.selectLanguageMessage,
              style: TextStyle(fontSize: 14, color: subTitleColor, height: 1.5),
            ),
            const SizedBox(height: 24),

            _buildLanguageOption(
              title: strings.english,
              subtitle: "English",
              value: 'en',
              selectedValue: selectedLanguage,
              icon: Icons.language_rounded,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 14),

            _buildLanguageOption(
              title: strings.swahili,
              subtitle: "Kiswahili",
              value: 'sw',
              selectedValue: selectedLanguage,
              icon: Icons.translate_rounded,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String subtitle,
    required String value,
    required String selectedValue,
    required IconData icon,
    required Color cardColor,
    required Color titleColor,
    required Color subTitleColor,
    required Color primaryColor,
  }) {
    final bool isSelected = value == selectedValue;

    return GestureDetector(
      onTap: () {
        _changeLanguage(value);
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: subTitleColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: selectedValue,
              activeColor: primaryColor,
              onChanged: (newValue) {
                if (newValue != null) {
                  _changeLanguage(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
