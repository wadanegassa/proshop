import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/category_model.dart';
import '../core/constants/api_constants.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();

  List<CategoryModel> get categories => [..._categories];
  bool get isLoading => _isLoading;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'admin_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(ApiConstants.categories));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List categoriesData = data['data']['categories'];
        _categories = categoriesData.map((c) => CategoryModel.fromJson(c)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCategory(String name, String? icon) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.categories),
        headers: await _getHeaders(),
        body: json.encode({'name': name, 'icon': icon}),
      );
      if (response.statusCode == 201) {
        await fetchCategories();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error adding category: $e');
      return false;
    }
  }

  Future<bool> updateCategory(CategoryModel category) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiConstants.categories}/${category.id}'),
        headers: await _getHeaders(),
        body: json.encode(category.toJson()),
      );
      if (response.statusCode == 200) {
        await fetchCategories();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating category: $e');
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.categories}/$id'),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 204) {
        _categories.removeWhere((c) => c.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting category: $e');
      return false;
    }
  }
}
