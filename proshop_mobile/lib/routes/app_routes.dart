import 'package:flutter/material.dart';
import '../features/home/screens/home_screen.dart';
import '../features/product/screens/product_details_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/cart/screens/cart_screen.dart';
import '../features/order/screens/order_history_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/home/screens/search_screen.dart';
import '../features/cart/screens/checkout_success_screen.dart';

import '../core/widgets/auth_wrapper.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String productDetails = '/product-details';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String checkoutSuccess = '/checkout-success';

  static Map<String, WidgetBuilder> get routes => {
    initial: (context) => const AuthWrapper(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    productDetails: (context) => const ProductDetailsScreen(),
    cart: (context) => const CartScreen(),
    orders: (context) => const OrderHistoryScreen(),
    profile: (context) => const ProfileScreen(),
    search: (context) => const SearchScreen(),
    checkoutSuccess: (context) => const CheckoutSuccessScreen(),
  };
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Coming Soon: $title')),
    );
  }
}
