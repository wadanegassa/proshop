import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../providers/admin_order_provider.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AdminOrderProvider>().fetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminOrderProvider>(
      builder: (context, orderProvider, child) {
        final orders = orderProvider.orders;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      'View and manage customer orders',
                      style: TextStyle(fontSize: 12, color: AdminColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AdminColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AdminColors.divider),
              ),
              child: orderProvider.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Column(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(dividerColor: AdminColors.divider),
                          child: SizedBox(
                            width: double.infinity,
                            child: DataTable(
                              headingRowHeight: 50,
                              dataRowMaxHeight: 65,
                              columns: const [
                                DataColumn(label: Text('ORDER ID')),
                                DataColumn(label: Text('DATE')),
                                DataColumn(label: Text('CUSTOMER')),
                                DataColumn(label: Text('AMOUNT')),
                                DataColumn(label: Text('STATUS')),
                                DataColumn(label: Text('ACTION')),
                              ],
                              rows: orders.map((order) {
                                return DataRow(cells: [
                                  DataCell(Text(order.id.substring(order.id.length - 6), style: const TextStyle(color: AdminColors.primary))),
                                  DataCell(Text(DateFormat('dd MMM').format(order.createdAt), style: const TextStyle(color: Colors.white))),
                                  DataCell(Text(order.customerName, style: const TextStyle(color: Colors.white))),
                                  DataCell(Text('\$${order.totalPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white))),
                                  DataCell(Text(order.status, style: TextStyle(color: _getStatusColor(order.status)))),
                                  DataCell(
                                    DropdownButton<String>(
                                      value: order.status,
                                      dropdownColor: AdminColors.surface,
                                      underline: const SizedBox(),
                                      items: ['pending', 'processing', 'shipped', 'delivered', 'cancelled']
                                          .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12, color: Colors.white))))
                                          .toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          orderProvider.updateOrderStatus(order.id, val);
                                        }
                                      },
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered': return AdminColors.success;
      case 'pending': return AdminColors.warning;
      case 'processing': return AdminColors.info;
      case 'cancelled': return AdminColors.error;
      default: return AdminColors.textSecondary;
    }
  }
}
