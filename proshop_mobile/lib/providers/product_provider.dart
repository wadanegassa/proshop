import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductModel> _products = [
    ProductModel(
      id: '1',
      name: 'PEUGEOT - LR01',
      description: 'The LR01 uses the same design as the most iconic bikes from PEUGEOT Cycles\' 130-year history and combines it with agile, dynamic performance that\'s perfectly suited to navigating today\'s cities. As well as a lugged steel frame and iconic PEUGEOT black-and-white chequer design, this city bike also features a 16-speed Shimano Claris drivetrain.',
      price: 1999.99,
      image: 'assets/images/peugeot_lr01.png',
      category: 'Road Bike',
      rating: 4.5,
      numReviews: 12,
      countInStock: 5,
    ),
    ProductModel(
      id: '2',
      name: 'PILOT - CHROMOLY 520',
      description: 'A classic steel frame bike with modern components for a smooth and reliable ride.',
      price: 3989.99,
      image: 'assets/images/pilot_chromoly.png',
      category: 'Mountain Bike',
      rating: 4.8,
      numReviews: 8,
      countInStock: 2,
    ),
    ProductModel(
      id: '3',
      name: 'SMITH - Trade',
      description: 'The Smith Trade helmet provides lightweight protection and ventilation for road cycling.',
      price: 120.00,
      image: 'assets/images/road_helmet.png',
      category: 'Helmet',
      rating: 4.2,
      numReviews: 24,
      countInStock: 10,
    ),
  ];

  String _selectedCategory = 'All';

  List<ProductModel> get products {
    if (_selectedCategory == 'All') {
      return [..._products];
    }
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  ProductModel findById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }
}
