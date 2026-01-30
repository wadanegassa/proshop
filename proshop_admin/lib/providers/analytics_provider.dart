import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants/api_constants.dart';

class AnalyticsProvider with ChangeNotifier {
  Map<String, dynamic> _stats = {
    'totalSales': 0,
    'totalOrders': 0,
    'revenue': 0,
    'topProducts': [],
  };
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();

  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;

  Future<void> fetchAnalytics() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _storage.read(key: 'admin_token');
      final response = await http.get(
        Uri.parse(ApiConstants.analytics),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _stats = data['data'];
      }
    } catch (e) {
      debugPrint('Error fetching analytics: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
