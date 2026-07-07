import 'package:flutter/material.dart';
import 'profile_setup_screen.dart';
import 'main.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  List<Map<String, String>> _getOnboardingData(BuildContext context) {
    final strings = MyApp.of(context)!.strings;

    return [
      {
        "image": "assets/onboarding/1.png",
        "title": strings.quickAlerts,
        "description": strings.quickAlertsDesc,
      },
      {
        "image": "assets/onboarding/2.png",
        "title": strings.shareLocation,
        "description": strings.shareLocationDesc,
      },
      {
        "image": "assets/onboarding/3.png",
        "title": strings.healthMonitoring,
        "description": strings.healthMonitoringDesc,
      },
      {
        "image": "assets/onboarding/getstarted.png",
        "title": strings.safetyFirst,
        "description": strings.safetyFirstDesc,
      },
    ];
  }

  void nextPage(List data) {
    if (currentPage < data.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToLastPage(List data) {
    _pageController.animateToPage(
      data.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = MyApp.of(context)!.strings;
    final onboardingData = _getOnboardingData(context);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color titleColor = isDark ? Colors.white : const Color(0xFF111111);
    final Color descColor = isDark
        ? const Color(0xFFB0B0B0)
        : const Color(0xFF666666);
    final Color primaryColor = const Color(0xFF5B5CEB);
    final Color inactiveDot = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFE0E0E0);
    final Color buttonTextColor = Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: currentPage != onboardingData.length - 1
                    ? TextButton(
                        onPressed: () => skipToLastPage(onboardingData),
                        child: Text(
                          strings.skip,
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFFFF6B6B)
                                : const Color(0xFFE53935),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = onboardingData[index];
                  final bool isLastPage = index == onboardingData.length - 1;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        Expanded(
                          flex: 6,
                          child: Center(
                            child: Image.asset(
                              item["image"]!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          item["title"]!,
                          style: TextStyle(
                            fontSize: isLastPage ? 36 : 30,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                            height: 1.15,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          item["description"]!,
                          style: TextStyle(
                            fontSize: 18,
                            color: descColor,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 28),

                        if (!isLastPage)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: List.generate(
                                  onboardingData.length,
                                  (dotIndex) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    margin: const EdgeInsets.only(right: 8),
                                    height: 6,
                                    width: currentPage == dotIndex ? 28 : 8,
                                    decoration: BoxDecoration(
                                      color: currentPage == dotIndex
                                          ? primaryColor
                                          : inactiveDot,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => nextPage(onboardingData),
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    color: primaryColor,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        if (isLastPage) ...[
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileSetupScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE53935),
                                foregroundColor: buttonTextColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                strings.getStarted.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  color: descColor,
                                ),
                                children: [
                                  TextSpan(text: "${strings.alreadyAccount} "),
                                  TextSpan(
                                    text: strings.signIn,
                                    style: TextStyle(
                                      color: titleColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 28),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
