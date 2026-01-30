import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/admin_user_model.dart';
import '../core/constants/api_constants.dart';

class AuthProvider extends ChangeNotifier {
  AdminUser? _user;
  bool _isAuthenticated = false;
  final _storage = const FlutterSecureStorage();

  AdminUser? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.adminLogin),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final userData = responseData['data']['user'];
        
        _user = AdminUser(
          id: userData['_id'],
          name: userData['name'],
          email: userData['email'],
          role: userData['role'],
        );
        
        _isAuthenticated = true;
        await _storage.write(key: 'admin_token', value: responseData['token']);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Admin login error: $e');
      return false;
    }
  }

  Future<void> autoLogin() async {
    final token = await _storage.read(key: 'admin_token');
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse(ApiConstants.profile),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final userData = responseData['data']['user'];
          
          if (userData['role'] != 'admin') {
            await logout();
            return;
          }

          _user = AdminUser(
            id: userData['_id'],
            name: userData['name'],
            email: userData['email'],
            role: userData['role'],
          );
          _isAuthenticated = true;
          notifyListeners();
        } else {
          await logout();
        }
      } catch (e) {
        debugPrint('Admin auto login error: $e');
      }
    }
  }

  Future<void> logout() async {
    _user = null;
    _isAuthenticated = false;
    await _storage.delete(key: 'admin_token');
    notifyListeners();
  }
}
