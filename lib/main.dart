import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_1/service.dart';
import 'package:flutter_application_1/sign_in.dart';
import 'package:flutter_application_1/bottom.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('expenseBox');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = HiveService.getDarkMode();
  }

  void handleThemeChange(bool value) {
    setState(() {
      isDarkMode = value;
    });
    HiveService.setDarkMode(value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: GatePage(onThemeChanged: handleThemeChange),
    );
  }
}

class GatePage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  const GatePage({super.key, required this.onThemeChanged});
  @override
  State<GatePage> createState() => _GatePageState();
}

class _GatePageState extends State<GatePage> {
  @override
  Widget build(BuildContext context) {
    if (HiveService.getBool('isLoggedIn')) {
      return BottomNavScreen(onThemeChanged: widget.onThemeChanged);
    }
    return SignInPage(onThemeChanged: widget.onThemeChanged);
  }
}
