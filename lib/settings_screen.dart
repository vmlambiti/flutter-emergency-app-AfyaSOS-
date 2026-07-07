import 'package:flutter/material.dart';
import 'theme_screen.dart';
import 'notifications_screen.dart';
import 'about_screen.dart';
import 'help_screen.dart';
import 'privacy_policy_screen.dart';
import 'language_setting_screen.dart';
import 'main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          strings.settings,
          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: titleColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.preferences,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 14),

            _buildSettingsCard(
              context,
              icon: Icons.notifications_rounded,
              title: strings.notifications,
              subtitle: strings.notificationsSubtitle,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            _buildSettingsCard(
              context,
              icon: Icons.palette_rounded,
              title: strings.themes,
              subtitle: strings.themesSubtitle,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ThemeScreen()),
                );
              },
            ),

            const SizedBox(height: 14),

            _buildSettingsCard(
              context,
              icon: Icons.language_rounded,
              title: strings.language,
              subtitle: strings.changeAppLanguage,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageSettingScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            Text(
              strings.supportAndInfo,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 14),

            _buildSettingsCard(
              context,
              icon: Icons.info_rounded,
              title: strings.about,
              subtitle: strings.aboutSubtitle,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),

            const SizedBox(height: 14),

            _buildSettingsCard(
              context,
              icon: Icons.help_rounded,
              title: strings.help,
              subtitle: strings.helpSubtitle,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              },
            ),

            const SizedBox(height: 14),

            _buildSettingsCard(
              context,
              icon: Icons.privacy_tip_rounded,
              title: strings.privacyPolicy,
              subtitle: strings.privacyPolicySubtitle,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color cardColor,
    required Color titleColor,
    required Color subTitleColor,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
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
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: subTitleColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
