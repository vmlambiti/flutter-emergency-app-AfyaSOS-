import 'package:flutter/material.dart';
import 'main.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
          strings.about,
          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: titleColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      'assets/images/afyasos_splash.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                "AfyaSOS",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                strings.aboutTagline,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: subTitleColor,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 28),
            _buildInfoCard(
              title: strings.aboutAfyaSOSTitle,
              content: strings.aboutAfyaSOSContent,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: strings.mainPurposeTitle,
              content: strings.mainPurposeContent,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: strings.keyFeaturesTitle,
              content: strings.keyFeaturesContent,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: strings.versionTitle,
              content: strings.versionContent,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: strings.developerInfoTitle,
              content: strings.developerInfoContent,
              cardColor: cardColor,
              titleColor: titleColor,
              subTitleColor: subTitleColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
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
          Text(
            content,
            style: TextStyle(fontSize: 14, color: subTitleColor, height: 1.6),
          ),
        ],
      ),
    );
  }
}
