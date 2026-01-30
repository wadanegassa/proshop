import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/products/screens/product_list_screen.dart';
import '../features/orders/screens/order_list_screen.dart';
import '../features/products/screens/product_grid_screen.dart';
import '../features/products/screens/product_edit_screen.dart';
import '../features/products/screens/product_details_screen.dart';
import '../features/orders/screens/order_details_screen.dart';
import '../features/orders/screens/checkout_screen.dart';
import '../features/products/screens/category_list_screen.dart';
import '../features/apps/chat/screens/chat_screen.dart';
import '../features/apps/email/screens/email_screen.dart';
import '../features/products/screens/inventory_screen.dart';
import '../core/widgets/general_management_screen.dart';
import '../features/apps/calendar/screens/calendar_screen.dart';
import '../features/apps/todo/screens/todo_screen.dart';

class AdminRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String products = '/products';
  static const String productGrid = '/product-grid';
  static const String productEdit = '/product-edit';
  static const String productDetails = '/product-details';
  static const String categories = '/categories';
  static const String inventory = '/inventory';
  static const String orders = '/orders';
  static const String orderDetails = '/order-details';
  static const String checkout = '/checkout';
  static const String purchases = '/purchases';
  static const String attributes = '/attributes';
  static const String invoices = '/invoices';
  static const String users = '/users';
  static const String roles = '/roles';
  static const String permissions = '/permissions';
  static const String coupons = '/coupons';
  static const String reviews = '/reviews';
  static const String settings = '/settings';
  static const String chat = '/chat';
  static const String email = '/email';
  static const String calendar = '/calendar';
  static const String todo = '/todo';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    dashboard: (context) => const DashboardScreen(),
    products: (context) => const ProductListScreen(),
    productGrid: (context) => const ProductGridScreen(),
    productEdit: (context) => const ProductEditScreen(),
    productDetails: (context) => const ProductDetailsScreen(),
    categories: (context) => const CategoryListScreen(),
    inventory: (context) => const InventoryScreen(),
    orders: (context) => const OrderListScreen(),
    orderDetails: (context) => const OrderDetailsScreen(),
    checkout: (context) => const CheckoutScreen(),
    purchases: (context) => const GeneralManagementScreen(
      title: 'Purchases',
      columns: ['Purchase ID', 'Supplier', 'Amount', 'Date', 'Status'],
      data: [
        ['#PUR-101', 'Larkon Supplies', '\$1,200', '23 Apr 2024', 'Completed'],
        ['#PUR-102', 'Tech Distro', '\$850', '22 Apr 2024', 'Pending'],
      ],
    ),
    attributes: (context) => const GeneralManagementScreen(
      title: 'Attributes',
      columns: ['Attribute Name', 'Values', 'Used In'],
      data: [
        ['Size', 'S, M, L, XL', 'Clothing'],
        ['Color', 'Red, Blue, Black', 'All Products'],
      ],
    ),
    invoices: (context) => const GeneralManagementScreen(
      title: 'Invoices',
      columns: ['Invoice ID', 'Customer', 'Amount', 'Date', 'Status'],
      data: [
        ['#INV-9901', 'Gaston Lapierre', '\$737.00', '23 Apr 2024', 'Sent'],
        ['#INV-9902', 'Alice Freeman', '\$120.00', '22 Apr 2024', 'Paid'],
      ],
    ),
    users: (context) => const GeneralManagementScreen(
      title: 'Users',
      columns: ['User', 'Role', 'Status', 'Last Login'],
      data: [
        ['admin@proshop.com', 'Super Admin', 'Active', '10 mins ago'],
        ['staff@proshop.com', 'Editor', 'Active', 'Yesterday'],
      ],
    ),
    roles: (context) => const GeneralManagementScreen(
      title: 'Roles',
      columns: ['Role Name', 'Permissions Count', 'Users'],
      data: [
        ['Super Admin', 'Full Access', '1'],
        ['Editor', '12', '3'],
        ['Viewer', '2', '8'],
      ],
    ),
    permissions: (context) => const GeneralManagementScreen(
      title: 'Permissions',
      columns: ['Permission', 'Slug', 'Category'],
      data: [
        ['Edit Products', 'edit_products', 'Catalog'],
        ['Delete Orders', 'delete_orders', 'Sales'],
      ],
    ),
    coupons: (context) => const GeneralManagementScreen(
      title: 'Coupons',
      columns: ['Coupon Name', 'Code', 'Discount', 'Status'],
      data: [
        ['Summer Sale', 'SUMMER20', '20%', 'Active'],
        ['Welcome Bonus', 'WELCOME5', '\$5.00', 'Active'],
      ],
    ),
    reviews: (context) => const GeneralManagementScreen(
      title: 'Reviews',
      columns: ['User', 'Product', 'Rating', 'Comment', 'Status'],
      data: [
        ['John Doe', 'Black T-shirt', '5.0', 'Amazing quality!', 'Approved'],
        ['Sarah C.', 'Cargo Pants', '4.0', 'Good but a bit large.', 'Approved'],
      ],
    ),
    settings: (context) => const PlaceholderScreen(title: 'Settings'),
    chat: (context) => const ChatScreen(),
    email: (context) => const EmailScreen(),
    calendar: (context) => const CalendarScreen(),
    todo: (context) => const TodoScreen(),
  };
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
