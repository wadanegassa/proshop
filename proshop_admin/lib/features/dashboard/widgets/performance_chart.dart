import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/admin_colors.dart';

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({super.key});

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
                'Performance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _PeriodButton(label: 'ALL', isActive: false),
                  _PeriodButton(label: '1M', isActive: true),
                  _PeriodButton(label: '6M', isActive: false),
                  _PeriodButton(label: '1Y', isActive: false),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Stack(
              children: [
                BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 80,
                    barTouchData: BarTouchData(enabled: false), // Disable bar touch to allow line touch if needed, or handle complex
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                            if (value.toInt() < days.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  days[value.toInt()],
                                  style: const TextStyle(color: AdminColors.textMuted, fontSize: 10),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(color: AdminColors.textMuted, fontSize: 10),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: AdminColors.divider,
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(12, (i) {
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: (i % 2 == 0) ? 40.0 + (i * 2) : 60.0 - (i * 2), // Mock data
                            color: AdminColors.primary,
                            width: 12,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                LineChart(
                  LineChartData(
                    maxY: 80,
                    minY: 0,
                    lineTouchData: LineTouchData(enabled: false),
                    titlesData: const FlTitlesData(show: false),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(12, (i) {
                          return FlSpot(i.toDouble(), (i % 2 != 0) ? 20.0 + (i * 3) : 35.0 - (i * 1)); // Mock line data
                        }),
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(color: AdminColors.primary, label: 'Page Views'),
              const SizedBox(width: 24),
              _LegendItem(color: Colors.green, label: 'Clicks'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isActive;
  const _PeriodButton({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AdminColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: isActive ? AdminColors.primary : AdminColors.divider),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? AdminColors.primary : AdminColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}
