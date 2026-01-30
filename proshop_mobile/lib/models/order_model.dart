import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final List<CartItemModel> orderItems;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.orderItems,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? '',
      orderItems: (json['orderItems'] as List? ?? [])
          .map((item) => CartItemModel(
                product: (item['product'] != null)
                    ? (item['product'] is Map<String, dynamic>)
                        ? null // Handled later if nested
                        : null
                    : null as dynamic, // Simplified for now
                quantity: item['qty'] ?? 1,
              ))
          .toList(), // Note: Full mapping will need real product data
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
