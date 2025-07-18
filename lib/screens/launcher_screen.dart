import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:servel/screens/auth/login_screen.dart';
import 'package:servel/screens/home/home_screen.dart';
import 'package:servel/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  void initState() {
    super.initState();
    _determineStartScreen();
  }

  Future<void> _determineStartScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = const FlutterSecureStorage();

    final bool isFirstTime = prefs.getBool('first_time') ?? true;
    final String? token = await storage.read(key: 'auth_token');

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      return;
    }

    if (isFirstTime) {
      await prefs.setBool('first_time', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}