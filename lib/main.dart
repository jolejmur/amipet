import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Care App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF97316)),
        useMaterial3: true,
        fontFamily: 'System', // Usar fuente del sistema para mejor legibilidad
      ),
      home: const LoginScreen(), // Cambiar a LoginScreen
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
