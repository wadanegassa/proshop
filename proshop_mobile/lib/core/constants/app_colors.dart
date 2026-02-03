import 'package:flutter/material.dart';

class AppColors {
  // Primary & Vibrant Accents (Updated to match reference)
  static const Color primary = Color(0xFF42A5F5); // Vibrant Cyan-Blue
  static const Color secondary = Color(0xFF2196F3); // Deeper Blue
  static const Color accent = Color(0xFF10B981); // Emerald Green
  
  // Dark Mode Palette (Premium Navy - Matching Reference)
  static const Color darkBackground = Color(0xFF1A1F2E); // Deep Navy Background
  static const Color darkSurface = Color(0xFF252D3F); // Navy Surface
  static const Color darkCard = Color(0xFF2D3548); // Navy Card
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // Pure White
  static const Color darkTextSecondary = Color(0xFF8E99AB); // Cool Gray
  static const Color darkTextMuted = Color(0xFF5F6B7A); // Darker Gray
  
  // Light Mode Palette (Premium Cloud)
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Colors.white;
  static const Color lightCard = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF64748B);

  // Status Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  
  // Gradients (Cool & Modern - Updated)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBgGradient = LinearGradient(
    colors: [Color(0xFF1A1F2E), Color(0xFF252D3F)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient lightBgGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Helper methods to get colors based on brightness
  static Color getBackground(bool isDark) => isDark ? darkBackground : lightBackground;
  static Color getSurface(bool isDark) => isDark ? darkSurface : lightSurface;
  static Color getCard(bool isDark) => isDark ? darkCard : lightCard;
  static Color getTextPrimary(bool isDark) => isDark ? darkTextPrimary : lightTextPrimary;
  static Color getTextSecondary(bool isDark) => isDark ? darkTextSecondary : lightTextSecondary;
  static Color getTextMuted(bool isDark) => isDark ? darkTextMuted : lightTextMuted;
}
