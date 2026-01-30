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

  factory AdminOrder.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map ? json['user'] : null;
    final shipping = json['shippingAddress'] ?? {};

    return AdminOrder(
      id: json['_id'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      customerName: user != null ? (user['name'] ?? 'Unknown') : 'Unknown',
      customerEmail: user != null ? (user['email'] ?? '') : '',
      customerPhone: '', // Not in backend schema currently
      address: '${shipping['address'] ?? ''}, ${shipping['city'] ?? ''}, ${shipping['country'] ?? ''}',
      items: (json['orderItems'] as List? ?? []).map((item) => AdminProduct.fromJson(item)).toList(),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentType: json['paymentMethod'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}
