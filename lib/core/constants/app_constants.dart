import 'package:flutter/material.dart';

class AppConstants {
  // Paleta de colores profesional
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color secondaryOrange = Color(0xFFEA580C);
  static const Color lightGray = Color(0xFF64748B);
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  // Gradientes
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryBlue,
      secondaryBlue,
      primaryOrange,
      secondaryOrange,
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  // Estilos de texto
  static const TextStyle titleStyle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(
        offset: Offset(2, 2),
        blurRadius: 4,
        color: Colors.black26,
      ),
    ],
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w300,
    height: 1.4,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Mensajes de la app
  static const String appName = '🐕 Ami Pet 🐱';
  static const String appDescription =
      'Tu compañero digital para\nel cuidado de mascotas';
  static const String welcomeMessage = '¡Bienvenido de vuelta!';
  static const String loginSubtitle = 'Inicia sesión para continuar';
  static const String termsText =
      'Al continuar, aceptas nuestros\nTérminos de Servicio y Política de Privacidad';

  // Duración de animaciones
  static const Duration standardAnimationDuration =
      Duration(milliseconds: 1500);
  static const Duration pawAnimationDuration = Duration(milliseconds: 2000);
}
