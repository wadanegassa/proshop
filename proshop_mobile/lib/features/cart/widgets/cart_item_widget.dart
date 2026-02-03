import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/product_image.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Selection Checkbox
          Checkbox(
            value: cartItem.isSelected,
            activeColor: AppColors.primary,
            checkColor: Colors.white,
            onChanged: (_) => cartProvider.toggleSelection(cartItem.key),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            side: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.3), width: 1.5),
          ),
          // Product Image
          Container(
            height: 75,
            width: 75,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ProductImage(
              imagePath: cartItem.product.image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          // Name and Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (cartItem.selectedSize != null || cartItem.selectedColor != null || cartItem.selectedShoeSize != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      [
                        if (cartItem.selectedSize != null) cartItem.selectedSize,
                        if (cartItem.selectedShoeSize != null) 'Size: ${cartItem.selectedShoeSize}',
                        if (cartItem.selectedColor != null) cartItem.selectedColor,
                      ].join(' | '),
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        '\$${cartItem.product.discountedPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (cartItem.product.discount > 0) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '\$${cartItem.product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Quantity Controls
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                            title: const Text('Remove Item'),
                            content: const Text('Are you sure you want to remove this item from your cart?'),
                            actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () {
                                        cartProvider.removeItem(cartItem.key);
                                        Navigator.pop(ctx);
                                    },
                                    child: const Text('Remove', style: TextStyle(color: Colors.red)),
                                ),
                            ],
                        ),
                    );
                },
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildControlButton(
                    context,
                    icon: Icons.remove_rounded,
                    onTap: () => cartProvider.removeSingleItem(cartItem.key),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${cartItem.quantity}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).textTheme.titleSmall?.color,
                      ),
                    ),
                  ),
                  _buildControlButton(
                    context,
                    icon: Icons.add_rounded,
                    onTap: () => cartProvider.addItem(
                      cartItem.product,
                      size: cartItem.selectedSize,
                      color: cartItem.selectedColor,
                      shoeSize: cartItem.selectedShoeSize,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(BuildContext context, {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Theme.of(context).iconTheme.color, size: 18),
      ),
    );
  }
}
