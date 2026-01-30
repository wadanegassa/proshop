import 'package:flutter/material.dart';
import '../models/admin_product_model.dart';

class AdminProductProvider extends ChangeNotifier {
  final List<AdminProduct> _products = [
    AdminProduct(
      id: 'P1',
      name: 'Professional Mountain Bike',
      category: 'Bicycles',
      price: 1200.0,
      stock: 15,
      image: 'assets/products/bike.png',
      status: 'Active',
    ),
    AdminProduct(
      id: 'P2',
      name: 'Wireless Bluetooth Headphones',
      category: 'Electronics',
      price: 250.0,
      stock: 40,
      image: 'assets/products/headphones.png',
      status: 'Active',
    ),
    AdminProduct(
      id: 'P3',
      name: 'Waterproof Camping Tent',
      category: 'Outdoors',
      price: 350.0,
      stock: 0,
      image: 'assets/products/tent.png',
      status: 'Out of Stock',
    ),
  ];

  List<AdminProduct> get products => [..._products];

  void addProduct(AdminProduct product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(AdminProduct product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _products[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
