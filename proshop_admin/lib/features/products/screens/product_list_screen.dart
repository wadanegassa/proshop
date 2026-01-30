import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../providers/admin_product_provider.dart';
import '../widgets/add_product_dialog.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AdminProductProvider>().fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProductProvider>(
      builder: (context, productProvider, child) {
        final products = productProvider.products;

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
              child: productProvider.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Column(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(dividerColor: AdminColors.divider),
                          child: SizedBox(
                            width: double.infinity,
                            child: DataTable(
                              headingRowHeight: 50,
                              dataRowMaxHeight: 70,
                              columns: const [
                                DataColumn(label: Text('PRODUCT')),
                                DataColumn(label: Text('PRICE')),
                                DataColumn(label: Text('STOCK')),
                                DataColumn(label: Text('STATUS')),
                                DataColumn(label: Text('ACTION')),
                              ],
                              rows: products.map((product) {
                                return DataRow(cells: [
                                  DataCell(Text(product.name, style: const TextStyle(color: Colors.white))),
                                  DataCell(Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white))),
                                  DataCell(Text(product.stock.toString(), style: const TextStyle(color: Colors.white))),
                                  DataCell(Text(product.status, style: TextStyle(color: product.status == 'Active' ? AdminColors.success : AdminColors.error))),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: AdminColors.error, size: 20),
                                        onPressed: () => productProvider.deleteProduct(product.id),
                                      ),
                                    ],
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}
