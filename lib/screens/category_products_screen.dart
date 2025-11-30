import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/products_data.dart';
import '../widgets/product_card.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart_provider.dart';

class CategoryProductsScreen extends StatelessWidget {
  static const routeName = '/category-products';

  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final categoryProducts = dummyProducts.where((prod) {
      if (categoryName == 'All') return true;
      return prod.category == categoryName;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: categoryProducts.isEmpty
          ? Center(
              child: Text('No products found in this category.'),
            )
          : GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categoryProducts.length,
              itemBuilder: (context, index) {
                final product = categoryProducts[index];
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
    );
  }
}
