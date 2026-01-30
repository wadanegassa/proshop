class AdminProduct {
  final String id;
  final String name;
  final String description;
  final String category;
  final String categoryId;
  final double price;
  final int stock;
  final List<String> images;
  final String status; // 'Active', 'Out of Stock'

  AdminProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.categoryId,
    required this.price,
    required this.stock,
    required this.images,
    required this.status,
  });

  factory AdminProduct.fromJson(Map<String, dynamic> json) {
    String categoryName = '';
    String categoryId = '';
    if (json['category'] is Map) {
      categoryName = json['category']['name'] ?? '';
      categoryId = json['category']['_id'] ?? '';
    } else {
      categoryId = json['category'] ?? '';
    }

    return AdminProduct(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: categoryName,
      categoryId: categoryId,
      price: (json['price'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      status: (json['isActive'] ?? true) ? 'Active' : 'Inactive',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': categoryId,
      'price': price,
      'stock': stock,
      'images': images,
      'isActive': status == 'Active',
    };
  }
}
