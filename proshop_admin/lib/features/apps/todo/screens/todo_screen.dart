import 'package:flutter/material.dart';
import '../../../../core/constants/admin_colors.dart';


class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TODO LIST',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: MediaQuery.of(context).size.height - 240,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 240, child: _TodoSidebar()),
              const SizedBox(width: 24),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AdminColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AdminColors.divider),
                  ),
                  child: const Column(
                    children: [
                      _TodoHeader(),
                      Expanded(child: _TodoList()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TodoSidebar extends StatelessWidget {
  const _TodoSidebar();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Add Task'),
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
        ),
        const SizedBox(height: 24),
        _buildItem(Icons.list, 'All Tasks', true),
        _buildItem(Icons.star_outline, 'Important', false),
        _buildItem(Icons.done_all, 'Completed', false),
        _buildItem(Icons.delete_outline, 'Trash', false),
      ],
    );
  }

  Widget _buildItem(IconData icon, String label, bool isActive) {
    return ListTile(
      leading: Icon(icon, color: isActive ? AdminColors.primary : AdminColors.textMuted, size: 20),
      title: Text(label, style: TextStyle(color: isActive ? AdminColors.primary : AdminColors.textSecondary, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      dense: true,
      onTap: () {},
    );
  }
}

class _TodoHeader extends StatelessWidget {
  const _TodoHeader();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const Expanded(child: Text('Active Tasks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          IconButton(icon: const Icon(Icons.sort, size: 20), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, size: 20), onPressed: () {}),
        ],
      ),
    );
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildTask('Update Product Prices', 'Catalog', true),
        _buildTask('Reply to customer support tickets', 'Support', false),
        _buildTask('Review new vendor applications', 'Marketplace', false),
        _buildTask('Optimize database queries', 'Tech', true),
        _buildTask('Prepare monthly sales report', 'Finance', false),
      ],
    );
  }

  Widget _buildTask(String title, String tag, bool isImportant) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AdminColors.divider))),
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (v) {}),
          if (isImportant) const Icon(Icons.star, color: Colors.amber, size: 18),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AdminColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(tag, style: const TextStyle(color: AdminColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
