import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants/api_constants.dart';

class AdminUserProvider extends ChangeNotifier {
  List<dynamic> _users = [];
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();

  List<dynamic> get users => [..._users];
  bool get isLoading => _isLoading;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'admin_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.users),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _users = data['data']['users'];
      }
    } catch (e) {
      debugPrint('Error fetching users: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleBlockUser(String id, bool isBlocked) async {
    try {
      final endpoint = isBlocked ? 'unblock' : 'block';
      final response = await http.patch(
        Uri.parse('${ApiConstants.users}/$id/$endpoint'),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        await fetchUsers();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error toggling block: $e');
      return false;
    }
  }
}
