import 'package:flutter/material.dart';
import '../models/admin_order_model.dart';
import '../models/admin_product_model.dart';

class AdminOrderProvider extends ChangeNotifier {
  final List<AdminOrder> _orders = [
    AdminOrder(
      id: '#RB5625',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      customerName: 'Anna M. Hines',
      customerEmail: 'anna.hines@email.com',
      customerPhone: '+1-555-1564-261',
      address: 'Burr Ridge / Illinois',
      items: [
        AdminProduct(
          id: 'P1',
          name: 'Professional Mountain Bike',
          category: 'Bicycles',
          price: 1200.0,
          stock: 15,
          image: '',
          status: 'Active',
        ),
      ],
      totalPrice: 1200.0,
      status: 'Completed',
      paymentType: 'Credit Card',
    ),
    AdminOrder(
      id: '#RB5652',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      customerName: 'Judith H. Fritsche',
      customerEmail: 'judith.fritsche@com',
      customerPhone: '+57-305-5519-759',
      address: 'SULLIVAN / Kentucky',
      items: [],
      totalPrice: 450.0,
      status: 'Completed',
      paymentType: 'Credit Card',
    ),
  ];

  List<AdminOrder> get orders => [..._orders];

  void updateOrderStatus(String id, String newStatus) {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index >= 0) {
      final updatedOrder = AdminOrder(
        id: _orders[index].id,
        createdAt: _orders[index].createdAt,
        customerName: _orders[index].customerName,
        customerEmail: _orders[index].customerEmail,
        customerPhone: _orders[index].customerPhone,
        address: _orders[index].address,
        items: _orders[index].items,
        totalPrice: _orders[index].totalPrice,
        status: newStatus,
        paymentType: _orders[index].paymentType,
      );
      _orders[index] = updatedOrder;
      notifyListeners();
    }
  }
}
