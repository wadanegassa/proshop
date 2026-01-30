import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/design_background.dart';
import '../../../providers/product_provider.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DesignBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Search Input
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search products...',
                            hintStyle: TextStyle(color: AppColors.textMuted),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _query = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Results
              Expanded(
                child: Consumer<ProductProvider>(
                  builder: (context, provider, child) {
                    final results = provider.products.where((p) => 
                      p.name.toLowerCase().contains(_query.toLowerCase()) ||
                      p.category.toLowerCase().contains(_query.toLowerCase())
                    ).toList();

                    if (_query.isEmpty) {
                      return const Center(
                        child: Text(
                          'Type something to start searching',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      );
                    }

                    if (results.isEmpty) {
                      return const Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: results[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
