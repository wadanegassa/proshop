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
  final String brand;
  // New fields
  final String sku;
  final String manufacturer;
  final String weight;
  final double discount;
  final double tax;
  final String gender;
  final List<String> sizes;
  final List<String> colors;
  final List<String> shoeSizes;
  final List<String> highlights;
  final List<Map<String, String>> specifications;
  final List<Review> reviews;

  double get discountedPrice => discount > 0 ? price * (1 - discount / 100) : price;

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
    required this.brand,
    this.sku = '',
    this.manufacturer = '',
    this.weight = '',
    this.discount = 0.0,
    this.tax = 0.0,
    this.gender = 'N/A',
    this.sizes = const [],
    this.colors = const [],
    this.shoeSizes = const [],
    this.highlights = const [],
    this.specifications = const [],
    this.reviews = const [],
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
      countInStock: json['countInStock'] ?? 0,
      brand: json['brand'] ?? 'Unknown Brand',
      sku: json['sku'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      weight: json['weight'] ?? '',
      discount: (json['discount'] ?? 0.0).toDouble(),
      tax: (json['tax'] ?? 0.0).toDouble(),
      gender: json['gender'] ?? 'N/A',
      sizes: List<String>.from(json['sizes'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      shoeSizes: List<String>.from(json['shoeSizes'] ?? []),
      highlights: List<String>.from(json['highlights'] ?? []),
      specifications: (json['specifications'] as List? ?? [])
          .map((spec) => {
                'label': (spec['label'] ?? '').toString(),
                'value': (spec['value'] ?? '').toString(),
              })
          .toList(),
      reviews: (json['reviews'] as List? ?? [])
          .map((rev) => Review.fromJson(rev))
          .toList(),
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
      'countInStock': countInStock,
      'brand': brand,
      'sku': sku,
      'manufacturer': manufacturer,
      'weight': weight,
      'discount': discount,
      'tax': tax,
      'gender': gender,
      'sizes': sizes,
      'colors': colors,
      'shoeSizes': shoeSizes,
      'highlights': highlights,
      'specifications': specifications,
      'reviews': reviews.map((r) => r.toJson()).toList(),
    };
  }
}

class Review {
  final String id;
  final String user;
  final String name;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.user,
    required this.name,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? '',
      user: json['user'] is Map ? json['user']['_id'] : (json['user'] ?? ''),
      name: json['name'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'name': name,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
