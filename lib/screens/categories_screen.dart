import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
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
                color: AppTheme.surfaceColor,
                borderRadius: AppTheme.radius16,
                boxShadow: AppTheme.shadowSm,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: (category['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      size: 32,
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