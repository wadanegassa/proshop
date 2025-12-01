import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final String userName = 'Guest User';
    final String userEmail = 'guest@proshop.com';
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
                          userName,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 20,
                              ),
                        ),
                        Text(
                          userEmail,
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
                  onPressed: () => _logout(context),
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
