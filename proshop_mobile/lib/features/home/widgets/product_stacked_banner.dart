import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/product_image.dart';
import '../../../models/product_model.dart';

class ProductStackedBanner extends StatelessWidget {
  final List<ProductModel> products;
  const ProductStackedBanner({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background "receding" cards
          for (int i = 0; i < 3; i++)
            _buildBackCard(i),
          
          // Main product card in front
          _buildMainCard(products.first),
        ],
      ),
    );
  }

  Widget _buildBackCard(int index) {
    return Transform.translate(
      offset: Offset(-20.0 * (index + 1), -10.0 * (index + 1)),
      child: Transform.rotate(
        angle: -0.05 * (index + 1),
        child: Container(
          width: 300,
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.5 - (index * 0.1)),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard(ProductModel product) {
    return Container(
      width: 300,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Image
          Center(
            child: Hero(
              tag: 'banner-${product.id}',
              child: ProductImage(
                imagePath: product.image,
                height: 140,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
