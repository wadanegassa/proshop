class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final double rating;
  final int numReviews;
  final int countInStock;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.rating,
    required this.numReviews,
    required this.countInStock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      numReviews: json['numReviews'] ?? 0,
      countInStock: json['countInStock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'rating': rating,
      'numReviews': numReviews,
      'countInStock': countInStock,
    };
  }
}
