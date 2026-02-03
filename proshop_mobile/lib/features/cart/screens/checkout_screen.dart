import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/design_background.dart';
import '../../../models/order_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  String _paymentMethod = 'Stripe';
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();
    final settingsProvider = context.read<SettingsProvider>();

    final selectedItems = cartProvider.selectedItems;
    final subtotal = cartProvider.totalAmount;
    
    // Apply Settings
    final shippingFee = settingsProvider.shippingFee;
    final tax = subtotal * settingsProvider.taxRate;
    final discount = subtotal * (settingsProvider.globalDiscount / 100);
    final total = subtotal + shippingFee + tax - discount;

    final newOrder = OrderModel(
      id: '',
      orderItems: selectedItems.map((i) => OrderItem(
        name: i.product.name,
        qty: i.quantity,
        image: i.product.image,
        price: i.product.discountedPrice,
        product: i.product.id,
        size: i.selectedSize,
        color: i.selectedColor,
      )).toList(),
      shippingAddress: ShippingAddress(
        address: _addressController.text,
        city: _cityController.text,
        postalCode: _postalCodeController.text,
        country: _countryController.text,
        phone: _phoneController.text,
      ),
      paymentMethod: _paymentMethod,
      itemsPrice: subtotal,
      shippingPrice: shippingFee,
      taxPrice: tax,
      totalPrice: total,
      isPaid: false,
      isDelivered: false,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    final String? orderId = await orderProvider.createOrder(newOrder);
    
    if (mounted) {
      if (orderId != null) {
        if (_paymentMethod == 'PayPal') {
          // Real PayPal Sandbox Integration in Full Screen
          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => PaypalCheckoutView(
                  sandboxMode: true,
                  clientId: "AcMp7SH0BReY5lhCu00v0czGTOgHRPDrwPimLJA2sAnEm147Oj8pM5aHCMYkVKlHlIIQXtxdhNTB4zXV",
                  secretKey: "EA_KT5fpqMgou6Zw88Smer5AJPXGYboncPuwEzRBMI-B0enZ9uYX2i5C0z1DwYFyzTarWIDTcfA5nyQ6",
                  transactions: [
                    {
                      "amount": {
                        "total": total.toStringAsFixed(2),
                        "currency": "USD",
                        "details": {
                          "subtotal": total.toStringAsFixed(2),
                          "shipping": '0',
                          "shipping_discount": 0
                        }
                      },
                      "description": "ProShop Order #$orderId",
                      "item_list": {
                        "items": [
                          {
                            "name": "Order Total",
                            "quantity": 1,
                            "price": total.toStringAsFixed(2),
                            "currency": "USD"
                          }
                        ],
                      }
                    }
                  ],
                  note: "Contact us for any questions on your order.",
                  onSuccess: (Map params) async {
                    debugPrint("PayPal Success: $params");
                    final paymentResult = {
                      'id': params['paymentId'],
                      'status': 'COMPLETED',
                      'update_time': DateTime.now().toIso8601String(),
                      'payer': {'email_address': params['payerID']},
                      'method': 'PayPal',
                    };

                    final paymentError = await orderProvider.payOrder(orderId, paymentResult);
                    if (paymentError == null && mounted) {
                      _finishCheckout(selectedItems);
                    } else if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(paymentError ?? 'Failed to update order status')),
                      );
                    }
                  },
                  onError: (error) {
                    debugPrint("PayPal Error: $error");
                    _handlePaymentFailure(orderId, 'PayPal Error: $error');
                  },
                  onCancel: () {
                    debugPrint("PayPal Cancelled");
                    _handlePaymentFailure(orderId, 'Payment cancelled');
                  },
                ),
              ),
            );
          }
        } else if (_paymentMethod == 'Stripe') {
          // Stripe Payment Flow
          debugPrint('Starting Stripe Payment Flow for total: $total');
          
          // 1. Fetch Publishable Key
          final publishableKey = await orderProvider.getStripePublishableKey();
          debugPrint('Stripe Publishable Key: $publishableKey');
          if (publishableKey == null) {
            await _handlePaymentFailure(orderId, 'Failed to initialize payment system.');
            return;
          }
          Stripe.publishableKey = publishableKey;

          // 2. Create Payment Intent
          final clientSecret = await orderProvider.createStripePaymentIntent(total);
          debugPrint('Stripe Client Secret (first 10 chars): ${clientSecret?.substring(0, 10)}...');
          
          if (clientSecret == null) {
            await _handlePaymentFailure(orderId, 'Failed to initialize payment. Please try again.');
            return;
          }

          try {
            // 1. Initialize Payment Sheet
            debugPrint('Initializing Stripe Payment Sheet...');
            await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: clientSecret,
                merchantDisplayName: 'ProShop',
                style: ThemeMode.dark,
              ),
            );

            // 2. Display Payment Sheet
            debugPrint('Presenting Stripe Payment Sheet...');
            await Stripe.instance.presentPaymentSheet();
            debugPrint('Stripe Payment Sheet closed/completed.');

            // 3. Confirm Payment Success
            final paymentResult = {
              'id': 'STRIPEID-${DateTime.now().millisecondsSinceEpoch}',
              'status': 'COMPLETED',
              'update_time': DateTime.now().toIso8601String(),
              'payer': {'email_address': _fullNameController.text},
              'method': 'Stripe',
            };

            final paymentError = await orderProvider.payOrder(orderId, paymentResult);

            if (paymentError == null && mounted) {
              _finishCheckout(selectedItems);
            } else if (mounted) {
              await _handlePaymentFailure(orderId, paymentError ?? 'Payment verification failed.');
            }
          } catch (e) {
            debugPrint('Full Stripe Error Object: $e');
            if (e is StripeException) {
              debugPrint('StripeException Details: ${e.error.localizedMessage} (Code: ${e.error.code})');
              await _handlePaymentFailure(orderId, 'Payment failed: ${e.error.localizedMessage}');
            } else {
              debugPrint('Generic Error in Stripe Flow: $e');
              await _handlePaymentFailure(orderId, 'Payment cancelled or failed.');
            }
          }
        } else {
          // For other methods like COD that don't need immediate payment
          _finishCheckout(selectedItems);
        }
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to initialize order. Please try again.')),
        );
      }
    }
  }

  Future<void> _handlePaymentFailure(String orderId, String message) async {
    final orderProvider = context.read<OrderProvider>();
    await orderProvider.deleteOrder(orderId);
    
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _finishCheckout(List<dynamic> selectedItems) {
    setState(() => _isLoading = false);
    final cart = context.read<CartProvider>();
    for (var item in selectedItems) {
      cart.removeItem(item.key);
    }
    Navigator.pushReplacementNamed(context, AppRoutes.checkoutSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DesignBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    const BackButtonCircle(),
                    const SizedBox(width: 20),
                    Text(
                      'Checkout',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(context, 'Shipping Address'),
                        const SizedBox(height: 16),
                        _buildTextField(context, 'Full Name', _fullNameController),
                        const SizedBox(height: 12),
                        _buildTextField(context, 'Address', _addressController),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _buildTextField(context, 'City', _cityController)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildTextField(context, 'Postal Code', _postalCodeController)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(context, 'Country', _countryController),
                        const SizedBox(height: 12),
                        _buildTextField(context, 'Phone Number', _phoneController, keyboardType: TextInputType.phone),
                        const SizedBox(height: 32),
                        _buildSectionHeader(context, 'Payment Method'),
                        const SizedBox(height: 16),

                        _buildPaymentOption(context, 'Stripe', Icons.credit_card_outlined),
                        _buildPaymentOption(context, 'PayPal', Icons.payment),
                        
                        const SizedBox(height: 32),
                        _buildOrderSummary(context),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomAction(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildTextField(BuildContext context, String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.05)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Theme.of(context).hintColor),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String method, IconData icon) {
    final isSelected = _paymentMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = method),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primary : Theme.of(context).dividerColor.withOpacity(0.05),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : Theme.of(context).hintColor, size: 28),
            const SizedBox(width: 16),
            Text(
              method,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected ? AppColors.primary : Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final settings = context.watch<SettingsProvider>();
    
    final subtotal = cart.totalAmount;
    final shippingFee = settings.shippingFee;
    final tax = subtotal * settings.taxRate;
    final discount = subtotal * (settings.globalDiscount / 100);
    final total = subtotal + shippingFee + tax - discount;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          _buildRow(context, 'Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildRow(context, 'Tax (${(settings.taxRate * 100).toStringAsFixed(0)}%)', '\$${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildRow(context, 'Shipping', '\$${shippingFee.toStringAsFixed(2)}'),
          if (discount > 0) ...[
            const SizedBox(height: 12),
            _buildRow(context, 'Discount', '-\$${discount.toStringAsFixed(2)}', isDiscount: true),
          ],
          Divider(height: 32, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          _buildRow(context, 'Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, {bool isTotal = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(
          color: isTotal ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).hintColor,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
        )),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? AppColors.primary : (isDiscount ? AppColors.success : Theme.of(context).textTheme.bodyLarge?.color),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 20 : 15,
          ),
        ),
      ],
    );
  }

  Widget _buildCardTextField(String label, TextEditingController controller, String hint, {TextInputType? keyboardType, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Theme.of(context).hintColor, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Theme.of(context).hintColor, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
        ),
      ],
    );
  }


  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.05))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitOrder,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: _isLoading 
          ? const CircularProgressIndicator(color: Colors.black)
          : const Text('Place Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class BackButtonCircle extends StatelessWidget {
  const BackButtonCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(Icons.chevron_left_rounded, color: Theme.of(context).iconTheme.color, size: 28),
      ),
    );
  }
}
