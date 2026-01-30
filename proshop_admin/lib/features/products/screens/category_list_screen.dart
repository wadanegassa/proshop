import 'package:flutter/material.dart';
import '../../../core/constants/admin_colors.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage product categories',
                  style: TextStyle(fontSize: 12, color: AdminColors.textMuted),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Category'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AdminColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AdminColors.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
               Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AdminColors.background.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AdminColors.divider),
                        ),
                        child: const TextField(
                          style: TextStyle(fontSize: 13, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search categories...',
                            hintStyle: TextStyle(color: AdminColors.textMuted),
                            prefixIcon: Icon(Icons.search_rounded, size: 16, color: AdminColors.textMuted),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(dividerColor: AdminColors.divider),
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    headingRowHeight: 50,
                    dataRowMaxHeight: 65,
                    headingRowColor: WidgetStateProperty.all(AdminColors.background.withValues(alpha: 0.3)),
                    columns: const [
                      DataColumn(label: Text('CATEGORY NAME', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('PRODUCTS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('ACTION', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                    ],
                    rows: [
                      _buildRow('Fashion', '1,834', 'Active'),
                      _buildRow('Electronics', '1,200', 'Active'),
                      _buildRow('Home Decor', '850', 'Active'),
                      _buildRow('Watches', '420', 'Inactive'),
                      _buildRow('Footwear', '960', 'Active'),
                    ],
                  ),
                ),
              ),
               // Footer
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: Text('Showing 5 categories', style: TextStyle(fontSize: 12, color: AdminColors.textMuted))),
              ),
            ],
          ),
        ),
      ],
    );
  }

  DataRow _buildRow(String name, String count, String status) {
    final isActive = status == 'Active';
    return DataRow(cells: [
      DataCell(Text(name, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white))),
      DataCell(Text(count, style: const TextStyle(color: AdminColors.textSecondary))),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? AdminColors.success.withValues(alpha: 0.1) : AdminColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isActive ? AdminColors.success : AdminColors.error,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      )),
      DataCell(Row(
        children: [
          _buildActionIconButton(Icons.edit_outlined, AdminColors.primary, onPressed: () {}),
          const SizedBox(width: 8),
          _buildActionIconButton(Icons.delete_outline_rounded, AdminColors.error, onPressed: () {}),
        ],
      )),
    ]);
  }

  Widget _buildActionIconButton(IconData icon, Color color, {VoidCallback? onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }
}
