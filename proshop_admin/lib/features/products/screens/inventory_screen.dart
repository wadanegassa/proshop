import 'package:flutter/material.dart';
import '../../../core/constants/admin_colors.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'Inventory',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage stock levels and SKUs',
                  style: TextStyle(fontSize: 12, color: AdminColors.textMuted),
                ),
              ],
            ),
            Row(
              children: [
                OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AdminColors.textSecondary,
                      side: const BorderSide(color: AdminColors.divider),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('Export')),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Update Stock'),
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: AdminColors.divider),
              child: DataTable(
                headingRowHeight: 50,
                dataRowMaxHeight: 65,
                headingRowColor: WidgetStateProperty.all(AdminColors.background.withValues(alpha: 0.3)),
                columns: const [
                  DataColumn(label: Text('PRODUCT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                  DataColumn(label: Text('SKU', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                  DataColumn(label: Text('CATEGORY', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                  DataColumn(label: Text('STOCK', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                  DataColumn(label: Text('PRICE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                  DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                  DataColumn(label: Text('ACTION', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5))),
                ],
                rows: [
                  _buildRow('Men Black T-shirt', 'TSH-001', 'Fashion', '485', '\$80.00', 'In Stock'),
                  _buildRow('Dark Green Cargo', 'CARG-042', 'Fashion', '12', '\$134.00', 'Low Stock'),
                  _buildRow('Riding Jacket', 'JACK-991', 'Motorcycle', '0', '\$250.00', 'Out of Stock'),
                  _buildRow('Smart Watch Pro', 'WATCH-X', 'Electronics', '85', '\$199.00', 'In Stock'),
                  _buildRow('Leather Wallet', 'WAL-02', 'Accessories', '210', '\$45.00', 'In Stock'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildRow(String name, String sku, String cat, String stock, String price, String status) {
    final isOut = status == 'Out of Stock';
    final isLow = status == 'Low Stock';
    final statusColor = isOut ? AdminColors.error : (isLow ? AdminColors.warning : AdminColors.success);

    return DataRow(cells: [
      DataCell(Row(
        children: [
          Container(
            width: 36, 
            height: 36, 
            decoration: BoxDecoration(
              color: AdminColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AdminColors.divider),
            ),
            child: const Icon(Icons.image_outlined, size: 16, color: AdminColors.textMuted),
          ),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white)),
        ],
      )),
      DataCell(Text(sku, style: const TextStyle(color: AdminColors.textMuted, fontSize: 12))),
      DataCell(Text(cat, style: const TextStyle(color: AdminColors.textSecondary))),
      DataCell(Text(stock, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
      DataCell(Text(price, style: const TextStyle(color: AdminColors.textSecondary))),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
        child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
      )),
      DataCell(Row(
        children: [
          _buildActionIconButton(Icons.history_rounded, AdminColors.textSecondary),
          const SizedBox(width: 8),
          _buildActionIconButton(Icons.edit_outlined, AdminColors.primary),
        ],
      )),
    ]);
  }

  Widget _buildActionIconButton(IconData icon, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }
}
