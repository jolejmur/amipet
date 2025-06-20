import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pet_shop_screen.dart';
import 'screens/wiki_screen.dart';
import 'screens/vet_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/adoption_screen.dart';
import 'screens/report_screen.dart';
import 'screens/vaccine_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AmiPet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF059669)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/petshop': (context) => const PetShopScreen(),
        '/wiki': (context) => const WikiScreen(),
        '/vet': (context) => const VetScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/adoption': (context) => const AdoptionScreen(),
        '/report': (context) => const ReportScreen(),
        '/vaccine': (context) => const VaccineScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
