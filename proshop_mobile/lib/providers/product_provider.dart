import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../core/constants/api_constants.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  List<String> _categories = ['All'];
  bool _isLoading = false;
  String _selectedCategory = 'All';

  List<ProductModel> get products {
    if (_selectedCategory == 'All') {
      return [..._products];
    }
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  bool get isLoading => _isLoading;
  List<String> get categories => [..._categories];
  String get selectedCategory => _selectedCategory;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _fetchCategories();
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(ApiConstants.products));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> productsData = responseData['data']['products'];
        _products = productsData.map((item) => ProductModel.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.categories));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> categoriesData = responseData['data']['categories'];
        _categories = ['All', ...categoriesData.map((c) => c['name'] as String)];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  ProductModel findById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }
}
