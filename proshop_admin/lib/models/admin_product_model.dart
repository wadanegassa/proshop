class AdminProduct {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String image;
  final String status; // 'Active', 'Out of Stock', 'Draft'

  AdminProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.image,
    required this.status,
  });
}
