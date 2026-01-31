import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/design_background.dart';
import '../../../routes/app_routes.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../models/order_model.dart';
import '../widgets/cart_item_widget.dart';

import '../../../providers/settings_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh settings when entering the screen to ensure latest admin changes are reflected
    Future.microtask(() => 
      Provider.of<SettingsProvider>(context, listen: false).fetchSettings()
    );
  }

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
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: items.length + 1,
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return const SizedBox(height: 40); // Bottom spacer
                        }
                        return CartItemWidget(cartItem: items[index]);
                      },
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
    return Consumer2<CartProvider, SettingsProvider>(
      builder: (context, cartProvider, settingsProvider, child) {
        final subtotal = cartProvider.totalAmount;
        
        final shippingFee = settingsProvider.shippingFee;
        final discount = subtotal * (settingsProvider.globalDiscount / 100);
        // Tax is usually calculated on (subtotal - discount) or just subtotal depending on region.
        // We'll calculate tax on subtotal to mimic CheckoutScreen logic for now.
        final tax = subtotal * settingsProvider.taxRate;
        
        // Final Total
        final total = subtotal + shippingFee + tax - discount;

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
              _buildSummaryRow('Shipping:', '\$${shippingFee.toStringAsFixed(2)}'),
              const SizedBox(height: 12),
              if (settingsProvider.taxRate > 0) ...[
                 _buildSummaryRow('Tax (${(settingsProvider.taxRate*100).toStringAsFixed(0)}%):', '\$${tax.toStringAsFixed(2)}'),
                 const SizedBox(height: 12),
              ],
              if (settingsProvider.globalDiscount > 0) ...[
                _buildSummaryRow('Discount (${settingsProvider.globalDiscount.toStringAsFixed(0)}%):', '-\$${discount.toStringAsFixed(2)}', isDiscount: true),
                const SizedBox(height: 20),
              ],
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
                  Navigator.pushNamed(context, AppRoutes.checkout);
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
