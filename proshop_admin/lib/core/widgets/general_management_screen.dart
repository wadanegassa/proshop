import 'package:flutter/material.dart';

import '../../core/constants/admin_colors.dart';

class GeneralManagementScreen extends StatelessWidget {
  final String title;
  final List<String> columns;
  final List<List<dynamic>> data;
  final String addButtonLabel;

  const GeneralManagementScreen({
    super.key,
    required this.title,
    required this.columns,
    required this.data,
    this.addButtonLabel = 'Add New',
  });

  @override
  Widget build(BuildContext context) {
    // Note: AdminLayout removed if handled by MainShell, but keeping structure generic.
    // If usage expects full screen, we assume MainShell wraps this.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your $title entries',
                  style: const TextStyle(fontSize: 12, color: AdminColors.textMuted),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(addButtonLabel),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Header
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
                        child: TextField(
                          style: const TextStyle(fontSize: 13, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search $title...',
                            hintStyle: const TextStyle(color: AdminColors.textMuted),
                            prefixIcon: const Icon(Icons.search_rounded, size: 16, color: AdminColors.textMuted),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AdminColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AdminColors.divider),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.filter_list_rounded, size: 14, color: AdminColors.textSecondary),
                          SizedBox(width: 8),
                          Text('Filters', style: TextStyle(fontSize: 12, color: AdminColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(dividerColor: AdminColors.divider),
                child: DataTable(
                  headingRowHeight: 50,
                  dataRowMaxHeight: 65,
                  headingRowColor: WidgetStateProperty.all(AdminColors.background.withValues(alpha: 0.3)),
                  columnSpacing: 24,
                  columns: columns
                      .map((c) => DataColumn(
                            label: Text(
                              c.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5),
                            ),
                          ))
                      .toList(),
                  rows: data
                      .map((row) => DataRow(
                            cells: row.map((cell) {
                              if (cell is Widget) return DataCell(cell);
                              return DataCell(
                                Text(
                                  cell.toString(),
                                  style: const TextStyle(color: AdminColors.textSecondary, fontSize: 13),
                                ),
                              );
                            }).toList(),
                          ))
                      .toList(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text('Showing all entries', style: TextStyle(color: AdminColors.textMuted, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
