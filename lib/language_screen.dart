import 'package:flutter/material.dart';
import 'info_screen.dart';
import 'main.dart'; // IMPORTANT: to access MyApp

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = "en"; // FIX: use code not name

  @override
  Widget build(BuildContext context) {
    final strings = MyApp.of(context)!.strings; // GET TEXTS

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color topGradient1 = isDark
        ? const Color(0xFF2B2E7F)
        : const Color(0xFF5B5CEB);

    final Color topGradient2 = isDark
        ? const Color(0xFF1E214F)
        : const Color(0xFF7A7CF4);

    final Color sheetColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    final Color mainTextColor = isDark ? Colors.white : const Color(0xFF1F1F1F);

    final Color secondaryTextColor = isDark
        ? const Color(0xFFB0B0B0)
        : const Color(0xFF6E6E6E);

    final Color unselectedBorderColor = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFE3E3E3);

    final Color selectedBorderColor = isDark
        ? const Color(0xFF8C8DFF)
        : const Color(0xFF6C63FF);

    final Color buttonColor = const Color(0xFF5B5CEB);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [topGradient1, topGradient2],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
                  decoration: BoxDecoration(
                    color: sheetColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        strings.chooseLanguage, // FIXED
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: mainTextColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        strings.selectLanguageMessage, // FIXED
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: secondaryTextColor,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "SUGGESTED",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildLanguageCard(
                              context: context,
                              language: "en",
                              displayName: strings.english,
                              subtitle: "United States",
                              flagPath: "assets/flags/usa_flag_clean.png",
                              isSelected: selectedLanguage == "en",
                              mainTextColor: mainTextColor,
                              secondaryTextColor: secondaryTextColor,
                              selectedBorderColor: selectedBorderColor,
                              unselectedBorderColor: unselectedBorderColor,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildLanguageCard(
                              context: context,
                              language: "sw",
                              displayName: strings.swahili,
                              subtitle: "Tanzania",
                              flagPath: "assets/flags/tanzania_flag_clean.png",
                              isSelected: selectedLanguage == "sw",
                              mainTextColor: mainTextColor,
                              secondaryTextColor: secondaryTextColor,
                              selectedBorderColor: selectedBorderColor,
                              unselectedBorderColor: unselectedBorderColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () async {
                            // 🔥 SAVE LANGUAGE
                            await MyApp.of(
                              context,
                            )!.changeLanguage(selectedLanguage);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InfoScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
                            strings.continueText.toUpperCase(), // FIXED
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard({
    required BuildContext context,
    required String language,
    required String displayName,
    required String subtitle,
    required String flagPath,
    required bool isSelected,
    required Color mainTextColor,
    required Color secondaryTextColor,
    required Color selectedBorderColor,
    required Color unselectedBorderColor,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF252525)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? selectedBorderColor : unselectedBorderColor,
            width: isSelected ? 2 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(flagPath, height: 40, width: 40),
            const SizedBox(height: 12),
            Text(
              displayName, // FIXED
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: mainTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: secondaryTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
