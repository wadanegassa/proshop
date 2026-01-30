import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => [..._orders];

  void addOrder(List<CartItemModel> cartProducts, double total) {
    _orders.insert(
      0,
      OrderModel(
        id: DateTime.now().toString(),
        totalPrice: total,
        orderItems: cartProducts,
        status: 'pending',
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
