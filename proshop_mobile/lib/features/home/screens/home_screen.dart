import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/design_background.dart';
import '../../../providers/product_provider.dart';
import '../../../routes/app_routes.dart';
import '../widgets/product_card.dart';
import '../widgets/product_stacked_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;

    return Scaffold(
      body: DesignBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Search Bar Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.search),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surface.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.search, color: AppColors.textMuted),
                                SizedBox(width: 12),
                                Text(
                                  'Search Products...',
                                  style: TextStyle(color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.tune, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              // Stacked Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ProductStackedBanner(products: products),
                ),
              ),

              // Categories Section
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: CategoriesSection(),
                ),
              ),

              // Products Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ProductCard(product: products[index]);
                    },
                    childCount: products.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Road Bike', 'Mountain Bike', 'Helmet'];
    final productProvider = Provider.of<ProductProvider>(context);

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = productProvider.selectedCategory == category;
          
          return GestureDetector(
            onTap: () => productProvider.setCategory(category),
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: category == 'All' 
                  ? const Text('All', style: TextStyle(fontWeight: FontWeight.bold))
                  : Icon(
                      _getCategoryIcon(category),
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Road Bike': return Icons.directions_bike;
      case 'Mountain Bike': return Icons.terrain;
      case 'Helmet': return Icons.health_and_safety;
      default: return Icons.grid_view;
    }
  }
}
