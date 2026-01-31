import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class SettingsProvider with ChangeNotifier {
  bool _isLoading = false;
  
  double _taxRate = 0.15;
  double _shippingFee = 10.0;
  double _globalDiscount = 0.0; // Percentage
  String _supportEmail = '';
  String _supportPhone = '';

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
