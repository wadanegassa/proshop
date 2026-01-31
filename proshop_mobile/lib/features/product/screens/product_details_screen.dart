import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/design_background.dart';
import '../../../core/widgets/product_image.dart';
import '../../../models/product_model.dart';
import '../../../providers/cart_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductModel;

    return Scaffold(
      body: DesignBackground(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 400,
                  backgroundColor: Colors.transparent,
                  leading: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: BackButtonCircle(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 80, bottom: 40),
                          child: PageView.builder(
                            itemCount: product.images.length > 0 ? product.images.length : 1,
                            itemBuilder: (context, index) {
                              final imagePath = product.images.isNotEmpty 
                                  ? product.images[index] 
                                  : product.image;
                              return Hero(
                                tag: 'product-${product.id}-$index',
                                child: ProductImage(
                                  imagePath: imagePath,
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          ),
                        ),
                        if (product.images.length > 1)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                product.images.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary, // Active indicator logic to be added if stateful tracking
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                        if (product.brand.isNotEmpty && product.brand != 'Unknown Brand' && product.brand != 'N/A')
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.brand.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        if (product.brand.isNotEmpty && product.brand != 'Unknown Brand' && product.brand != 'N/A')
                          const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: product.countInStock > 0
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                product.countInStock > 0
                                    ? 'In Stock (${product.countInStock})'
                                    : 'Out of Stock',
                                style: TextStyle(
                                  color: product.countInStock > 0
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.rating}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    ' (${product.numReviews})',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.category,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 24),

                        // Sizes
                        if (product.sizes.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text('Select Size', style: TextStyle(color: AppColors.textSecondary)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: product.sizes.map((size) => Chip(
                              label: Text(size),
                              backgroundColor: AppColors.surface,
                              labelStyle: const TextStyle(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            )).toList(),
                          ),
                        ],

                        // Colors
                        if (product.colors.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text('Select Color', style: TextStyle(color: AppColors.textSecondary)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: product.colors.map((color) => Chip(
                              label: Text(color),
                              backgroundColor: AppColors.surface,
                              labelStyle: const TextStyle(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            )).toList(),
                          ),
                        ],

                        const SizedBox(height: 24),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _selectedTabIndex = 0),
                              child: _buildTabItem('Description', _selectedTabIndex == 0),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () => setState(() => _selectedTabIndex = 1),
                              child: _buildTabItem('Specs', _selectedTabIndex == 1),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () => setState(() => _selectedTabIndex = 2),
                              child: _buildTabItem('Reviews', _selectedTabIndex == 2),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (_selectedTabIndex == 0)
                          Text(
                            product.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.6,
                                  color: AppColors.textSecondary,
                                ),
                          )
                        else if (_selectedTabIndex == 1)
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               _buildSpecRow('SKU', product.sku),
                               _buildSpecRow('Brand', product.brand),
                               _buildSpecRow('Manufacturer', product.manufacturer),
                               _buildSpecRow('Weight', product.weight),
                               _buildSpecRow('Gender', product.gender),
                               _buildSpecRow('Tax', '${product.tax}%'),
                             ],
                           )
                        else
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'No reviews yet',
                                style: TextStyle(color: AppColors.textMuted),
                              ),
                            ),
                          ),
                        const SizedBox(height: 180), // Increased bottom padding for taller bottom sheet
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.background, // Solid background
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (product.countInStock > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.textMuted.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, color: Colors.white, size: 18),
                                    onPressed: _quantity > 1
                                        ? () => setState(() => _quantity--)
                                        : null,
                                  ),
                                  Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                                    onPressed: _quantity < product.countInStock
                                        ? () => setState(() => _quantity++)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Price',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                            ),
                            Text(
                              '\$${(product.price * _quantity).toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: product.countInStock > 0
                                ? () {
                                    // Add logical check for multiple items if provider supports it
                                    // For now adding item multiple times or single item
                                    final cart = Provider.of<CartProvider>(context, listen: false);
                                    for(int i=0; i < _quantity; i++) {
                                        cart.addItem(product);
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Added $_quantity items to cart'),
                                        duration: const Duration(seconds: 1),
                                        backgroundColor: AppColors.success,
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: product.countInStock > 0 ? AppColors.primary : AppColors.surface,
                            ),
                            child: Text(
                              product.countInStock > 0 ? 'Add to Cart' : 'Out of Stock',
                              style: TextStyle(
                                color: product.countInStock > 0 ? Colors.black : AppColors.textMuted,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, bool isSelected) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textMuted,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 20,
            color: AppColors.primary,
          ),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    if (value.isEmpty || value == '0.0%' || value == 'N/A' || value == 'Unknown Brand') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackButtonCircle extends StatelessWidget {
  const BackButtonCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Icon(Icons.chevron_left, color: Colors.white),
      ),
    );
  }
}
