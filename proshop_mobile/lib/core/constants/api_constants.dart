class ApiConstants {
  static const String baseUrl = 'http://10.232.87.165:5000/api/v1'; // Local IP for mobile/emulator access
  // For web use: 'http://localhost:5000/api/v1'
  // For Android Emulator use: 'http://10.0.2.2:5000/api/v1'
  
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
  static const String myOrders = '$baseUrl/orders/myorders';
  
  // Cart
  static const String cart = '$baseUrl/cart';
  
  // Analytics (Shared or admin specific)
  static const String analytics = '$baseUrl/analytics';
}
