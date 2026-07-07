import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'welcome_screen.dart';
import 'app_strings.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await NotificationService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static AppController? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_MyAppScope>()?.state ??
        context.findAncestorStateOfType<_MyAppState>();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

abstract class AppController {
  ThemeMode get themeMode;
  String get languageCode;
  AppStrings get strings;

  Future<void> changeTheme(ThemeMode mode);
  Future<void> changeLanguage(String languageCode);
}

class _MyAppState extends State<MyApp> implements AppController {
  ThemeMode _themeMode = ThemeMode.system;
  String _languageCode = 'en';

  @override
  ThemeMode get themeMode => _themeMode;

  @override
  String get languageCode => _languageCode;

  @override
  AppStrings get strings => AppStrings.of(_languageCode);

  @override
  void initState() {
    super.initState();
    _loadSavedTheme();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('app_theme') ?? 'system';

    if (!mounted) return;

    setState(() {
      if (savedTheme == 'light') {
        _themeMode = ThemeMode.light;
      } else if (savedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
    });
  }

  @override
  Future<void> changeTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    String value = 'system';
    if (mode == ThemeMode.light) {
      value = 'light';
    } else if (mode == ThemeMode.dark) {
      value = 'dark';
    }

    await prefs.setString('app_theme', value);

    if (!mounted) return;

    setState(() {
      _themeMode = mode;
    });
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('app_language') ?? 'en';

    if (!mounted) return;

    setState(() {
      _languageCode = savedLanguage;
    });
  }

  @override
  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', languageCode);

    if (!mounted) return;

    setState(() {
      _languageCode = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _MyAppScope(
      state: this,
      languageCode: _languageCode,
      themeMode: _themeMode,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFF9FAFB),
          primaryColor: const Color(0xFF1E3A8A),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E3A8A),
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF9FAFB),
            elevation: 0,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0F172A),
          primaryColor: const Color(0xFF1E3A8A),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E3A8A),
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0F172A),
            elevation: 0,
          ),
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}

class _MyAppScope extends InheritedWidget {
  const _MyAppScope({
    required this.state,
    required this.languageCode,
    required this.themeMode,
    required super.child,
  });

  final AppController state;
  final String languageCode;
  final ThemeMode themeMode;

  @override
  bool updateShouldNotify(_MyAppScope oldWidget) {
    return languageCode != oldWidget.languageCode ||
        themeMode != oldWidget.themeMode;
  }
}
