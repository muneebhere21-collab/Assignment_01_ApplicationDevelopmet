import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controllers/auth_controller.dart';
import 'screens/login_screen.dart';

void main() async {
  // Ensure Flutter is initialized before calling async methods in main
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();

  final authController = AuthController();
  await authController.loadSession();
  
  runApp(
    ProviderScope(
      child: MyApp(authController: authController),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthController authController;
  
  const MyApp({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App title (shown in recent apps on Android)
      title: 'Student Portal',
      debugShowCheckedModeBanner: false,

      // Theme defines the global look of the app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6), // Blue
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      ),

      // The first screen shown when app starts
      home: LoginScreen(authController: authController),
    );
  }
}
