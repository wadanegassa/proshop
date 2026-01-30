class CategoryModel {
  final String id;
  final String name;
  final String? icon;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.isActive = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'isActive': isActive,
    };
  }
}
