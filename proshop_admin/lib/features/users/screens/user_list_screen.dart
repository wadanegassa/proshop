import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../providers/admin_user_provider.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AdminUserProvider>().fetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminUserProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Management',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'View and manage registered customers',
                  style: TextStyle(fontSize: 12, color: AdminColors.textMuted),
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
              child: provider.isLoading
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
                                DataColumn(label: Text('USER')),
                                DataColumn(label: Text('EMAIL')),
                                DataColumn(label: Text('STATUS')),
                                DataColumn(label: Text('ACTION')),
                              ],
                              rows: provider.users.map((user) {
                                final isBlocked = user['isBlocked'] ?? false;
                                return DataRow(cells: [
                                  DataCell(Text(user['name'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                                  DataCell(Text(user['email'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                                  DataCell(Text(
                                    isBlocked ? 'Blocked' : 'Active',
                                    style: TextStyle(color: isBlocked ? AdminColors.error : AdminColors.success),
                                  )),
                                  DataCell(
                                    ElevatedButton(
                                      onPressed: () => provider.toggleBlockUser(user['_id'], isBlocked),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isBlocked ? AdminColors.success : AdminColors.error,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                      ),
                                      child: Text(isBlocked ? 'Unblock' : 'Block', style: const TextStyle(fontSize: 12)),
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
}
