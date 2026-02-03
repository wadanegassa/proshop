import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/design_background.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../routes/app_routes.dart';
import '../widgets/product_card.dart';
import '../widgets/home_banner_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProductProvider>().fetchProducts();
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<ProductProvider>().fetchProducts(),
      context.read<NotificationProvider>().fetchNotifications(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final products = productProvider.products;

        return Scaffold(
          body: DesignBackground(
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primary,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor.withOpacity(0.05),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.search, color: Theme.of(context).hintColor),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Search Products...',
                                        style: TextStyle(color: Theme.of(context).hintColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Consumer<NotificationProvider>(
                              builder: (context, notificationProvider, _) {
                                return GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          gradient: AppColors.primaryGradient,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary.withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(Icons.notifications_outlined, color: Colors.white),
                                      ),
                                      if (notificationProvider.unreadCount > 0)
                                        Positioned(
                                          right: -2,
                                          top: -2,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 16,
                                              minHeight: 16,
                                            ),
                                            child: Text(
                                              '${notificationProvider.unreadCount}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Banner
                     SliverToBoxAdapter(
                       child: Padding(
                         padding: const EdgeInsets.symmetric(vertical: 20),
                         child: HomeBannerCarousel(products: productProvider.allProducts),
                       ),
                     ),

                     // Ultra-Minimal Categories
                     SliverToBoxAdapter(
                       child: Container(
                         height: 36,
                         margin: const EdgeInsets.only(bottom: 24),
                         child: ListView.builder(
                           padding: const EdgeInsets.symmetric(horizontal: 24),
                           scrollDirection: Axis.horizontal,
                           itemCount: productProvider.categories.length,
                           itemBuilder: (context, index) {
                             final category = productProvider.categories[index];
                             final isSelected = productProvider.selectedCategory == category;
                             return GestureDetector(
                               onTap: () => productProvider.setCategory(category),
                               child: AnimatedScale(
                                 scale: isSelected ? 1.05 : 1.0,
                                 duration: const Duration(milliseconds: 200),
                                 child: AnimatedContainer(
                                   duration: const Duration(milliseconds: 300),
                                   margin: const EdgeInsets.only(right: 8),
                                   padding: const EdgeInsets.symmetric(horizontal: 16),
                                   decoration: BoxDecoration(
                                     gradient: isSelected ? AppColors.primaryGradient : null,
                                     color: isSelected ? null : Theme.of(context).cardColor.withOpacity(0.3),
                                     borderRadius: BorderRadius.circular(12),
                                     border: Border.all(
                                       color: isSelected 
                                           ? Colors.transparent 
                                           : Theme.of(context).dividerColor.withOpacity(0.03),
                                     ),
                                     boxShadow: isSelected
                                         ? [
                                             BoxShadow(
                                               color: AppColors.primary.withOpacity(0.2),
                                               blurRadius: 6,
                                               offset: const Offset(0, 3),
                                             )
                                           ]
                                         : [],
                                   ),
                                   alignment: Alignment.center,
                                   child: Text(
                                     category,
                                     style: TextStyle(
                                       color: isSelected 
                                           ? Colors.white 
                                           : Theme.of(context).hintColor.withOpacity(0.7),
                                       fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                       fontSize: 12,
                                     ),
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
                            childAspectRatio: 0.52,
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
          ),
        );
      },
    );
  }
}
