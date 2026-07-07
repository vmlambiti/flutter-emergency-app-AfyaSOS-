import 'package:flutter/material.dart';
import 'main.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  String selectedTheme = "System Default";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentTheme = MyApp.of(context)?.themeMode ?? ThemeMode.system;

    if (currentTheme == ThemeMode.light) {
      selectedTheme = "Light Theme";
    } else if (currentTheme == ThemeMode.dark) {
      selectedTheme = "Dark Theme";
    } else {
      selectedTheme = "System Default";
    }
  }

  void _changeTheme(String value) {
    setState(() {
      selectedTheme = value;
    });

    if (value == "Light Theme") {
      MyApp.of(context)?.changeTheme(ThemeMode.light);
    } else if (value == "Dark Theme") {
      MyApp.of(context)?.changeTheme(ThemeMode.dark);
    } else {
      MyApp.of(context)?.changeTheme(ThemeMode.system);
    }
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
          strings.themes,
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
              strings.themeTitle,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.themeIntro,
              style: TextStyle(fontSize: 14, color: subTitleColor, height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildThemeOption(
              title: strings.lightThemeTitle,
              subtitle: strings.lightThemeSubtitle,
              icon: Icons.light_mode_rounded,
              value: "Light Theme",
              selectedValue: selectedTheme,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
            ),
            const SizedBox(height: 14),
            _buildThemeOption(
              title: strings.darkThemeTitle,
              subtitle: strings.darkThemeSubtitle,
              icon: Icons.dark_mode_rounded,
              value: "Dark Theme",
              selectedValue: selectedTheme,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
            ),
            const SizedBox(height: 14),
            _buildThemeOption(
              title: strings.systemThemeTitle,
              subtitle: strings.systemThemeSubtitle,
              icon: Icons.settings_suggest_rounded,
              value: "System Default",
              selectedValue: selectedTheme,
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

  Widget _buildThemeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required String selectedValue,
    required Color cardColor,
    required Color titleColor,
    required Color subTitleColor,
    required Color primaryColor,
  }) {
    final bool isSelected = value == selectedValue;

    return GestureDetector(
      onTap: () {
        _changeTheme(value);
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
                  _changeTheme(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
