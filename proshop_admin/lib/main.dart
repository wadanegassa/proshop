import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/admin_theme.dart';
import 'routes/admin_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/admin_product_provider.dart';
import 'providers/admin_order_provider.dart';
import 'providers/navigation_provider.dart';
import 'features/dashboard/screens/main_shell.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AdminProductProvider()),
        ChangeNotifierProvider(create: (_) => AdminOrderProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const AdminApp(),
    ),
  );
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProShop Admin',
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.darkTheme,
      initialRoute: AdminRoutes.login,
      routes: {
        ...AdminRoutes.routes,
        AdminRoutes.dashboard: (context) => const MainShell(),
      },
      onGenerateRoute: (settings) {
        // Handle routes that should be inside the shell
        if (settings.name != AdminRoutes.login && settings.name != null) {
          return MaterialPageRoute(
            builder: (context) => const MainShell(),
            settings: settings,
          );
        }
        return null; // Let MaterialApp handle login via routes map
      },
      builder: (context, child) {
        return Consumer<AuthProvider>(
          builder: (context, auth, _) {
            // Simplified auth check - in a real app you'd check auth.isAuthenticated
            return child!;
          },
        );
      },
    );
  }
}
