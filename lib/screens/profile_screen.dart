import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _editProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit Profile - Coming Soon!'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String userName = 'Guest User';
    final String userEmail = 'guest@proshop.com';
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);
    final avatarRadius = ResponsiveUtils.getProfileAvatarRadius(context);
    final isSmallPhone = ResponsiveUtils.isSmallPhone(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Gradient Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(horizontalPadding),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(isSmallPhone ? 24 : 28),
                    bottomRight: Radius.circular(isSmallPhone ? 24 : 28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: isSmallPhone ? 16 : 20),
                    // Profile Avatar with Icon
                    Container(
                      padding: EdgeInsets.all(isSmallPhone ? 16 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        size: avatarRadius * 1.2,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: isSmallPhone ? 12 : 16),
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallPhone ? 20 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: isSmallPhone ? 13 : 14,
                      ),
                    ),
                    SizedBox(height: isSmallPhone ? 12 : 16),
                    ElevatedButton.icon(
                      onPressed: () => _editProfile(context),
                      icon: Icon(Icons.edit, size: isSmallPhone ? 16 : 18),
                      label: Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallPhone ? 20 : 24,
                          vertical: isSmallPhone ? 10 : 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallPhone ? 16 : 20),
                  ],
                ),
              ),
              
              SizedBox(height: isSmallPhone ? 20 : 24),
              
              // Menu Items
              _buildMenuItem(
                context,
                Icons.shopping_bag_outlined,
                'My Orders',
                onTap: () {
                  Navigator.of(context).pushNamed('/orders');
                },
              ),
              _buildMenuItem(
                context,
                Icons.location_on_outlined,
                'Shipping Addresses',
                onTap: () => _showComingSoon(context, 'Shipping Addresses'),
              ),
              _buildMenuItem(
                context,
                Icons.payment_outlined,
                'Payment Methods',
                onTap: () => _showComingSoon(context, 'Payment Methods'),
              ),
              _buildMenuItem(
                context,
                Icons.favorite_outline,
                'Wishlist',
                onTap: () {
                  Navigator.of(context).pushNamed('/favorites');
                },
              ),
              _buildMenuItem(
                context,
                Icons.settings_outlined,
                'Settings',
                onTap: () {
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              _buildMenuItem(
                context,
                Icons.help_outline,
                'Help & Support',
                onTap: () => _showComingSoon(context, 'Help & Support'),
              ),
              
              SizedBox(height: isSmallPhone ? 24 : 32),
              
              // Logout Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.errorColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: TextButton.icon(
                    onPressed: () => _logout(context),
                    icon: Icon(Icons.logout, color: AppTheme.errorColor),
                    label: Text(
                      'Log Out',
                      style: TextStyle(
                        color: AppTheme.errorColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallPhone ? 14 : 16,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: isSmallPhone ? 12 : 14),
                    ),
                  ),
                ),
              ),
              SizedBox(height: isSmallPhone ? 20 : 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);
    final isSmallPhone = ResponsiveUtils.isSmallPhone(context);
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isSmallPhone ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallPhone ? 12 : 16,
              vertical: isSmallPhone ? 12 : 14,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallPhone ? 8 : 10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryColor,
                    size: isSmallPhone ? 20 : 22,
                  ),
                ),
                SizedBox(width: isSmallPhone ? 12 : 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallPhone ? 14 : 15,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                  size: isSmallPhone ? 20 : 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
