import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:eds_beta/screens/auth/auth_wrapper.dart';
import 'package:eds_beta/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.yellow,
      ),
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: const SplashScreen(),
        nextScreen: const AuthWrapper(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
      ),
    );
  }
}
