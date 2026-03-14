import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDarkMode = await _loadThemePreference();
  runApp(MoneyMateApp(isDarkMode: isDarkMode));
}

Future<bool> _loadThemePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('darkMode') ?? false;
}

class MoneyMateApp extends StatefulWidget {
  final bool isDarkMode;

  const MoneyMateApp({super.key, required this.isDarkMode});

  @override
  State<MoneyMateApp> createState() => _MoneyMateAppState();

  static _MoneyMateAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MoneyMateAppState>();
}

class _MoneyMateAppState extends State<MoneyMateApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Mate',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
