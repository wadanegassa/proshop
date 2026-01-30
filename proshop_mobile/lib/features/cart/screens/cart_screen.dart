import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/design_background.dart';
import '../../../routes/app_routes.dart';
import '../../../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DesignBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    const BackButtonCircle(),
                    const SizedBox(width: 20),
                    Text(
                      'My Shopping Cart',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    final items = cartProvider.items.values.toList();
                    if (items.isEmpty) {
                      return const Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return CartItemWidget(cartItem: items[index]);
                            },
                          ),
                        ),
                        // Free Shipping Banner
                        if (items.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            child: Column(
                              children: [
                                const Text(
                                  'Your cart qualifies for free shipping',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const TextField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Bike30',
                                            hintStyle: TextStyle(color: AppColors.textMuted),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(80, 45),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: const Text('Apply'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const CheckoutSummary(),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckoutSummary extends StatelessWidget {
  const CheckoutSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final subtotal = cartProvider.totalAmount;
        final deliveryFee = subtotal > 0 ? 0.0 : 0.0; // Mock delivery logic
        final discount = subtotal > 0 ? subtotal * 0.3 : 0.0; // Mock 30% discount
        final total = subtotal - discount + deliveryFee;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryRow('Subtotal:', '\$${subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 12),
              _buildSummaryRow('Delivery Fee:', '\$${deliveryFee.toStringAsFixed(2)}'),
              const SizedBox(height: 12),
              _buildSummaryRow('Discount:', '30%', isDiscount: true),
              const SizedBox(height: 20),
              const Divider(color: AppColors.textMuted, thickness: 0.5),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: subtotal > 0 ? () {
                  cartProvider.clear();
                  Navigator.pushNamed(context, AppRoutes.checkoutSuccess);
                } : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Checkout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.chevron_right, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            color: isDiscount ? AppColors.success : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class BackButtonCircle extends StatelessWidget {
  const BackButtonCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Icon(Icons.chevron_left, color: Colors.white),
      ),
    );
  }
}
