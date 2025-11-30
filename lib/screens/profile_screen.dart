import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80'),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.userName.isNotEmpty ? auth.userName : 'Guest User',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 20,
                              ),
                        ),
                        Text(
                          auth.userEmail.isNotEmpty ? auth.userEmail : 'Sign in to sync data',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              
              // Menu Items
              _buildMenuItem(context, Icons.shopping_bag_outlined, 'My Orders', onTap: () {
                Navigator.of(context).pushNamed('/orders');
              }),
              _buildMenuItem(context, Icons.location_on_outlined, 'Shipping Addresses'),
              _buildMenuItem(context, Icons.payment_outlined, 'Payment Methods'),
              _buildMenuItem(context, Icons.favorite_outline, 'Wishlist'),
              _buildMenuItem(context, Icons.settings_outlined, 'Settings', onTap: () {
                Navigator.of(context).pushNamed('/settings');
              }),
              _buildMenuItem(context, Icons.help_outline, 'Help & Support'),
              
              SizedBox(height: 32),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: () {
                    auth.logout();
                    Navigator.of(context).pushReplacementNamed('/auth');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: AppTheme.errorColor),
                      SizedBox(width: 8),
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: AppTheme.errorColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.radius16,
        boxShadow: AppTheme.shadowSm,
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.chevron_right, color: AppTheme.textLight),
        onTap: onTap ?? () {},
      ),
    );
  }
}
