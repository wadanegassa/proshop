import 'package:flutter/material.dart';
import '../../../core/constants/admin_colors.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ORDER CHECKOUT',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column - Details
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  const _PersonalDetailsPanel(),
                  const SizedBox(height: 24),
                  const _ShippingDetailsPanel(),
                  const SizedBox(height: 24),
                  const _ShippingMethodPanel(),
                  const SizedBox(height: 24),
                  const _PaymentMethodPanel(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            // Right Column - Summary
            const SizedBox(
              width: 380,
              child: Column(
                children: [
                  _PromoCodePanel(),
                  SizedBox(height: 24),
                  _OrderSummaryPanel(),
                  SizedBox(height: 24),
                  _CheckoutActionsPanel(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _PersonalDetailsPanel extends StatelessWidget {
  const _PersonalDetailsPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Personal Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildInputField('First Name', 'First name')),
              const SizedBox(width: 24),
              Expanded(child: _buildInputField('Last Name', 'Last name')),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildInputField('Your Email', 'Email')),
              const SizedBox(width: 24),
              Expanded(child: _buildInputField('Phone number', 'Number')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AdminColors.textMuted, fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.divider)),
          ),
        ),
      ],
    );
  }
}

class _ShippingDetailsPanel extends StatelessWidget {
  const _ShippingDetailsPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Shipping Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 24),
          _buildInputField('Shipping Address:', 'Enter address'),
          const SizedBox(height: 24),
          _buildTextArea('Full Address', 'Enter address'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildInputField('Zip Code', 'zip code')),
              const SizedBox(width: 24),
              Expanded(child: _buildSelectField('City', 'Choose city')),
              const SizedBox(width: 24),
              Expanded(child: _buildSelectField('Country', 'Choose country')),
            ],
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add New Billing Address', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AdminColors.textMuted, fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.divider)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AdminColors.textMuted, fontSize: 13),
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.divider)),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          onChanged: (val) {},
          items: const [],
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AdminColors.textMuted, fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.divider)),
          ),
        ),
      ],
    );
  }
}

class _ShippingMethodPanel extends StatelessWidget {
  const _ShippingMethodPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Shipping Method:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildMethodCard('DHL Fast Services', 'Delivery - Today', '\$10.00', true),
              const SizedBox(width: 24),
              _buildMethodCard('FedEx Services', 'Delivery - Today', '\$10.00', false),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMethodCard('UPS Services', 'Delivery - Tomorrow', '\$8.00', false),
              const SizedBox(width: 24),
              _buildMethodCard('Our Courier Services', 'Delivery - 25 Apr 2024', '\$0.00', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard(String title, String subTitle, String price, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AdminColors.background.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AdminColors.primary : AdminColors.divider),
        ),
        child: Row(
          children: [
            Container(width: 32, height: 32, decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: const Icon(Icons.local_shipping, size: 16, color: Colors.red)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(subTitle, style: const TextStyle(color: AdminColors.textMuted, fontSize: 10)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 4),
                Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, size: 16, color: isSelected ? AdminColors.primary : AdminColors.textMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodPanel extends StatelessWidget {
  const _PaymentMethodPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AdminColors.background.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8), border: Border.all(color: AdminColors.divider)),
            child: const Row(
              children: [
                Text('Paypal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Spacer(),
                Icon(Icons.payment, color: Colors.blue, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text('Safe Payment Online Credit card needed. PayPal account is not necessary', style: TextStyle(color: AdminColors.textMuted, fontSize: 11)),
          const SizedBox(height: 24),
          const Row(
            children: [
              Text('Credit card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Spacer(),
              Row(
                children: [
                  Icon(Icons.credit_card, size: 16, color: Colors.blue),
                  SizedBox(width: 4),
                  Icon(Icons.payment, size: 16, color: Colors.orange),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Safe Money Transfer using your bank account. Visa, Master Card, Discover, American Express', style: TextStyle(color: AdminColors.textMuted, fontSize: 11)),
          const SizedBox(height: 24),
          _buildInputField('Card Number', 'xxxx xxxx xxxx xxxx'),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AdminColors.textMuted, fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.divider)),
          ),
        ),
      ],
    );
  }
}

class _PromoCodePanel extends StatelessWidget {
  const _PromoCodePanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AdminColors.primary, AdminColors.primary.withValues(alpha: 0.7)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text('Have a Promo Code ?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: 'CODE123',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white30)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: AdminColors.background, foregroundColor: Colors.white),
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryPanel extends StatelessWidget {
  const _OrderSummaryPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 24),
          _buildItemRow('Men Black Slim Fit T-shirt', 'Size: M', '\$83.00'),
          _buildItemRow('Dark Green Cargo Pant', 'Size: M', '\$134.00'),
          _buildItemRow('Men Dark Brown Wallet', 'Size: S', '\$137.00'),
          const Divider(height: 32, color: AdminColors.divider),
          _buildSummaryRow('Sub Total :', '\$777.00'),
          _buildSummaryRow('Discount :', '-\$60.00'),
          _buildSummaryRow('Delivery Charge :', '\$00.00'),
          _buildSummaryRow('Estimated Tax (15.5%) :', '\$20.00'),
          const Divider(height: 32, color: AdminColors.divider),
          _buildSummaryRow('Total Amount', '\$737.00', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildItemRow(String name, String sub, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(width: 24, height: 24, color: AdminColors.background, child: const Icon(Icons.image_outlined, size: 12)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                Text(sub, style: const TextStyle(color: AdminColors.textMuted, fontSize: 10)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isTotal ? AdminColors.textPrimary : AdminColors.textMuted, fontSize: 13, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTotal ? 16 : 13, color: isTotal ? AdminColors.primary : AdminColors.textPrimary)),
        ],
      ),
    );
  }
}

class _CheckoutActionsPanel extends StatelessWidget {
  const _CheckoutActionsPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: const Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: Colors.orange, size: 20),
              SizedBox(width: 12),
              Expanded(child: Text('Estimated Delivery by 25 April, 2024', style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Back To Cart'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Checkout Order'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
