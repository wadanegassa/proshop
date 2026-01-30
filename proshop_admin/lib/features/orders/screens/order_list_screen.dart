import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../providers/admin_order_provider.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<AdminOrderProvider>(context);
    final orders = orderProvider.orders;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orders Management',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage and track customer orders efficiently',
                  style: TextStyle(fontSize: 12, color: AdminColors.textMuted),
                ),
              ],
            ),
            Row(
              children: [
                _buildActionOutlineButton(Icons.filter_list_rounded, 'Filters'),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/checkout');
                  },
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Create Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Table Container
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AdminColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AdminColors.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Search & Quick Filters
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AdminColors.background.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AdminColors.divider),
                        ),
                        child: const TextField(
                          style: TextStyle(fontSize: 13, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search by Order ID, Customer...',
                            hintStyle: TextStyle(color: AdminColors.textMuted),
                            prefixIcon: Icon(Icons.search_rounded, size: 16, color: AdminColors.textMuted),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildStatusFilter('All Status'),
                    const SizedBox(width: 8),
                    _buildStatusFilter('April 2024'),
                  ],
                ),
              ),
              
              // Table
              Theme(
                data: Theme.of(context).copyWith(dividerColor: AdminColors.divider),
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    headingRowHeight: 50,
                    dataRowMaxHeight: 65,
                    headingRowColor: WidgetStateProperty.all(Colors.transparent),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: AdminColors.divider)),
                    ),
                    columnSpacing: 24,
                    columns: const [
                      DataColumn(label: Text('ORDER ID', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('DATE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('CUSTOMER', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('PAYMENT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                      DataColumn(label: Text('ACTION', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                    ],
                    rows: orders.map((order) {
                      final statusColor = _getStatusColor(order.status);
                      return DataRow(
                        color: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.hovered)) {
                            return AdminColors.primary.withValues(alpha: 0.05);
                          }
                          return Colors.transparent;
                        }),
                        cells: [
                        DataCell(Text(order.id, style: const TextStyle(color: AdminColors.primary, fontWeight: FontWeight.w800, fontSize: 13))),
                        DataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(DateFormat('dd MMM, yyyy').format(order.createdAt), style: const TextStyle(color: Colors.white, fontSize: 13)),
                              Text(DateFormat('hh:mm a').format(order.createdAt), style: const TextStyle(color: AdminColors.textMuted, fontSize: 11)),
                            ],
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AdminColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    order.customerName[0],
                                    style: const TextStyle(color: AdminColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                            ],
                          ),
                        ),
                        DataCell(Text(order.paymentType, style: const TextStyle(color: AdminColors.textSecondary))),
                        DataCell(Text('\$${order.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white))),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              order.status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              _buildActionIconButton(Icons.visibility_outlined, AdminColors.info, onPressed: () {
                                Navigator.pushNamed(context, '/order-details');
                              }),
                              const SizedBox(width: 6),
                              _buildActionIconButton(Icons.edit_outlined, AdminColors.primary, onPressed: () {
                                Navigator.pushNamed(context, '/order-details'); // Edit often goes to details or special edit
                              }),
                              const SizedBox(width: 6),
                              _buildActionIconButton(Icons.delete_outline_rounded, AdminColors.error, onPressed: () {}),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
              
              // Footer
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Showing 1-10 of 128 orders', style: TextStyle(fontSize: 12, color: AdminColors.textMuted)),
                    Row(
                      children: [
                        _buildPageButton('Previous', false),
                        const SizedBox(width: 8),
                        _buildPageButton('1', true),
                        const SizedBox(width: 4),
                        _buildPageButton('2', false),
                        const SizedBox(width: 8),
                        _buildPageButton('Next', false),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionOutlineButton(IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AdminColors.textPrimary,
        side: const BorderSide(color: AdminColors.divider),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildStatusFilter(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AdminColors.textSecondary)),
          const SizedBox(width: 6),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: AdminColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildActionIconButton(IconData icon, Color color, {VoidCallback? onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }

  Widget _buildPageButton(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AdminColors.primary : AdminColors.background,
        borderRadius: BorderRadius.circular(6),
        border: isActive ? null : Border.all(color: AdminColors.divider),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : AdminColors.textSecondary,
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
      case 'Delivered':
        return AdminColors.success;
      case 'Pending':
        return AdminColors.warning;
      case 'Processing':
        return AdminColors.info;
      case 'Cancelled':
        return AdminColors.error;
      default:
        return AdminColors.textSecondary;
    }
  }
}
