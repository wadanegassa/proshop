import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/design_background.dart';
import '../../../providers/product_provider.dart';
import '../../../routes/app_routes.dart';
import '../widgets/product_card.dart';
import '../widgets/product_stacked_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductProvider>().fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
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
                                  color: AppColors.surface.withAlpha(200),
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

                  // Banner
                   SliverToBoxAdapter(
                     child: Padding(
                       padding: const EdgeInsets.symmetric(vertical: 20),
                       child: ProductStackedBanner(products: products),
                     ),
                   ),

                   // Categories
                   SliverToBoxAdapter(
                     child: SizedBox(
                       height: 100,
                       child: ListView.builder(
                         padding: const EdgeInsets.symmetric(horizontal: 24),
                         scrollDirection: Axis.horizontal,
                         itemCount: productProvider.categories.length,
                         itemBuilder: (context, index) {
                           final category = productProvider.categories[index];
                           final isSelected = productProvider.selectedCategory == category;
                           return GestureDetector(
                             onTap: () => productProvider.setCategory(category),
                             child: Container(
                               margin: const EdgeInsets.only(right: 16, bottom: 40),
                               padding: const EdgeInsets.symmetric(horizontal: 24),
                               decoration: BoxDecoration(
                                 color: isSelected ? AppColors.primary : AppColors.surface,
                                 borderRadius: BorderRadius.circular(15),
                                 boxShadow: isSelected
                                     ? [
                                         BoxShadow(
                                           color: AppColors.primary.withOpacity(0.3),
                                           blurRadius: 10,
                                           offset: const Offset(0, 5),
                                         )
                                       ]
                                     : [],
                               ),
                               alignment: Alignment.center,
                               child: Text(
                                 category,
                                 style: TextStyle(
                                   color: isSelected ? Colors.white : AppColors.textMuted,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                             ),
                           );
                         },
                       ),
                     ),
                   ),

                  // Products Grid
                  if (productProvider.isLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (products.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: Text('No products found', style: TextStyle(color: Colors.white))),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 0.7,
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
      },
    );
  }
}
