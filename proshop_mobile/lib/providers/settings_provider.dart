import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';

class SettingsProvider with ChangeNotifier {
  static const String _themePreferenceKey = 'theme_mode';
  
  bool _isLoading = false;
  ThemeMode _themeMode = ThemeMode.dark;
  double _taxRate = 0.15;
  double _shippingFee = 10.0;
  double _globalDiscount = 0.0; // Percentage
  String _supportEmail = '';
  String _supportPhone = '';

  SettingsProvider() {
    _loadThemePreference();
  }

  ThemeMode get themeMode => _themeMode;

  // Load saved theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themePreferenceKey);
      
      if (savedTheme != null) {
        switch (savedTheme) {
          case 'light':
            _themeMode = ThemeMode.light;
            break;
          case 'dark':
            _themeMode = ThemeMode.dark;
            break;
          case 'system':
            _themeMode = ThemeMode.system;
            break;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
    }
  }

  // Save theme preference to SharedPreferences
  Future<void> _saveThemePreference(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String themeString;
      
      switch (mode) {
        case ThemeMode.light:
          themeString = 'light';
          break;
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
          themeString = 'system';
          break;
      }
      
      await prefs.setString(_themePreferenceKey, themeString);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  // Set theme mode explicitly (used by UI controls)
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _saveThemePreference(mode);
  }

  // Toggle between light and dark (legacy method, kept for compatibility)
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    _saveThemePreference(_themeMode);
  }

  double get taxRate => _taxRate;
  double get shippingFee => _shippingFee;
  double get globalDiscount => _globalDiscount;
  String get supportEmail => _supportEmail;
  String get supportPhone => _supportPhone;

  bool get isLoading => _isLoading;

  Future<void> fetchSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/settings'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final settings = data['data'];
          _taxRate = (settings['taxRate'] ?? 0.15).toDouble();
          _shippingFee = (settings['shippingFee'] ?? 10.0).toDouble();
          _globalDiscount = (settings['globalDiscount'] ?? 0.0).toDouble();
          _supportEmail = settings['supportEmail'] ?? '';
          _supportPhone = settings['supportPhone'] ?? '';
        }
      }
    } catch (e) {
      debugPrint('Error fetching settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
