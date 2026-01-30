class UserModel {
  final String id;
  final String email;
  final String name;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'name': name,
      'profileImage': profileImage,
    };
  }
}
