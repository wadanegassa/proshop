import 'package:flutter/material.dart';
import '../../../core/constants/admin_colors.dart';

class SessionsByCountry extends StatelessWidget {
  const SessionsByCountry({super.key});

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
          const Text(
            'Sessions by Country',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AdminColors.divider.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.public,
                            size: 180,
                            color: AdminColors.divider.withValues(alpha: 0.5),
                          ),
                        ),
                        _buildMarker(context, 0.2, 0.4, 'Canada'),
                        _buildMarker(context, 0.4, 0.5, 'USA'),
                        _buildMarker(context, 0.6, 0.7, 'Brazil'),
                        _buildMarker(context, 0.2, 0.6, 'Russia'),
                        _buildMarker(context, 0.4, 0.8, 'China'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCountryStat('United States', 85, '82%'),
                      _buildCountryStat('Canada', 65, '70%'),
                      _buildCountryStat('Brazil', 45, '60%'),
                      _buildCountryStat('Russia', 35, '45%'),
                      _buildCountryStat('China', 55, '55%'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MetricItem(label: 'Total Sessions', value: '45.8k'),
              _MetricItem(label: 'Avg. Duration', value: '12m 45s'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountryStat(String name, int percent, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 12, color: AdminColors.textSecondary)),
              Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: AdminColors.divider,
              color: AdminColors.primary,
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarker(BuildContext context, double top, double left, String name) {
    return Positioned(
      top: 150 * top,
      left: 200 * left,
      child: Tooltip(
        message: name,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AdminColors.primary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  const _MetricItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AdminColors.textMuted, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
