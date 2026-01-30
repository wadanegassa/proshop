import 'admin_product_model.dart';

class AdminOrder {
  final String id;
  final DateTime createdAt;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String address;
  final List<AdminProduct> items;
  final double totalPrice;
  final String status; // 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'
  final String paymentType;

  AdminOrder({
    required this.id,
    required this.createdAt,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.address,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.paymentType,
  });
}
