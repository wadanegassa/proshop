import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../providers/admin_product_provider.dart';
import '../widgets/add_product_dialog.dart';

class ProductGridScreen extends StatelessWidget {
  const ProductGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Filter Sidebar
        const SizedBox(
          width: 280,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FilterSection(
                  title: 'Categories',
                  children: [
                    _FilterCheckbox(label: 'All Categories', isChecked: true),
                    _FilterCheckbox(label: 'Fashion Men, Women & Kid\'s'),
                    _FilterCheckbox(label: 'Eye Ware & Sunglass'),
                    _FilterCheckbox(label: 'Watches'),
                    _FilterCheckbox(label: 'Electronics Items'),
                    _FilterCheckbox(label: 'Furniture'),
                    _FilterCheckbox(label: 'Headphones'),
                  ],
                ),
                SizedBox(height: 24),
                _FilterSection(
                  title: 'Product Price',
                  children: [
                    _FilterCheckbox(label: 'All Price', isChecked: true),
                    _FilterCheckbox(label: 'Below \$200 (145)'),
                    _FilterCheckbox(label: '\$200 - \$500 (1,885)'),
                    _FilterCheckbox(label: '\$500 - \$800 (2,276)'),
                    _FilterCheckbox(label: '\$800 - \$1000 (12,676)'),
                  ],
                ),
                SizedBox(height: 24),
                _FilterSection(
                  title: 'Gender',
                  children: [
                    _FilterCheckbox(label: 'Men (1,834)'),
                    _FilterCheckbox(label: 'Women (2,030)'),
                    _FilterCheckbox(label: 'Kid\'s (1,231)'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 32),
        // Main Product Grid Area
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildGrid(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PRODUCT GRID',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text('Categories', style: TextStyle(color: AdminColors.textMuted, fontSize: 12)),
                const Icon(Icons.chevron_right, size: 14, color: AdminColors.textMuted),
                const Text('All Product', style: TextStyle(color: AdminColors.primary, fontSize: 12)),
                const SizedBox(width: 12),
                Text('Showing all 5,785 items results', style: TextStyle(color: AdminColors.textMuted.withValues(alpha: 0.1), fontSize: 12)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined, size: 18),
              label: const Text('More Setting'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.filter_list, size: 18),
              label: const Text('Filters'),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(context: context, builder: (context) => const AddProductDialog());
              },
              icon: const Icon(Icons.add),
              label: const Text('New Product'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    final products = Provider.of<AdminProductProvider>(context).products;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.7,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(product: product);
      },
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FilterSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _FilterCheckbox extends StatelessWidget {
  final String label;
  final bool isChecked;

  const _FilterCheckbox({required this.label, this.isChecked = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: Checkbox(
              value: isChecked,
              onChanged: (val) {},
              activeColor: AdminColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final dynamic product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/product-details');
                },
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AdminColors.background,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: const Center(
                        child: Icon(Icons.image_outlined, size: 48, color: AdminColors.textMuted),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite_border, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Icon(Icons.star_half, size: 14, color: Colors.amber),
                    SizedBox(width: 4),
                    Text('4.5 (131 Review)', style: TextStyle(color: AdminColors.textMuted, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('\$${product.price}', style: const TextStyle(color: AdminColors.textMuted, decoration: TextDecoration.lineThrough, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text('\$${(product.price * 0.8).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AdminColors.primary)),
                    const SizedBox(width: 8),
                    Text('(20% Off)', style: TextStyle(color: AdminColors.success.withValues(alpha: 0.8), fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                       Navigator.pushNamed(context, '/product-details');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColors.background,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      side: const BorderSide(color: AdminColors.divider),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 16),
                        SizedBox(width: 8),
                        Text('Add to Cart', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
