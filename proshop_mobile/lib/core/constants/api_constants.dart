class ApiConstants {
  // Current Base URL - can be updated at runtime or via build flags
  // Use --dart-define=API_URL=https://your-api.com to override
  static String _baseUrl = const String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://192.168.137.127:5000/api/v1', // Using stable Local IP
  );
  
  static String get baseUrl => _baseUrl;
  
  static set baseUrl(String value) {
    if (value.isNotEmpty) {
      _baseUrl = value;
    }
  }

  // Headers and Timeouts
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'bypass-tunnel-reminder': 'true',
  };

  static const Duration connectionTimeout = Duration(seconds: 30);

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
  
  // Chapa
  static String get chapaInitialize => '$baseUrl/chapa/initialize';
  static String get chapaVerify => '$baseUrl/chapa/verify';
}
