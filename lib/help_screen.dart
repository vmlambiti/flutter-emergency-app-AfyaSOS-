import 'package:flutter/material.dart';
import 'main.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
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
          strings.help,
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
              strings.helpTitle,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.helpIntro,
              style: TextStyle(fontSize: 14, color: subTitleColor, height: 1.5),
            ),
            const SizedBox(height: 24),

            _buildHelpCard(
              title: strings.howToSendSosTitle,
              content: strings.howToSendSosContent,
              icon: Icons.sos_rounded,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 16),

            _buildHelpCard(
              title: strings.manageContactsTitle,
              content: strings.manageContactsContent,
              icon: Icons.contacts_rounded,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 16),

            _buildHelpCard(
              title: strings.changeThemeTitle,
              content: strings.changeThemeContent,
              icon: Icons.palette_rounded,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 16),

            _buildHelpCard(
              title: strings.controlNotificationsTitle,
              content: strings.controlNotificationsContent,
              icon: Icons.notifications_active_rounded,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 16),

            _buildHelpCard(
              title: strings.needSupportTitle,
              content: strings.needSupportContent,
              icon: Icons.support_agent_rounded,
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

  Widget _buildHelpCard({
    required String title,
    required String content,
    required IconData icon,
    required Color cardColor,
    required Color titleColor,
    required Color subTitleColor,
    required Color primaryColor,
  }) {
    return Container(
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
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: subTitleColor,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
