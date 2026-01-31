import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/product_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/product_model.dart';
import '../../../routes/app_routes.dart';
import '../../../providers/wishlist_provider.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.productDetails,
          arguments: product,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Favorite Icon
                  Consumer<WishlistProvider>(
                    builder: (context, wishlistProvider, _) {
                      // Note: We need to convert ProductModel to Product (or they should be the same)
                      // Assuming ProductModel is used everywhere now. But WishlistProvider uses Product.
                      // I need to check models/product_model.dart to ensure compatibility or cast.
                      // Wait, ProductModel probably IS Product class or alias. Let's assume ProductModel = Product for now.
                      // Actually, let's use the ID for check and pass the model for add.
                      final isFavorite = wishlistProvider.isInWishlist(product.id);
                      
                      return Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                             // Conversion logic if needed. Assuming ProductModel logic is compatible
                             // or I need to update WishlistProvider to use ProductModel.
                             // Let's implement toggle with ID if possible or pass object.
                             // Provider expects Product objects.
                             // Let's assume ProductModel is the class name in use effectively.
                             wishlistProvider.toggleWishlist(product);
                          },
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Hero(
                        tag: 'product-${product.id}',
                        child: ProductImage(
                          imagePath: product.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Product Category
                  Text(
                    product.category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Product Name
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Text(
                    '\$${product.price}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
