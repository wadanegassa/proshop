class OrderModel {
  final String id;
  final List<OrderItem> orderItems;
  final ShippingAddress shippingAddress;
  final String paymentMethod;
  final double itemsPrice;
  final double taxPrice;
  final double shippingPrice;
  final double totalPrice;
  final bool isPaid;
  final bool isDelivered;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.orderItems,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.itemsPrice,
    required this.taxPrice,
    required this.shippingPrice,
    required this.totalPrice,
    required this.isPaid,
    required this.isDelivered,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? '',
      orderItems: (json['orderItems'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      shippingAddress: ShippingAddress.fromJson(json['shippingAddress'] ?? {}),
      paymentMethod: json['paymentMethod'] ?? '',
      itemsPrice: (json['itemsPrice'] ?? 0.0).toDouble(),
      taxPrice: (json['taxPrice'] ?? 0.0).toDouble(),
      shippingPrice: (json['shippingPrice'] ?? 0.0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      isPaid: json['isPaid'] ?? false,
      isDelivered: json['isDelivered'] ?? false,
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
      'shippingAddress': shippingAddress.toJson(),
      'paymentMethod': paymentMethod,
      'itemsPrice': itemsPrice,
      'taxPrice': taxPrice,
      'shippingPrice': shippingPrice,
      'totalPrice': totalPrice,
      'isPaid': isPaid,
      'isDelivered': isDelivered,
      'status': status,
    };
  }
}

class OrderItem {
  final String name;
  final int qty;
  final String image;
  final double price;
  final String product;

  OrderItem({
    required this.name,
    required this.qty,
    required this.image,
    required this.price,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] ?? '',
      qty: json['qty'] ?? 0,
      image: json['image'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      product: json['product'] is Map ? (json['product']['_id'] ?? '') : (json['product'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'image': image,
      'price': price,
      'product': product,
    };
  }
}

class ShippingAddress {
  final String address;
  final String city;
  final String postalCode;
  final String country;

  ShippingAddress({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'country': country,
    };
  }
}
