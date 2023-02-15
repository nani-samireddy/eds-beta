import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:eds_beta/screens/splash/splash-screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.yellow,
      ),
      home: AnimatedSplashScreen(
        splash: const SplashScreen(),
        nextScreen: const MyWidget(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
      ),
    );
  }
}
