import 'package:flutter/material.dart';
import '../routes/admin_routes.dart';

class NavigationProvider with ChangeNotifier {
  String _currentRoute = AdminRoutes.dashboard;

  String get currentRoute => _currentRoute;

  void setRoute(String route) {
    if (_currentRoute != route) {
      _currentRoute = route;
      notifyListeners();
    }
  }

  Widget buildScreen(BuildContext context) {
    final builder = AdminRoutes.routes[_currentRoute];
    if (builder != null) {
      return builder(context);
    }
    return const Center(child: Text('Screen not found'));
  }
}
