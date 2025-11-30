import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final isDesktop = MediaQuery.of(context).size.width >= 1100;

    if (isDesktop) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: AppIconButton(
            icon: Icons.arrow_back,
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: AppTheme.surfaceColor,
          ),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side - Image
            Expanded(
              flex: 1,
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.all(32),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Right Side - Details
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          '\$${product.price}',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppTheme.primaryColor,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 4),
                        Text(
                          '4.8',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '(120 reviews)',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                            fontSize: 16,
                          ),
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Colors',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        _buildColorDot(Colors.black, true),
                        _buildColorDot(Colors.blue, false),
                        _buildColorDot(Colors.red, false),
                      ],
                    ),
                    SizedBox(height: 48),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.textLight),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.shopping_cart_outlined),
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addItem(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Added to cart')),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Buy Now',
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addItem(product);
                              Navigator.of(context).pushNamed('/cart');
                            },
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
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Padding(
                  padding: EdgeInsets.all(8),
                  child: AppIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.of(context).pop(),
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: AppIconButton(
                      icon: Icons.favorite_border,
                      onPressed: () {},
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  transform: Matrix4.translationValues(0, -20, 0),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.title,
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              '\$${product.price}',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: AppTheme.primaryColor,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 4),
                            Text(
                              '4.8',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '(120 reviews)',
                              style: TextStyle(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                height: 1.5,
                              ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Colors',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            _buildColorDot(Colors.black, true),
                            _buildColorDot(Colors.blue, false),
                            _buildColorDot(Colors.red, false),
                          ],
                        ),
                        SizedBox(height: 100), // Space for bottom bar
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: AppTheme.shadowLg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.textLight),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart_outlined),
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to cart')),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Buy Now',
                      onPressed: () {
                         Provider.of<CartProvider>(context, listen: false)
                            .addItem(product);
                         Navigator.of(context).pushNamed('/cart');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ).animate().slideY(begin: 1, end: 0, duration: 400.ms),
        ],
      ),
    );
  }

  Widget _buildColorDot(Color color, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected ? Border.all(color: color, width: 2) : null,
      ),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
