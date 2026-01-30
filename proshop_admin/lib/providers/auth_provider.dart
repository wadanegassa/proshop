import 'package:flutter/material.dart';
import '../models/admin_user_model.dart';

class AuthProvider extends ChangeNotifier {
  AdminUser? _user;
  bool _isAuthenticated = false;

  AdminUser? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    // Simulated login logic
    if (email == 'admin@proshop.com' && password == 'admin123') {
      _user = AdminUser(
        id: '1',
        name: 'Master Admin',
        email: email,
        role: 'Super Admin',
      );
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
