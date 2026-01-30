import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/design_background.dart';
import '../../../routes/app_routes.dart';
import '../../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      body: DesignBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Header
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.surface,
                  child: const Icon(Icons.person, size: 60, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? 'Guest User',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  user?.email ?? 'Not logged in',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 40),
                // Profile Options
                _buildProfileItem(
                  icon: Icons.person_outline,
                  title: 'Account Information',
                  onTap: () {},
                ),
                _buildProfileItem(
                  icon: Icons.payment,
                  title: 'Payment Methods',
                  onTap: () {},
                ),
                _buildProfileItem(
                  icon: Icons.notifications_none,
                  title: 'Notifications',
                  onTap: () {},
                ),
                _buildProfileItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: true,
                    onChanged: (val) {},
                    activeColor: AppColors.primary,
                  ),
                  onTap: () {},
                ),
                _buildProfileItem(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  onTap: () {},
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    authProvider.logout();
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error.withValues(alpha: 0.1),
                    foregroundColor: AppColors.error,
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textMuted),
      ),
    );
  }
}
