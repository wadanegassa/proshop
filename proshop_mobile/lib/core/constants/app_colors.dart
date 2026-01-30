import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF007BFF); // Electric Blue
  static const Color secondary = Color(0xFF00D2FF); // Neon Blue
  
  // Background Colors (Dark Theme Focus)
  static const Color background = Color(0xFF0B1221); // Deep Midnight Blue
  static const Color surface = Color(0xFF162033); // Card/Surface Blue
  static const Color cardBg = Color(0xFF1C273D);
  
  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  
  // Accents & Actions
  static const Color accent = Color(0xFF3B82F6);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF0B1221)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
