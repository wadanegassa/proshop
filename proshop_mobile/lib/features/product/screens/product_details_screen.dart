import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/design_background.dart';
import '../../../core/widgets/product_image.dart';
import '../../../models/product_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/product_provider.dart';
import '../../../routes/app_routes.dart';
import 'package:intl/intl.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  int _selectedTabIndex = 1;
  String? _selectedSize;
  String? _selectedColor;
  String? _selectedShoeSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
        final arguments = ModalRoute.of(context)?.settings.arguments;
        if (arguments is ProductModel) {
            final product = arguments;
            if (product.sizes.isNotEmpty) {
                setState(() => _selectedSize = product.sizes[0]);
            }
            if (product.colors.isNotEmpty) {
                setState(() => _selectedColor = product.colors[0]);
            }
            if (product.shoeSizes.isNotEmpty) {
                setState(() => _selectedShoeSize = product.shoeSizes[0]);
            }
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments == null || arguments is! ProductModel) {
        return const Scaffold(body: Center(child: Text('Product not found')));
    }
    final initialProduct = arguments;

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        // Find the latest product data from provider to show new reviews immediately
        final product = productProvider.allProducts.firstWhere(
            (p) => p.id == initialProduct.id,
            orElse: () => initialProduct);

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
                          child: RepaintBoundary(
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
                                    cacheWidth: 800,
                                    cacheHeight: 800,
                                  ),
                                );
                              },
                            ),
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
                                    color: AppColors.primary,
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
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      border: Border.all(
                        color: Theme.of(context).dividerColor.withOpacity(0.05),
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
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      color: Colors.amber, size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${product.rating}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                  Text(
                                    ' (${product.numReviews})',
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
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
                                color: Theme.of(context).hintColor,
                              ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Price Display with Discount
                        if (product.discount > 0) 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                    children: [
                                        Text(
                                            'Price: ',
                                            style: TextStyle(color: Theme.of(context).hintColor),
                                        ),
                                        Text(
                                            '\$${product.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                                decoration: TextDecoration.lineThrough,
                                                color: Theme.of(context).hintColor,
                                            ),
                                        ),
                                    ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                    children: [
                                        Text(
                                            '\$${(product.price * (1 - product.discount / 100)).toStringAsFixed(2)}',
                                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                            ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                                '(${product.discount.toStringAsFixed(0)}% off)',
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ],
                          )
                        else
                           Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),

                        const SizedBox(height: 24),

                        // Section Tabs
                        Row(
                            children: [
                                GestureDetector(
                                    onTap: () => setState(() => _selectedTabIndex = 0),
                                    child: _buildTabItem('Description', _selectedTabIndex == 0),
                                ),
                                const SizedBox(width: 24),
                                GestureDetector(
                                    onTap: () => setState(() => _selectedTabIndex = 1),
                                    child: _buildTabItem('Specifications', _selectedTabIndex == 1),
                                ),
                                const SizedBox(width: 24),
                                GestureDetector(
                                    onTap: () => setState(() => _selectedTabIndex = 2),
                                    child: _buildTabItem('Reviews', _selectedTabIndex == 2),
                                ),
                            ],
                        ),
                        const SizedBox(height: 16),
                        if (_selectedTabIndex == 0) ...[
                            Text(
                                product.description,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).hintColor,
                                    height: 1.5,
                                ),
                            ),
                            if (product.highlights.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                const Text(
                                    'Highlights',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                    ),
                                ),
                                const SizedBox(height: 8),
                                ...product.highlights.map((h) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                        children: [
                                            const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 16),
                                            const SizedBox(width: 8),
                                            Expanded(child: Text(h, style: TextStyle(color: Theme.of(context).hintColor))),
                                        ],
                                    ),
                                )),
                            ],
                        ] else if (_selectedTabIndex == 1) ...[
                            _buildSpecRow('Brand', product.brand),
                            _buildSpecRow('Manufacturer', product.manufacturer),
                            _buildSpecRow('SKU', product.sku),
                            _buildSpecRow('Weight', product.weight),
                            _buildSpecRow('Gender', product.gender),
                            ...product.specifications.map((spec) => 
                                _buildSpecRow(spec['label'] ?? '', spec['value'] ?? '')
                            ),
                        ] else ...[
                            _buildReviewsSection(product),
                        ],

                        const SizedBox(height: 24),
                        
                        // Size Selection
                        if (product.sizes.isNotEmpty) ...[
                            const Text(
                                'Select Size',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                                spacing: 12,
                                children: product.sizes.map((size) {
                                    final isSelected = _selectedSize == size;
                                    return ChoiceChip(
                                        label: Text(size),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                            if (selected) setState(() => _selectedSize = size);
                                        },
                                        selectedColor: AppColors.primary,
                                        backgroundColor: Theme.of(context).cardColor,
                                        labelStyle: TextStyle(
                                            color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            side: BorderSide(
                                                color: isSelected ? AppColors.primary : Theme.of(context).dividerColor.withOpacity(0.1),
                                            ),
                                        ),
                                        showCheckmark: false,
                                    );
                                }).toList(),
                            ),
                            const SizedBox(height: 24),
                        ],

                        // Color Selection
                        if (product.colors.isNotEmpty) ...[
                            const Text(
                                'Select Color',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                                spacing: 12,
                                children: product.colors.map((color) {
                                    final isSelected = _selectedColor == color;
                                    return GestureDetector(
                                        onTap: () => setState(() => _selectedColor = color),
                                        child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 300),
                                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: isSelected ? AppColors.primary.withOpacity(0.1) : Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: isSelected ? AppColors.primary : Theme.of(context).dividerColor.withOpacity(0.1),
                                                    width: isSelected ? 2 : 1,
                                                ),
                                            ),
                                            child: Text(
                                                color,
                                                style: TextStyle(
                                                    color: isSelected ? AppColors.primary : Theme.of(context).textTheme.bodyMedium?.color,
                                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                                ),
                                            ),
                                        ),
                                    );
                                }).toList(),
                            ),
                            const SizedBox(height: 24),
                        ],

                        // Shoe Size Selection
                        if (product.shoeSizes.isNotEmpty) ...[
                            const Text(
                                'Select Shoe Size',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                                spacing: 12,
                                children: product.shoeSizes.map((size) {
                                    final isSelected = _selectedShoeSize == size;
                                    return ChoiceChip(
                                        label: Text(size),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                            if (selected) setState(() => _selectedShoeSize = size);
                                        },
                                        selectedColor: AppColors.primary,
                                        backgroundColor: Theme.of(context).cardColor,
                                        labelStyle: TextStyle(
                                            color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            side: BorderSide(
                                                color: isSelected ? AppColors.primary : Theme.of(context).dividerColor.withOpacity(0.1),
                                            ),
                                        ),
                                        showCheckmark: false,
                                    );
                                }).toList(),
                            ),
                            const SizedBox(height: 24),
                        ],
                        
                        // Quantity Selection
                        const Text(
                            'Quantity',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                            ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
                            ),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                    IconButton(
                                        onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                                        icon: Icon(Icons.remove_rounded, color: Theme.of(context).iconTheme.color),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                          '$_quantity',
                                          style: TextStyle(
                                              color: Theme.of(context).textTheme.titleLarge?.color,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                          ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: _quantity < product.countInStock ? () => setState(() => _quantity++) : null,
                                        icon: Icon(Icons.add_rounded, color: Theme.of(context).iconTheme.color),
                                    ),
                                ],
                            ),
                        ),
                        const SizedBox(height: 32),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Price',
                              style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
                            ),
                            Text(
                              '\$${(product.discountedPrice * _quantity).toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            onPressed: product.countInStock > 0
                                ? () {
                                    final cart = Provider.of<CartProvider>(context, listen: false);
                                    for (int i = 0; i < _quantity; i++) {
                                      cart.addItem(
                                        product,
                                        size: _selectedSize,
                                        color: _selectedColor,
                                        shoeSize: _selectedShoeSize,
                                      );
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Added $_quantity items to cart'),
                                        duration: const Duration(seconds: 1),
                                        backgroundColor: AppColors.success,
                                        action: SnackBarAction(
                                          label: 'VIEW CART',
                                          textColor: Colors.white,
                                          onPressed: () => Navigator.pushNamed(context, '/cart'),
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: product.countInStock > 0 ? AppColors.primary : Theme.of(context).cardColor,
                            ),
                            child: Text(
                              product.countInStock > 0 ? 'Add to Cart' : 'Out of Stock',
                              style: TextStyle(
                                color: product.countInStock > 0 ? Colors.black : Theme.of(context).hintColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (product.countInStock > 0) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                final cart = Provider.of<CartProvider>(context, listen: false);
                                for (int i = 0; i < _quantity; i++) {
                                  cart.addItem(
                                    product,
                                    size: _selectedSize,
                                    color: _selectedColor,
                                    shoeSize: _selectedShoeSize, // Added shoeSize
                                  );
                                }
                                // Select only this variant for Buy Now
                                final String key = '${product.id}-${_selectedSize ?? ''}-${_selectedColor ?? ''}-${_selectedShoeSize ?? ''}'; // Added _selectedShoeSize to key
                                cart.selectOnly(key);
                                Navigator.pushNamed(context, AppRoutes.checkout);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Buy Now',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  },
);
  }

  Widget _buildTabItem(String label, bool isSelected) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : Theme.of(context).hintColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 16,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 6),
            height: 3,
            width: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    if (value.isEmpty || value == '0.0%' || value == 'N/A' || value == 'Unknown Brand') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(ProductModel product) {
    final authProvider = context.watch<AuthProvider>();
    final isLoggedIn = authProvider.isAuthenticated;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${product.reviews.length} Reviews',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (isLoggedIn)
              TextButton.icon(
                onPressed: () => _showReviewDialog(product),
                icon: const Icon(Icons.rate_review_outlined, size: 18),
                label: const Text('Write a Review'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (product.reviews.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'No reviews yet. Be the first to review!',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: product.reviews.length,
            itemBuilder: (context, index) {
              final review = product.reviews[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMd().format(review.createdAt),
                          style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: i < review.rating ? Colors.amber : Colors.grey.withOpacity(0.3),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.comment,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  void _showReviewDialog(ProductModel product) {
    int currentRating = 5;
    final commentController = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Write a Review', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () => setDialogState(() => currentRating = index + 1),
                        icon: Icon(
                          Icons.star_rounded,
                          size: 32,
                          color: index < currentRating ? Colors.amber : Colors.grey.withOpacity(0.3),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts about this product...',
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                  ),
                ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      if (commentController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a comment')),
                        );
                        return;
                      }

                      setDialogState(() => isSubmitting = true);
                      
                      final authProvider = context.read<AuthProvider>();
                      final productProvider = context.read<ProductProvider>();
                      
                      final result = await productProvider.addReview(
                        product.id,
                        currentRating,
                        commentController.text,
                        authProvider.token!,
                      );

                      if (result['success']) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Review submitted successfully!')),
                        );
                        productProvider.fetchProducts();
                      } else {
                        setDialogState(() => isSubmitting = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result['message'])),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: isSubmitting 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                : const Text('Submit', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class BackButtonCircle extends StatelessWidget {
  const BackButtonCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(Icons.chevron_left_rounded, color: Theme.of(context).iconTheme.color, size: 28),
      ),
    );
  }
}
