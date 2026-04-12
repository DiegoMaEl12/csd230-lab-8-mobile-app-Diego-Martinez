// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookstore Mobile',
      debugShowCheckedModeBanner: false, // Cleaner look
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark, // Dark mode like your React app
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7000ff), // Purple accent
          brightness: Brightness.dark,
          primary: const Color(0xFF00f2ff),   // Neon Cyan
          surface: const Color(0xFF0a0b10),   // Deep Dark Background
        ),
        scaffoldBackgroundColor: const Color(0xFF0a0b10),

        // Customizing the "CSS" of Cards
        cardTheme: CardThemeData(
          color: const Color(0xFF1a1a2e),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.white10, width: 1),
          ),
        ),

        // Customizing the "CSS" of Inputs (Forms)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.black26,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00f2ff), width: 2),
          ),
        ),

        // Customizing the "CSS" of Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7000ff),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainShell(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}