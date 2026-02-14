class ApiConstants {
  // Current Base URL - can be updated at runtime
  static String _baseUrl = 'http://10.42.0.176:5000/api/v1';
  
  static String get baseUrl => _baseUrl;
  
  static set baseUrl(String value) {
    _baseUrl = value;
  }

  // Auth endpoints
  static String get register => '$baseUrl/auth/register';
  static String get login => '$baseUrl/auth/login';
  static String get profile => '$baseUrl/auth/me';
  
  // Products
  static String get products => '$baseUrl/products';
  
  // Categories
  static String get categories => '$baseUrl/categories';
  
  // Orders
  static String get orders => '$baseUrl/orders';
  static String get myOrders => '$baseUrl/orders/myorders';
  
  // Cart
  static String get cart => '$baseUrl/cart';
  
  // Notifications
  static String get notifications => '$baseUrl/notifications';

  // Analytics (Shared or admin specific)
  static String get analytics => '$baseUrl/analytics';
  static String get paypalConfig => '$baseUrl/orders/config/paypal';
  static String get stripePaymentIntent => '$baseUrl/stripe/create-payment-intent';
  static String get stripeConfig => '$baseUrl/stripe/config';
}
