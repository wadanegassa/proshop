import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../core/constants/api_constants.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isAuthenticated = false;
  String? _token;
  String? _error;
  final _storage = const FlutterSecureStorage();

  UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get error => _error;

  // Auto Login
  Future<void> autoLogin() async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse(ApiConstants.profile),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          _user = UserModel.fromJson(responseData['data']['user']);
          _isAuthenticated = true;
          _token = token;
          notifyListeners();
        } else {
          await _storage.delete(key: 'token');
        }
      } catch (e) {
        debugPrint('Auto login error: $e');
      }
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _error = null;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        _user = UserModel.fromJson(responseData['data']['user']);
        _isAuthenticated = true;
        _token = responseData['token'];
        await _storage.write(key: 'token', value: responseData['token']);
        notifyListeners();
        return true;
      } else {
        _error = responseData['message'] ?? 'Login failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Connection failed. Please check your internet.';
      debugPrint('Login error: $e');
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register(String name, String email, String password) async {
    _error = null;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.register),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        _user = UserModel.fromJson(responseData['data']['user']);
        _isAuthenticated = true;
        _token = responseData['token'];
        await _storage.write(key: 'token', value: responseData['token']);
        notifyListeners();
        return true;
      } else {
        _error = responseData['message'] ?? 'Registration failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Connection failed. Please check your internet.';
      debugPrint('Register error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _isAuthenticated = false;
    _token = null;
    await _storage.delete(key: 'token');
    notifyListeners();
  }
}
