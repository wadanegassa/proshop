import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../core/widgets/design_background.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final user = authProvider.user!;

    return Scaffold(
      body: DesignBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Premium Header
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.surface,
                          child: const Icon(Icons.person_outline, size: 40, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Statistics Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('Orders', orderProvider.orders.length.toString()),
                        _buildDivider(),
                        _buildStatItem('Reviews', '0'),
                        _buildDivider(),
                        _buildStatItem('Wishlist', '0'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Profile Sections
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildSectionHeader('General'),
                      const SizedBox(height: 16),
                      _buildProfileItem(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        subtitle: 'View your order history',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.orders),
                      ),
                      _buildProfileItem(
                        icon: Icons.favorite_border,
                        title: 'Wishlist',
                        subtitle: 'Your favorite items',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.wishlist),
                      ),
                      _buildProfileItem(
                        icon: Icons.person_outline,
                        title: 'Account Settings',
                        subtitle: 'Manage your profile and security',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                      ),
                      _buildProfileItem(
                        icon: Icons.notifications_none,
                        title: 'Notifications',
                        subtitle: 'Stay updated on your orders',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                      ),
                      
                      const SizedBox(height: 24),
                      _buildSectionHeader('Preferences'),
                      const SizedBox(height: 16),
                      _buildProfileItem(
                        icon: Icons.location_on_outlined,
                        title: 'Saved Addresses',
                        subtitle: 'Manage your delivery locations',
                        onTap: () {},
                      ),
                      _buildProfileItem(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        subtitle: 'Frequently asked questions',
                        onTap: () {},
                      ),
                      
                      const SizedBox(height: 32),
                      _buildLogoutButton(context),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: AppColors.textMuted.withOpacity(0.2),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          context.read<AuthProvider>().logout();
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.initial,
            (route) => false,
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.primary.withOpacity(0.5), width: 1.5),
          ),
        ),
        child: const Text(
          'Log out',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
