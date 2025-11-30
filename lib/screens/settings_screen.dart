import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _buildSectionHeader(context, 'Appearance'),
          _buildSettingItem(
            context,
            title: 'Dark Mode',
            subtitle: 'Enable dark theme',
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
              activeTrackColor: AppTheme.primaryColor,
            ),
          ),
          SizedBox(height: 32),
          _buildSectionHeader(context, 'Notifications'),
          _buildSettingItem(
            context,
            title: 'Push Notifications',
            subtitle: 'Receive updates about your orders',
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeTrackColor: AppTheme.primaryColor,
            ),
          ),
          _buildSettingItem(
            context,
            title: 'Email Notifications',
            subtitle: 'Receive newsletters and promotions',
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeTrackColor: AppTheme.primaryColor,
            ),
          ),
          SizedBox(height: 32),
          _buildSectionHeader(context, 'About'),
          _buildSettingItem(
            context,
            title: 'Version',
            trailing: Text(
              '1.0.0',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildSettingItem(
            context,
            title: 'Terms of Service',
            trailing: Icon(Icons.chevron_right, color: AppTheme.textLight),
            onTap: () {},
          ),
          _buildSettingItem(
            context,
            title: 'Privacy Policy',
            trailing: Icon(Icons.chevron_right, color: AppTheme.textLight),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.radius16,
        boxShadow: AppTheme.shadowSm,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              )
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
