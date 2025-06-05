import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:servel/screens/feed/home_screen.dart';
import 'package:servel/screens/auth/login_screen.dart';
import 'package:servel/screens/match/match_over_screen.dart';
import 'package:servel/screens/match/match_results_screen.dart';
import 'package:servel/screens/onboarding_screen.dart';
import 'package:servel/screens/auth/register_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Tamaño de diseño base
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          debugShowCheckedModeBanner: false,
          title: "Servel",
          home: const OnboardingScreen(),
          supportedLocales: const [
            Locale('es', 'ES'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routes: {
            '/matchLaunch': (context) => const MatchResultScreen(tipoEleccionId: 1),
            '/matchOver': (context) => const MatchOverScreen(),            
            '/home': (context) => const HomeScreen(),            
            '/register': (context) => const RegisterScreen(),            
            '/login': (context) => const LoginScreen(),            
          },
        );
      },
    );
  }
}
