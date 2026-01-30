class ApiConstants {
  static const String baseUrl = 'http://localhost:5000/api/v1';
  
  // Auth endpoints
  static const String adminLogin = '$baseUrl/auth/admin/login';
  static const String profile = '$baseUrl/auth/me';
  
  // Products
  static const String products = '$baseUrl/products';
  
  // Categories
  static const String categories = '$baseUrl/categories';
  
  // Orders
  static const String orders = '$baseUrl/orders';
  
  // Users (for blocking/unblocking)
  static const String users = '$baseUrl/users';
  
  // Analytics
  static const String analytics = '$baseUrl/analytics';
}
