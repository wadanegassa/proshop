import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../providers/category_provider.dart';
import '../../../models/category_model.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CategoryProvider>().fetchCategories());
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AdminColors.surface,
        title: const Text('Add Category', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Category Name',
            hintStyle: TextStyle(color: AdminColors.textMuted),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final success = await context.read<CategoryProvider>().addCategory(
                  nameController.text,
                  null, // Icon optional for now
                );
                if (success && mounted) Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

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
              onPressed: _showAddCategoryDialog,
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
          ),
          child: Consumer<CategoryProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return Column(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: AdminColors.divider),
                    child: SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        headingRowHeight: 50,
                        dataRowMaxHeight: 65,
                        columns: const [
                          DataColumn(label: Text('CATEGORY NAME', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                          DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                          DataColumn(label: Text('ACTION', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                        ],
                        rows: provider.categories.map((cat) => _buildRow(cat)).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'Showing ${provider.categories.length} categories',
                        style: const TextStyle(fontSize: 12, color: AdminColors.textMuted),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  DataRow _buildRow(CategoryModel category) {
    return DataRow(cells: [
      DataCell(Text(category.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white))),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: category.isActive ? AdminColors.success.withAlpha(25) : AdminColors.error.withAlpha(25),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          category.isActive ? 'Active' : 'Inactive',
          style: TextStyle(
            color: category.isActive ? AdminColors.success : AdminColors.error,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      )),
      DataCell(Row(
        children: [
          _buildActionIconButton(Icons.delete_outline_rounded, AdminColors.error, onPressed: () {
            context.read<CategoryProvider>().deleteCategory(category.id);
          }),
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
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }
}
