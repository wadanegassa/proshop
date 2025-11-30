import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/products_data.dart';
import '../screens/product_detail_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/inputs.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';
import '../providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';

  List<dynamic> get _filteredProducts {
    if (_selectedCategory == 'All') {
      return dummyProducts;
    }
    return dummyProducts.where((product) => product.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1100;
    final isTablet = size.width >= 600 && size.width < 1100;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            hintText: 'Search products...',
                            prefixIcon: Icons.search,
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: AppTheme.radius16,
                            boxShadow: AppTheme.shadowSm,
                          ),
                          child: Icon(Icons.notifications_outlined),
                        ),
                      ],
                    ),
                  ),

                  // Hero Banner
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: isDesktop ? 300 : 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A6CF7), Color(0xFF7B96FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppTheme.radius24,
                      boxShadow: AppTheme.shadowMd,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: CircleAvatar(
                            radius: isDesktop ? 120 : 80,
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Summer Sale',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isDesktop ? 32 : 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Get up to 50% off\non selected items',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: isDesktop ? 20 : 16,
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'Shop Now',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),


                  SizedBox(height: 32),

                  // Categories
                  SizedBox(
                    height: 40,
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      children: [
                        'All',
                        'Electronics',
                        'Fashion',
                        'Home',
                        'Sports',
                        'Books'
                      ].map((category) {
                        final isSelected = _selectedCategory == category;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              margin: EdgeInsets.only(right: 12),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Best Sellers
                  SectionHeader(title: 'Best Sellers', onSeeAll: () {}),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 280,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: _filteredProducts.length,
                      separatorBuilder: (_, __) => SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return SizedBox(
                          width: 180,
                          child: ProductCard(
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
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 32),

                  // New Arrivals
                  SectionHeader(title: 'New Arrivals', onSeeAll: () {}),
                  SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 4 : (isTablet ? 3 : 2),
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: (_filteredProducts.length > 4 && !isDesktop) ? 4 : _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
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
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}