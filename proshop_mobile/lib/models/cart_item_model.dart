import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  bool isSelected;
  String? selectedSize;
  String? selectedColor;
  String? selectedShoeSize;

  String get key => '${product.id}-${selectedSize ?? ''}-${selectedColor ?? ''}-${selectedShoeSize ?? ''}';

  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.isSelected = true,
    this.selectedSize,
    this.selectedColor,
    this.selectedShoeSize,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
      isSelected: json['isSelected'] ?? true,
      selectedSize: json['selectedSize'],
      selectedColor: json['selectedColor'],
      selectedShoeSize: json['selectedShoeSize'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'isSelected': isSelected,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'selectedShoeSize': selectedShoeSize,
    };
  }

  double get totalPrice {
    double finalPrice = product.price;
    if (product.discount > 0) {
      finalPrice = product.price * (1 - (product.discount / 100));
    }
    return finalPrice * quantity;
  }
}
