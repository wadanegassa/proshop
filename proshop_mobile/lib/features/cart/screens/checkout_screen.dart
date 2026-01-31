import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/design_background.dart';
import '../../../models/order_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../routes/app_routes.dart';

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
  String _paymentMethod = 'PayPal';
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
        price: i.product.price,
        product: i.product.id,
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
          // Show PayPal Simulation Dialog
          bool? simulatePaymentSuccess = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                title: Row(
                  children: [
                    Icon(Icons.payment, color: Colors.blue[900]),
                    const SizedBox(width: 10),
                    const Flexible(
                      child: Text('PayPal (Simulated)', 
                        style: TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LinearProgressIndicator(),
                    const SizedBox(height: 20),
                    Text('Connecting to PayPal...', style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(height: 10),
                    Text('Total: \$${total.toStringAsFixed(2)}', 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false), // User Cancel
                    child: const Text('Cancel Request'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      // Mimic processing delay
                      // Mimic processing delay
                      Navigator.of(context).pop(true); 
                    },
                    child: const Text('Approve Payment'),
                  ),
                ],
              );
            },
          );

          // Add a secondary processing delay for realism/network
          if (simulatePaymentSuccess == true) {
             showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => const Center(child: CircularProgressIndicator()),
             );
             await Future.delayed(const Duration(seconds: 2));
             Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading
          }

          if (simulatePaymentSuccess == true) {
            final mockPaymentResult = {
              'id': 'PAYID-${DateTime.now().millisecondsSinceEpoch}',
              'status': 'COMPLETED',
              'update_time': DateTime.now().toIso8601String(),
              'payer': {'email_address': 'customer@example.com'},
            };

            final paymentError = await orderProvider.payOrder(orderId, mockPaymentResult);
            
            if (paymentError == null && mounted) {
              _finishCheckout(selectedItems);
            } else if (mounted) {
              await _handlePaymentFailure(orderId, paymentError ?? 'Payment verification failed.');
            }
          } else {
            await _handlePaymentFailure(orderId, 'Payment cancelled by user.');
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
      cart.removeItem(item.product.id);
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
                        _buildSectionHeader('Shipping Address'),
                        const SizedBox(height: 16),
                        _buildTextField('Full Name', _fullNameController),
                        const SizedBox(height: 12),
                        _buildTextField('Address', _addressController),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _buildTextField('City', _cityController)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildTextField('Postal Code', _postalCodeController)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField('Country', _countryController),
                        const SizedBox(height: 12),
                        _buildTextField('Phone Number', _phoneController, keyboardType: TextInputType.phone),
                        
                        const SizedBox(height: 32),
                        _buildSectionHeader('Payment Method'),
                        const SizedBox(height: 16),
                        _buildPaymentOption('PayPal', Icons.payment),
                        _buildPaymentOption('Stripe', Icons.credit_card),
                        _buildPaymentOption('Cash on Delivery', Icons.money),
                        
                        const SizedBox(height: 32),
                        _buildOrderSummary(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textMuted.withOpacity(0.2)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textMuted),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
        ),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildPaymentOption(String method, IconData icon) {
    final isSelected = _paymentMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = method),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textMuted.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textMuted),
            const SizedBox(width: 16),
            Text(
              method,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
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

  Widget _buildOrderSummary() {
    final cart = context.watch<CartProvider>();
    final settings = context.watch<SettingsProvider>();
    
    final subtotal = cart.totalAmount;
    final shippingFee = settings.shippingFee;
    final tax = subtotal * settings.taxRate;
    final discount = subtotal * (settings.globalDiscount / 100);
    final total = subtotal + shippingFee + tax - discount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildRow('Tax (${(settings.taxRate * 100).toStringAsFixed(0)}%)', '\$${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildRow('Shipping', '\$${shippingFee.toStringAsFixed(2)}'),
          if (discount > 0) ...[
            const SizedBox(height: 8),
            _buildRow('Discount', '-\$${discount.toStringAsFixed(2)}', isDiscount: true),
          ],
          const Divider(height: 24, color: AppColors.textMuted),
          _buildRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isTotal = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isTotal ? Colors.white : AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? AppColors.primary : (isDiscount ? AppColors.success : Colors.white),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.chevron_left, color: Colors.white),
      ),
    );
  }
}
