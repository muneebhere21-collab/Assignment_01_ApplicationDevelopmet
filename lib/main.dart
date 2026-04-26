import 'package:flutter/material.dart';
import 'controllers/auth_controller.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create ONE AuthController instance for the whole app
    final authController = AuthController();

    return MaterialApp(
      // App title (shown in recent apps on Android)
      title: 'Student Portal',

      // debugShowCheckedModeBanner: false removes the red "DEBUG"
      // banner from the top-right corner during development
      debugShowCheckedModeBanner: false,

      // Theme defines the global look of the app
      theme: ThemeData(
        // colorScheme.seed is the base color — Flutter generates
        // a full color palette from this one color
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6), // Blue
          brightness: Brightness.light,
        ),
        useMaterial3: true, // Use Material Design 3 (latest)
        // Default font for the whole app
        fontFamily: 'Roboto',

        // AppBar default styling
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      ),

      // The first screen shown when app starts
      home: LoginScreen(authController: authController),
    );
  }
}
