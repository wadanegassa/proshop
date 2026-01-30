import 'package:flutter/material.dart';
import '../../../core/constants/admin_colors.dart';

class TopPagesTable extends StatelessWidget {
  const TopPagesTable({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Pages',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All', style: TextStyle(color: AdminColors.primary, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 3, child: Text('Page Path', style: TextStyle(color: AdminColors.textMuted, fontSize: 11))),
                Expanded(child: Text('Page Views', textAlign: TextAlign.right, style: TextStyle(color: AdminColors.textMuted, fontSize: 11))),
                Expanded(child: Text('Exit Rate', textAlign: TextAlign.center, style: TextStyle(color: AdminColors.textMuted, fontSize: 11))),
              ],
            ),
          ),
          const Divider(color: AdminColors.divider, height: 1),
          Expanded(
            child: ListView(
              children: [
                _buildRow('larkon/ecommerce.html', '12,548', '4.4%', Colors.green, '45s'),
                _buildRow('larkon/dashboard.html', '8,426', '20.4%', Colors.red, '2m 10s'),
                _buildRow('larkon/chat.html', '5,254', '12.25%', Colors.orange, '5m 30s'),
                _buildRow('larkon/auth-login.html', '3,369', '5.2%', Colors.green, '15s'),
                _buildRow('larkon/email.html', '2,985', '64.2%', Colors.red, '1m 20s'),
                _buildRow('larkon/profile.html', '1,420', '8.5%', Colors.green, '3m 45s'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String path, String views, String exitRate, Color rateColor, String avgTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  path,
                  style: const TextStyle(color: AdminColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Avg. Time: $avgTime',
                  style: const TextStyle(color: AdminColors.textMuted, fontSize: 10),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              views,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: rateColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                exitRate,
                textAlign: TextAlign.center,
                style: TextStyle(color: rateColor, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
