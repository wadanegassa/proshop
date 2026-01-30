import 'package:flutter/material.dart';
import '../constants/admin_colors.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(75);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AdminColors.background,
        border: Border(bottom: BorderSide(color: AdminColors.divider, width: 0.5)),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 75,
        titleSpacing: 0,
        leadingWidth: 64,
        leading: Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AdminColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.menu_rounded, color: AdminColors.textPrimary, size: 20),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: Text(
            'WELCOME!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
           Container(
            width: 200,
            height: 38,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: AdminColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AdminColors.divider),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: AdminColors.textMuted, fontSize: 12),
                prefixIcon: Icon(Icons.search_rounded, size: 16, color: AdminColors.textMuted),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          _buildActionButton(Icons.apps_rounded),
          _buildActionButton(Icons.dark_mode_rounded),
          _buildActionButton(Icons.fullscreen_rounded),
          Stack(
            alignment: Alignment.center,
            children: [
              _buildActionButton(Icons.notifications_none_rounded),
              Positioned(
                top: 18,
                right: 14,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AdminColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: AdminColors.background, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const VerticalDivider(width: 1, indent: 22, endIndent: 22, color: AdminColors.divider),
          const SizedBox(width: 16),
          
          // Profile Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AdminColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AdminColors.divider, width: 0.5),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin'),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Master Admin',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Super Admin',
                      style: TextStyle(color: AdminColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Icon(Icons.keyboard_arrow_down_rounded, color: AdminColors.textMuted, size: 16),
              ],
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        icon: Icon(icon, color: AdminColors.textSecondary, size: 22),
        onPressed: () {},
        splashRadius: 24,
      ),
    );
  }
}
