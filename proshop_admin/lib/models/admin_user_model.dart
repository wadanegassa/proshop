class AdminUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isBlocked;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isBlocked = false,
  });
}
