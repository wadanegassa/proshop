import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/admin_colors.dart';

class ConversionsGauge extends StatelessWidget {
  const ConversionsGauge({super.key});

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
            'Conversions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Center(
            child: SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(180, 180),
                    painter: _GaugePainter(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '65.2%',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Returning Customer',
                        style: TextStyle(fontSize: 10, color: AdminColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MetricItem(label: 'This Week', value: '23.5k'),
              _MetricItem(label: 'Last Week', value: '41.05k'),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminColors.divider.withValues(alpha: 0.1),
              foregroundColor: AdminColors.textPrimary,
              elevation: 0,
            ),
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 12.0;

    final bgPaint = Paint()
      ..color = AdminColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = AdminColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Background track (semi-circle)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth),
      math.pi * 0.8,
      math.pi * 1.4,
      false,
      bgPaint,
    );

    // Progress (65.2%)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth),
      math.pi * 0.8,
      math.pi * 1.4 * 0.652,
      false,
      progressPaint,
    );

    // Draw small ticks
    final tickPaint = Paint()
      ..color = AdminColors.divider
      ..strokeWidth = 2;

    for (var i = 0; i < 30; i++) {
        final angle = math.pi * 0.8 + (math.pi * 1.4 * i / 29);
        final startX = center.dx + (radius - 25) * math.cos(angle);
        final startY = center.dy + (radius - 25) * math.sin(angle);
        final endX = center.dx + (radius - 35) * math.cos(angle);
        final endY = center.dy + (radius - 35) * math.sin(angle);
        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
