import 'package:flutter/material.dart';
import 'profile_details_screen.dart';
import 'emergency_contacts_screen.dart';
import 'health_info_screen.dart';
import 'first_aid_screen.dart';
import 'settings_screen.dart';
import 'main.dart';
import 'app_strings.dart';
import 'emergency_service.dart';
import 'notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _handleSosTap(BuildContext context) async {
    final shouldConfirm =
        await NotificationService.instance.isSosConfirmationEnabled;

    if (!shouldConfirm) {
      if (!context.mounted) return;
      await triggerSOS(context);
      return;
    }

    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final strings = MyApp.of(context)!.strings;

        return AlertDialog(
          title: Text(strings.sos),
          content: const Text('Send emergency SOS alert now?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(strings.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(strings.sos),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    await triggerSOS(context);
  }

  Future<void> _openSettings(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );

    if (mounted) {
      setState(() {});
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
    final Color sosRed = const Color(0xFFE53935);
    final Color ringRed1 = const Color(0xFFFFCDD2);
    final Color ringRed2 = const Color(0xFFEF9A9A);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context, titleColor, subTitleColor, strings),
              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 26,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      strings.emergencyHelp,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      strings.emergencyHelpDesc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: subTitleColor,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildSosButton(
                      context: context,
                      isDark: isDark,
                      sosRed: sosRed,
                      ringRed1: ringRed1,
                      ringRed2: ringRed2,
                      strings: strings,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      strings.pressOnlyWhenNeeded,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: subTitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.locationSharingReady,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            strings.locationSharingReadyDesc,
                            style: TextStyle(
                              fontSize: 13,
                              color: subTitleColor,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              Text(
                strings.quickActions,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 14),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.82,
                children: [
                  _buildActionCard(
                    title: strings.emergencyContacts,
                    subtitle: strings.emergencyContactsDesc,
                    icon: Icons.contacts_rounded,
                    color: const Color(0xFF5B5CEB),
                    cardColor: cardColor,
                    titleColor: titleColor,
                    subTitleColor: subTitleColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmergencyContactsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    title: strings.healthInfo,
                    subtitle: strings.healthInfoDesc,
                    icon: Icons.favorite_rounded,
                    color: const Color(0xFFE53935),
                    cardColor: cardColor,
                    titleColor: titleColor,
                    subTitleColor: subTitleColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HealthInfoScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    title: strings.firstAid,
                    subtitle: strings.firstAidDesc,
                    icon: Icons.medical_services_rounded,
                    color: const Color(0xFFFF9800),
                    cardColor: cardColor,
                    titleColor: titleColor,
                    subTitleColor: subTitleColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FirstAidScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    title: strings.settings,
                    subtitle: strings.settingsDesc,
                    icon: Icons.settings_rounded,
                    color: const Color(0xFF00A86B),
                    cardColor: cardColor,
                    titleColor: titleColor,
                    subTitleColor: subTitleColor,
                    onTap: () {
                      _openSettings(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 26),

              Container(
                width: double.infinity,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: primaryColor,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        strings.homeTip,
                        style: TextStyle(
                          fontSize: 14,
                          color: subTitleColor,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    Color titleColor,
    Color subTitleColor,
    AppStrings strings,
  ) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF5B5CEB).withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.health_and_safety_rounded,
            color: Color(0xFF5B5CEB),
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.welcomeToAfyaSOS,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                strings.staySafePrepared,
                style: TextStyle(fontSize: 14, color: subTitleColor),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileDetailsScreen()),
            );
          },
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, color: titleColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSosButton({
    required BuildContext context,
    required bool isDark,
    required Color sosRed,
    required Color ringRed1,
    required Color ringRed2,
    required AppStrings strings,
  }) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? sosRed.withOpacity(0.10)
                  : ringRed1.withOpacity(0.45),
            ),
          ),
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? sosRed.withOpacity(0.18)
                  : ringRed2.withOpacity(0.45),
            ),
          ),
          GestureDetector(
            onTap: () => _handleSosTap(context),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: sosRed,
                boxShadow: [
                  BoxShadow(
                    color: sosRed.withOpacity(0.35),
                    blurRadius: 22,
                    spreadRadius: 3,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  strings.sos,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color cardColor,
    required Color titleColor,
    required Color subTitleColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  color: subTitleColor,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
