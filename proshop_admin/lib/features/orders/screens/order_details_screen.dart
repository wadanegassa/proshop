import 'package:flutter/material.dart';
import '../../../core/constants/admin_colors.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column - Status, Items, Timeline
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  const _OrderProgressPanel(),
                  const SizedBox(height: 24),
                  const _OrderItemsPanel(),
                  const SizedBox(height: 24),
                  const _OrderTimelinePanel(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            // Right Column - Summary, Payment, Customer
            const SizedBox(
              width: 360,
              child: Column(
                children: [
                  _OrderSummaryPanel(),
                  SizedBox(height: 24),
                  _PaymentInfoPanel(),
                  SizedBox(height: 24),
                  _CustomerDetailsPanel(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              'ORDER DETAILS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            const Text(
              '#0758267/90',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AdminColors.textPrimary),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AdminColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
              child: const Text('Paid', style: TextStyle(color: AdminColors.success, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AdminColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
              child: const Text('In Progress', style: TextStyle(color: AdminColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton(onPressed: () {}, child: const Text('Refund')),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: () {}, child: const Text('Return')),
            const SizedBox(width: 12),
            ElevatedButton(onPressed: () {}, child: const Text('Edit Order')),
          ],
        ),
      ],
    );
  }
}

class _OrderProgressPanel extends StatelessWidget {
  const _OrderProgressPanel();

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
          const Text('Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 32),
          Row(
            children: [
              _buildStep('Order Confirming', true, true),
              _buildStep('Payment Pending', true, true),
              _buildStep('Processing', true, false, isCurrent: true),
              _buildStep('Shipping', false, false),
              _buildStep('Delivered', false, false),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AdminColors.textMuted),
                  SizedBox(width: 8),
                  Text('Estimated shipping date: Apr 25, 2024', style: TextStyle(color: AdminColors.textMuted, fontSize: 12)),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminColors.primary.withValues(alpha: 0.1),
                  foregroundColor: AdminColors.primary,
                  elevation: 0,
                ),
                child: const Text('Make As Ready To Ship'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String label, bool isCompleted, bool isNextCompleted, {bool isCurrent = false}) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container(height: 4, color: isCompleted ? AdminColors.success : AdminColors.divider)),
              const SizedBox(width: 4),
              Expanded(child: Container(height: 4, color: isNextCompleted ? AdminColors.success : (isCurrent ? AdminColors.primary.withValues(alpha: 0.3) : AdminColors.divider))),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: isCompleted || isCurrent ? AdminColors.textPrimary : AdminColors.textMuted,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemsPanel extends StatelessWidget {
  const _OrderItemsPanel();

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
          const Text('Product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 24),
          DataTable(
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('Product Name & Size', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Quantity', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Price', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Tax', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Amount', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
            ],
            rows: [
              _buildProductRow('Men Black Slim Fit T-shirt', 'M', 'Ready', 1, 80.00, 3.00, 83.00),
              _buildProductRow('Dark Green Cargo Pant', 'M', 'Packaging', 1, 130.00, 4.00, 134.00),
              _buildProductRow('Men Dark Brown Wallet', 'S', 'Ready', 1, 132.00, 5.00, 137.00),
            ],
          ),
        ],
      ),
    );
  }

  DataRow _buildProductRow(String name, String size, String status, int qty, double price, double tax, double amount) {
    return DataRow(cells: [
      DataCell(Row(
        children: [
          Container(width: 32, height: 32, color: AdminColors.background, child: const Icon(Icons.image_outlined, size: 16)),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text('Size: $size', style: const TextStyle(fontSize: 10, color: AdminColors.textMuted)),
            ],
          ),
        ],
      )),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: AdminColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
        child: Text(status, style: const TextStyle(color: AdminColors.success, fontSize: 10, fontWeight: FontWeight.bold)),
      )),
      DataCell(Text(qty.toString())),
      DataCell(Text('\$${price.toStringAsFixed(2)}')),
      DataCell(Text('\$${tax.toStringAsFixed(2)}')),
      DataCell(Text('\$${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold))),
    ]);
  }
}

class _OrderTimelinePanel extends StatelessWidget {
  const _OrderTimelinePanel();

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
          const Text('Order Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 32),
          _buildTimelineItem('The packing has been started', 'Confirmed by Gaston Lapierre', 'April 23, 2024, 09:40 am', Icons.inventory_2_outlined),
          _buildTimelineItem('The invoice has been sent to the customer', 'Invoice email was sent to hello@dundermifflin.com', 'April 23, 2024, 09:40 am', Icons.email_outlined, showButton: true),
          _buildTimelineItem('The invoice has been created', 'Invoice created by Gaston Lapierre', 'April 23, 2024, 09:40 am', Icons.receipt_long_outlined),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subTitle, String date, IconData icon, {bool showButton = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AdminColors.success.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 16, color: AdminColors.success),
              ),
              Container(width: 1, height: 40, color: AdminColors.divider),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                Text(subTitle, style: const TextStyle(color: AdminColors.textMuted, fontSize: 11)),
                if (showButton) ...[
                  const SizedBox(height: 8),
                  OutlinedButton(onPressed: () {}, child: const Text('Resend Invoice', style: TextStyle(fontSize: 10))),
                ],
              ],
            ),
          ),
          Text(date, style: const TextStyle(color: AdminColors.textMuted, fontSize: 10)),
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
          _buildSummaryRow('Sub Total:', '\$777.00'),
          _buildSummaryRow('Discount:', '-\$60.00'),
          _buildSummaryRow('Delivery Charge:', '\$00.00'),
          _buildSummaryRow('Estimated Tax (15.5%):', '\$20.00'),
          const Divider(height: 32, color: AdminColors.divider),
          _buildSummaryRow('Total Amount:', '\$737.00', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isTotal ? AdminColors.textPrimary : AdminColors.textMuted, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTotal ? 16 : 13, color: isTotal ? AdminColors.primary : AdminColors.textPrimary)),
        ],
      ),
    );
  }
}

class _PaymentInfoPanel extends StatelessWidget {
  const _PaymentInfoPanel();

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
          const Text('Payment Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 48,
                height: 32,
                decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                child: const Icon(Icons.credit_card, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Master Card', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  Text('xxxx xxxx xxxx 7812', style: TextStyle(color: AdminColors.textMuted, fontSize: 11)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.check_circle_outline, color: AdminColors.success, size: 20),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Transaction ID: #RB235617890', style: TextStyle(fontSize: 11, color: AdminColors.textMuted)),
          const Text('Card Holder Name: Gaston Lapierre', style: TextStyle(fontSize: 11, color: AdminColors.textMuted)),
        ],
      ),
    );
  }
}

class _CustomerDetailsPanel extends StatelessWidget {
  const _CustomerDetailsPanel();

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
          const Text('Customer Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 24),
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=gaston')),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Gaston Lapierre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('hello@dundermifflin.com', style: TextStyle(color: AdminColors.primary.withValues(alpha: 0.8), fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoItem('Contact Number', '(723) 732-756-5760'),
          _buildInfoItem('Shipping Address', '1311 Marshall Hollow Road, Tukwila, WA 98168, United States'),
          _buildInfoItem('Billing Address', 'Same as shipping address'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const Icon(Icons.edit_outlined, size: 14, color: AdminColors.textMuted),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: AdminColors.textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}
