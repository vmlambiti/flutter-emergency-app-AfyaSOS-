import 'package:flutter/material.dart';
import 'main.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        title: Text(
          strings.privacyTitle,
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
              strings.privacyTitle,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.privacyIntro,
              style: TextStyle(fontSize: 14, color: subTitleColor),
            ),
            const SizedBox(height: 24),

            _buildPolicyCard(
              title: strings.infoCollectTitle,
              content: strings.infoCollectContent,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
            ),
            const SizedBox(height: 16),

            _buildPolicyCard(
              title: strings.infoUseTitle,
              content: strings.infoUseContent,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
            ),
            const SizedBox(height: 16),

            _buildPolicyCard(
              title: strings.locationTitle,
              content: strings.locationContent,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
            ),
            const SizedBox(height: 16),

            _buildPolicyCard(
              title: strings.dataProtectionTitle,
              content: strings.dataProtectionContent,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
            ),
            const SizedBox(height: 16),

            _buildPolicyCard(
              title: strings.sharingTitle,
              content: strings.sharingContent,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
            ),
            const SizedBox(height: 16),

            _buildPolicyCard(
              title: strings.userControlTitle,
              content: strings.userControlContent,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
            ),
            const SizedBox(height: 16),

            _buildPolicyCard(
              title: strings.policyUpdateTitle,
              content: strings.policyUpdateContent,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyCard({
    required String title,
    required String content,
    required Color cardColor,
    required Color titleColor,
    required Color subTitleColor,
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
          Text(content, style: TextStyle(fontSize: 14, color: subTitleColor)),
        ],
      ),
    );
  }
}
