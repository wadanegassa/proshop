class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final List<String> images;
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
    required this.images,
    required this.category,
    required this.rating,
    required this.numReviews,
    required this.countInStock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle category being either an ID or a populated object
    String categoryName = '';
    if (json['category'] is Map) {
      categoryName = json['category']['name'] ?? '';
    } else {
      categoryName = json['category'] ?? '';
    }

    final imagesList = List<String>.from(json['images'] ?? []);
    final primaryImage = imagesList.isNotEmpty ? imagesList[0] : '';

    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      image: primaryImage,
      images: imagesList,
      category: categoryName,
      rating: (json['rating'] ?? 0.0).toDouble(),
      numReviews: json['reviewCount'] ?? 0,
      countInStock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'category': category,
      'rating': rating,
      'reviewCount': numReviews,
      'stock': countInStock,
    };
  }
}
