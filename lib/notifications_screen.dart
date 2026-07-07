import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool emergencyAlerts = true;
  bool sosConfirmation = true;
  bool locationSharingAlerts = true;
  bool soundEnabled = true;
  bool vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      emergencyAlerts = prefs.getBool('emergencyAlerts') ?? true;
      sosConfirmation = prefs.getBool('sosConfirmation') ?? true;
      locationSharingAlerts = prefs.getBool('locationSharingAlerts') ?? true;
      soundEnabled = prefs.getBool('soundEnabled') ?? true;
      vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
    });
  }

  Future<void> _saveNotificationSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final strings = MyApp.of(context)!.strings; // ✅ FIXED
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
          strings.notifications,
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
              strings.notificationTitle,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.notificationIntro,
              style: TextStyle(fontSize: 14, color: subTitleColor),
            ),
            const SizedBox(height: 24),

            _buildNotificationTile(
              title: strings.emergencyAlertsTitle,
              subtitle: strings.emergencyAlertsSubtitle,
              icon: Icons.warning_amber_rounded,
              value: emergencyAlerts,
              onChanged: (value) {
                setState(() {
                  emergencyAlerts = value;
                });
                _saveNotificationSetting('emergencyAlerts', value);
              },
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 14),

            _buildNotificationTile(
              title: strings.sosConfirmationTitle,
              subtitle: strings.sosConfirmationSubtitle,
              icon: Icons.check_circle_rounded,
              value: sosConfirmation,
              onChanged: (value) {
                setState(() {
                  sosConfirmation = value;
                });
                _saveNotificationSetting('sosConfirmation', value);
              },
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 14),

            _buildNotificationTile(
              title: strings.locationSharingTitle,
              subtitle: strings.locationSharingSubtitle,
              icon: Icons.location_on_rounded,
              value: locationSharingAlerts,
              onChanged: (value) {
                setState(() {
                  locationSharingAlerts = value;
                });
                _saveNotificationSetting('locationSharingAlerts', value);
              },
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 24),

            Text(
              strings.alertPreferences,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),

            const SizedBox(height: 14),

            _buildNotificationTile(
              title: strings.soundTitle,
              subtitle: strings.soundSubtitle,
              icon: Icons.volume_up_rounded,
              value: soundEnabled,
              onChanged: (value) {
                setState(() {
                  soundEnabled = value;
                });
                _saveNotificationSetting('soundEnabled', value);
              },
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 14),

            _buildNotificationTile(
              title: strings.vibrationTitle,
              subtitle: strings.vibrationSubtitle,
              icon: Icons.vibration_rounded,
              value: vibrationEnabled,
              onChanged: (value) {
                setState(() {
                  vibrationEnabled = value;
                });
                _saveNotificationSetting('vibrationEnabled', value);
              },
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

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color cardColor,
    required Color titleColor,
    required Color subTitleColor,
    required Color primaryColor,
  }) {
    return Container(
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
          Switch(value: value, onChanged: onChanged, activeColor: primaryColor),
        ],
      ),
    );
  }
}
