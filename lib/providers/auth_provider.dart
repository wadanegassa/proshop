import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;

  Future<void> login(String email, String password) async {
    // Mock login
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    _isLoggedIn = true;
    _userEmail = email;
    _userName = 'User'; // Default name for login
    await _persistSession();
    notifyListeners();
  }

  Future<void> signup(String name, String email, String password) async {
    // Mock signup
    await Future.delayed(Duration(seconds: 1));
    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
    await _persistSession();
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data or just auth keys
    // Ideally just clear auth keys, but for now clearing all is fine or specific keys
    // await prefs.remove('isLoggedIn');
    // await prefs.remove('userName');
    // await prefs.remove('userEmail');
    notifyListeners();
  }

  Future<void> _persistSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    await prefs.setString('userName', _userName);
    await prefs.setString('userEmail', _userEmail);
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('isLoggedIn')) return;
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userName = prefs.getString('userName') ?? '';
    _userEmail = prefs.getString('userEmail') ?? '';
    notifyListeners();
  }
}
