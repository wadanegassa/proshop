import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_utils.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'name': 'Electronics', 'icon': Icons.devices, 'color': Color(0xFF4A6CF7)},
    {'name': 'Fashion', 'icon': Icons.checkroom, 'color': Color(0xFFE91E63)},
    {'name': 'Home', 'icon': Icons.home, 'color': Color(0xFF4CAF50)},
    {'name': 'Sports', 'icon': Icons.sports_soccer, 'color': Color(0xFFFF9800)},
    {'name': 'Books', 'icon': Icons.book, 'color': Color(0xFF9C27B0)},
    {'name': 'Beauty', 'icon': Icons.face, 'color': Color(0xFFFF5722)},
    {'name': 'Toys', 'icon': Icons.toys, 'color': Color(0xFF00BCD4)},
    {'name': 'Grocery', 'icon': Icons.shopping_basket, 'color': Color(0xFF8BC34A)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(ResponsiveUtils.getHorizontalPadding(context)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveUtils.getGridColumns(context),
          childAspectRatio: 1.2,
          crossAxisSpacing: ResponsiveUtils.isSmallPhone(context) ? 12 : 16,
          mainAxisSpacing: ResponsiveUtils.isSmallPhone(context) ? 12 : 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                '/category-products',
                arguments: category['name'],
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: AppTheme.radius16,
                boxShadow: AppTheme.shadowSm,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: ResponsiveUtils.isSmallPhone(context) ? 50 : 60,
                    height: ResponsiveUtils.isSmallPhone(context) ? 50 : 60,
                    decoration: BoxDecoration(
                      color: (category['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.isSmallPhone(context) ? 25 : 30),
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      size: ResponsiveUtils.isSmallPhone(context) ? 28 : 32,
                      color: category['color'] as Color,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    category['name'] as String,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}