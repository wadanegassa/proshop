import 'package:flutter/material.dart';
import '../../../../core/constants/admin_colors.dart';


class EmailScreen extends StatelessWidget {
  const EmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 180,
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.divider),
      ),
      child: const Row(
        children: [
          // Left - Folders Sidebar
          SizedBox(
            width: 240,
            child: Column(
              children: [
                _EmailComposeHeader(),
                Expanded(child: _EmailFolderList()),
              ],
            ),
          ),
          VerticalDivider(width: 1, color: AdminColors.divider),
          // Middle - Email List
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _EmailListHeader(),
                Expanded(child: _EmailListView()),
              ],
            ),
          ),
          VerticalDivider(width: 1, color: AdminColors.divider),
          // Right - Email Content
          Expanded(
            flex: 3,
            child: _EmailContentView(),
          ),
        ],
      ),
    );
  }
}

class _EmailComposeHeader extends StatelessWidget {
  const _EmailComposeHeader();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Compose'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 44),
        ),
      ),
    );
  }
}

class _EmailFolderList extends StatelessWidget {
  const _EmailFolderList();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        _buildFolderItem(Icons.inbox, 'Inbox', '125', true),
        _buildFolderItem(Icons.star_outline, 'Starred', '', false),
        _buildFolderItem(Icons.access_time, 'Snoozed', '2', false),
        _buildFolderItem(Icons.send_outlined, 'Sent', '', false),
        _buildFolderItem(Icons.description_outlined, 'Drafts', '4', false),
        _buildFolderItem(Icons.error_outline, 'Spam', '', false),
        _buildFolderItem(Icons.delete_outline, 'Trash', '', false),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('LABELS', style: TextStyle(color: AdminColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        _buildFolderItem(Icons.label_outline, 'Personal', '', false, color: Colors.blue),
        _buildFolderItem(Icons.label_outline, 'Promotions', '12', false, color: Colors.orange),
        _buildFolderItem(Icons.label_outline, 'Social', '8', false, color: Colors.green),
      ],
    );
  }

  Widget _buildFolderItem(IconData icon, String label, String count, bool isActive, {Color? color}) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? AdminColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, size: 18, color: isActive ? AdminColors.primary : (color ?? AdminColors.textMuted)),
        title: Text(label, style: TextStyle(color: isActive ? AdminColors.primary : AdminColors.textSecondary, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        trailing: count.isNotEmpty ? Text(count, style: const TextStyle(color: AdminColors.textMuted, fontSize: 11)) : null,
        onTap: () {},
      ),
    );
  }
}

class _EmailListHeader extends StatelessWidget {
  const _EmailListHeader();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AdminColors.divider))),
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (v) {}),
          const SizedBox(width: 8),
          const Icon(Icons.refresh, size: 18, color: AdminColors.textMuted),
          const Spacer(),
          const Text('1 - 50 of 1,254', style: TextStyle(color: AdminColors.textMuted, fontSize: 11)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_left, size: 18, color: AdminColors.textMuted),
          const Icon(Icons.chevron_right, size: 18, color: AdminColors.textMuted),
        ],
      ),
    );
  }
}

class _EmailListView extends StatelessWidget {
  const _EmailListView();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildEmailItem('Larkon Theme', 'Welcome to Larkon!', 'We are excited to have you on board. Start exploring...', '09:40 am', true),
        _buildEmailItem('GitHub', 'New sign-in to your account', 'We noticed a new sign-in to your account from Linux...', '08:30 am', false),
        _buildEmailItem('Stripe', 'Your payout is scheduled', 'A payout of \$737.00 is scheduled for tomorrow...', 'Yesterday', false),
        _buildEmailItem('Figma', 'New comments on Larkon UI', 'John Doe commented on the dashboard view...', 'Yesterday', false),
        _buildEmailItem('Google Cloud', 'Monthly usage report', 'Your usage report for April 2024 is now available...', '2 days ago', false),
      ],
    );
  }

  Widget _buildEmailItem(String sender, String subject, String snippet, String time, bool isUnread) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AdminColors.divider))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(value: false, onChanged: (v) {}),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(sender, style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.w600, fontSize: 13)),
                    Text(time, style: const TextStyle(color: AdminColors.textMuted, fontSize: 10)),
                  ],
                ),
                Text(subject, style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal, color: isUnread ? AdminColors.textPrimary : AdminColors.textSecondary, fontSize: 13)),
                Text(snippet, style: const TextStyle(color: AdminColors.textMuted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailContentView extends StatelessWidget {
  const _EmailContentView();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome to Larkon!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          const Row(
            children: [
              CircleAvatar(radius: 20, backgroundColor: AdminColors.primary, child: Text('L', style: TextStyle(color: Colors.white))),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Larkon Theme', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('to: me <hello@larkon.com>', style: TextStyle(color: AdminColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
              Text('09:40 am (10 hours ago)', style: TextStyle(color: AdminColors.textMuted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Hi there,\n\nWe are excited to have you on board with Larkon! You can now start managing your store with ease.\n\nOur dashboard provides real-time insights into your sales, inventory, and customer activity. If you have any questions, feel free to reach out to our support team.\n\nBest regards,\nThe Larkon Team',
            style: TextStyle(color: AdminColors.textSecondary, fontSize: 14, height: 1.6),
          ),
          const Spacer(),
          const Divider(color: AdminColors.divider),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.reply, size: 16), label: const Text('Reply')),
              const SizedBox(width: 12),
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.forward, size: 16), label: const Text('Forward')),
            ],
          ),
        ],
      ),
    );
  }
}
