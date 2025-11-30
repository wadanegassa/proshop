import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proshop/screens/auth_screen.dart';
import 'package:proshop/screens/main_screen.dart';
import 'package:proshop/screens/onboarding_screen.dart';
import 'package:proshop/screens/product_detail_screen.dart';
import 'package:proshop/screens/cart_screen.dart';
import 'package:proshop/providers/cart_provider.dart';
import 'package:proshop/providers/favorites_provider.dart';
import 'package:proshop/providers/orders_provider.dart';
import 'package:proshop/providers/theme_provider.dart';
import 'package:proshop/providers/auth_provider.dart';
import 'package:proshop/screens/settings_screen.dart';
import 'package:proshop/screens/orders_screen.dart';
import 'package:proshop/screens/checkout_screen.dart';
import 'package:proshop/screens/category_products_screen.dart';
import 'package:proshop/theme/app_theme.dart';

import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:proshop/utils/custom_scroll_behavior.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  setPathUrlStrategy();

  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || 
      defaultTargetPlatform == TargetPlatform.linux || 
      defaultTargetPlatform == TargetPlatform.macOS)) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 720),
      minimumSize: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => FavoritesProvider()),
        ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
        ChangeNotifierProvider(create: (ctx) => OrdersProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ProShop',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            scrollBehavior: CustomScrollBehavior(),
            home: Consumer<AuthProvider>(
              builder: (ctx, auth, _) => FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return auth.isLoggedIn ? MainScreen() : OnboardingScreen();
                },
              ),
            ),
            routes: {
              OnboardingScreen.routeName: (context) => OnboardingScreen(),
              AuthScreen.routeName: (context) => AuthScreen(),
              MainScreen.routeName: (context) => MainScreen(),
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              SettingsScreen.routeName: (context) => SettingsScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              CheckoutScreen.routeName: (context) => CheckoutScreen(),
              '/category-products': (context) {
                final categoryName = ModalRoute.of(context)!.settings.arguments as String;
                return CategoryProductsScreen(categoryName: categoryName);
              },
            },
          );
        },
      ),
    );
  }
}
