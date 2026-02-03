import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/notification_model.dart';
import '../core/constants/api_constants.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();

  List<NotificationModel> get notifications => [..._notifications];
  bool get isLoading => _isLoading;

  int get unreadCount => _notifications.where((n) => !n.read).length;

  Future<void> fetchNotifications() async {
    // Only show loading indicator if we don't have data yet
    if (_notifications.isEmpty) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final url = ApiConstants.notifications;
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data']['notifications'];
        _notifications = data.map((item) => NotificationModel.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final token = await _storage.read(key: 'token');
      await http.patch(
        Uri.parse('${ApiConstants.notifications}/$id/read'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index].read = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final token = await _storage.read(key: 'token');
      await http.patch(
        Uri.parse('${ApiConstants.notifications}/read-all'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      for (var n in _notifications) {
        n.read = true;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error marking all read: $e');
    }
  }

  Future<void> deleteNotification(String id) async {
    // Optimistic update
    final existingIndex = _notifications.indexWhere((n) => n.id == id);
    if (existingIndex == -1) return;
    
    final existingNotification = _notifications[existingIndex];
    _notifications.removeAt(existingIndex);
    notifyListeners();

    try {
      final token = await _storage.read(key: 'token');
      await http.delete(
        Uri.parse('${ApiConstants.notifications}/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );
    } catch (e) {
       _notifications.insert(existingIndex, existingNotification);
       notifyListeners();
       debugPrint('Error deleting notification: $e');
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      final token = await _storage.read(key: 'token');
      await http.delete(
        Uri.parse('${ApiConstants.notifications}/clear'),
        headers: {'Authorization': 'Bearer $token'},
      );
      _notifications.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing notifications: $e');
    }
  }
}
