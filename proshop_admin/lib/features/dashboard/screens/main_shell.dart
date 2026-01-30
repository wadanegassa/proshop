import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/admin_layout.dart';
import '../../../providers/navigation_provider.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    
    return AdminLayout(
      child: navigationProvider.buildScreen(context),
    );
  }
}
