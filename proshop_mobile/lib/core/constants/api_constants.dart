class ApiConstants {
  static const String baseUrl = 'http://localhost:5000/api/v1'; // Use direct localhost for now; might need 10.0.2.2 for Android emulator
  
  // Auth endpoints
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String profile = '$baseUrl/auth/me';
  
  // Products
  static const String products = '$baseUrl/products';
  
  // Categories
  static const String categories = '$baseUrl/categories';
  
  // Orders
  static const String orders = '$baseUrl/orders';
  
  // Cart
  static const String cart = '$baseUrl/cart';
  
  // Analytics (Shared or admin specific)
  static const String analytics = '$baseUrl/analytics';
}
