import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/products_data.dart';
import '../screens/product_detail_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/inputs.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';
import '../providers/cart_provider.dart';
import '../utils/responsive_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> get _filteredProducts {
    var products = _selectedCategory == 'All'
        ? dummyProducts
        : dummyProducts.where((p) => p.category == _selectedCategory).toList();
    
    if (_searchQuery.isNotEmpty) {
      products = products.where((p) =>
        p.title.toLowerCase().contains(_searchQuery) ||
        p.category.toLowerCase().contains(_searchQuery)
      ).toList();
    }
    
    return products;
  }

  @override
  Widget build(BuildContext context) {
    final isSmallPhone = ResponsiveUtils.isSmallPhone(context);
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);
    final productCardWidth = ResponsiveUtils.getProductCardWidth(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with Greeting & Profile
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello! 👋',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: isSmallPhone ? 13 : 14,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Welcome back',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: isSmallPhone ? 20 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(isSmallPhone ? 8 : 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: AppTheme.shadowSm,
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            size: isSmallPhone ? 20 : 22,
                          ),
                        ),
                        SizedBox(width: 12),
                        CircleAvatar(
                          radius: isSmallPhone ? 20 : 22,
                          backgroundColor: AppTheme.primaryColor,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: isSmallPhone ? 20 : 22,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16,
                ),
                child: CustomTextField(
                  controller: _searchController,
                  hintText: 'Search products...',
                  prefixIcon: Icons.search,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
            ),

            // Hero Banner
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                height: isSmallPhone ? 160 : 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A6CF7), Color(0xFF7B96FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.shadowMd,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Container(
                          width: isSmallPhone ? 100 : 120,
                          height: isSmallPhone ? 100 : 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -20,
                        bottom: -20,
                        child: Container(
                          width: isSmallPhone ? 60 : 80,
                          height: isSmallPhone ? 60 : 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: EdgeInsets.all(isSmallPhone ? 16 : 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'SPECIAL OFFER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallPhone ? 9 : 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            SizedBox(height: isSmallPhone ? 6 : 10),
                            Text(
                              'Summer Sale',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallPhone ? 20 : 24,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Up to 50% off',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.95),
                                fontSize: isSmallPhone ? 13 : 15,
                              ),
                            ),
                            SizedBox(height: isSmallPhone ? 10 : 14),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallPhone ? 14 : 18,
                                  vertical: isSmallPhone ? 7 : 9,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Shop Now',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isSmallPhone ? 12 : 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Categories
            SliverToBoxAdapter(
              child: SizedBox(
                height: isSmallPhone ? 44 : 48,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryChip('All', Icons.grid_view),
                    _buildCategoryChip('Electronics', Icons.devices),
                    _buildCategoryChip('Fashion', Icons.checkroom),
                    _buildCategoryChip('Home', Icons.home),
                    _buildCategoryChip('Sports', Icons.sports_basketball),
                    _buildCategoryChip('Books', Icons.menu_book),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 28)),

            // Best Sellers Section
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Best Sellers',
                onSeeAll: () {},
              ),
            ),
            
            SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverToBoxAdapter(
              child: SizedBox(
                height: isSmallPhone ? 230 : 260,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  scrollDirection: Axis.horizontal,
                  itemCount: _filteredProducts.length,
                  separatorBuilder: (_, __) => SizedBox(width: isSmallPhone ? 12 : 16),
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return SizedBox(
                      width: productCardWidth,
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
            ),

            SliverToBoxAdapter(child: SizedBox(height: 28)),

            // New Arrivals Section
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'New Arrivals',
                onSeeAll: () {},
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveUtils.getGridColumns(context),
                  childAspectRatio: ResponsiveUtils.getGridChildAspectRatio(context),
                  crossAxisSpacing: isSmallPhone ? 12 : 16,
                  mainAxisSpacing: isSmallPhone ? 12 : 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
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
                  childCount: _filteredProducts.length > 6 ? 6 : _filteredProducts.length,
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category, IconData icon) {
    final isSelected = _selectedCategory == category;
    final isSmallPhone = ResponsiveUtils.isSmallPhone(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallPhone ? 14 : 16,
          vertical: isSmallPhone ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryColor 
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected ? AppTheme.shadowSm : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isSmallPhone ? 16 : 18,
              color: isSelected 
                  ? Colors.white 
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
            SizedBox(width: 6),
            Text(
              category,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isSmallPhone ? 13 : 14,
                color: isSelected 
                    ? Colors.white 
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}