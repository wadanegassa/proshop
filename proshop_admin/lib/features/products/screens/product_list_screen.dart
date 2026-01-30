import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../providers/admin_product_provider.dart';
import '../widgets/add_product_dialog.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<AdminProductProvider>(context);
    final products = productProvider.products;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Products List',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'View and manage your product catalog',
                  style: TextStyle(fontSize: 12, color: AdminColors.textMuted),
                ),
              ],
            ),
            Row(
              children: [
                _buildActionOutlineButton(Icons.upload_rounded, 'Export'),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(context: context, builder: (context) => const AddProductDialog());
                  },
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Product'),
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
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Table Container
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
              // Filter Row
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
                            hintText: 'Search products...',
                            hintStyle: TextStyle(color: AdminColors.textMuted),
                            prefixIcon: Icon(Icons.search_rounded, size: 16, color: AdminColors.textMuted),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildFilterPill('Category: All'),
                    const SizedBox(width: 8),
                    _buildFilterPill('Status: Active'),
                  ],
                ),
              ),
              
              // Custom Data Table
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: AdminColors.divider,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    headingRowHeight: 50,
                    dataRowMaxHeight: 70,
                    headingRowColor: WidgetStateProperty.all(Colors.transparent),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: AdminColors.divider)),
                    ),
                    columnSpacing: 24,
                    columns: const [
                      DataColumn(label: Text('PRODUCT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('CATEGORY', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('PRICE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('STOCK', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('ACTION', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                    ],
                    rows: products.map((product) {
                      return DataRow(
                        color: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.hovered)) {
                            return AdminColors.primary.withValues(alpha: 0.05);
                          }
                          return Colors.transparent;
                        }),
                        cells: [
                        DataCell(
                          Row(
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: AdminColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AdminColors.divider),
                                ),
                                child: const Icon(Icons.image_outlined, size: 24, color: AdminColors.textMuted),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                                  const SizedBox(height: 2),
                                  const Text('ID: #PRD-20241', style: TextStyle(fontSize: 11, color: AdminColors.textMuted)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(product.category, style: const TextStyle(color: AdminColors.textSecondary))),
                        DataCell(Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white))),
                        DataCell(Text(product.stock.toString(), style: const TextStyle(color: AdminColors.textSecondary))),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (product.status == 'Active' ? AdminColors.success : AdminColors.error).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              product.status,
                              style: TextStyle(
                                color: product.status == 'Active' ? AdminColors.success : AdminColors.error,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              _buildActionIconButton(Icons.visibility_outlined, AdminColors.info, onPressed: () {
                                Navigator.pushNamed(context, '/product-details');
                              }),
                              const SizedBox(width: 4),
                              _buildActionIconButton(Icons.edit_outlined, AdminColors.primary, onPressed: () {
                                Navigator.pushNamed(context, '/product-edit');
                              }),
                              const SizedBox(width: 4),
                              _buildActionIconButton(Icons.delete_outline_rounded, AdminColors.error, onPressed: () {}),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
              
              // Pagination Row
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Showing 1 to 10 of 50 entries',
                      style: TextStyle(fontSize: 12, color: AdminColors.textMuted),
                    ),
                    Row(
                      children: [
                        _buildPageButton('Prev', false),
                        const SizedBox(width: 8),
                        _buildPageButton('1', true),
                        const SizedBox(width: 4),
                        _buildPageButton('2', false),
                        const SizedBox(width: 4),
                        _buildPageButton('3', false),
                        const SizedBox(width: 8),
                        _buildPageButton('Next', false),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionOutlineButton(IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AdminColors.textPrimary,
        side: const BorderSide(color: AdminColors.divider),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildFilterPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AdminColors.textSecondary)),
          const SizedBox(width: 6),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: AdminColors.textMuted),
        ],
      ),
    );
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

  Widget _buildPageButton(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AdminColors.primary : AdminColors.background,
        borderRadius: BorderRadius.circular(6),
        border: isActive ? null : Border.all(color: AdminColors.divider),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : AdminColors.textSecondary,
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
