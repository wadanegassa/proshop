import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/products_data.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../screens/product_detail_screen.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';
import '../theme/app_theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteProducts = dummyProducts
        .where((product) => favoritesProvider.isFavorite(product.id))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            SectionHeader(title: 'Favorites'),
            SizedBox(height: 16),
            Expanded(
              child: favoriteProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: AppTheme.textLight,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No favorites yet',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add products to your favorites',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: favoriteProducts.length,
                      itemBuilder: (context, index) {
                        final product = favoriteProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              ProductDetailScreen.routeName,
                              arguments: product,
                            );
                          },
                          onAddToCart: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .addItem(product);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
