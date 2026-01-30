import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../providers/analytics_provider.dart';

import '../widgets/performance_chart.dart';
import '../widgets/conversions_gauge.dart';
import '../widgets/sessions_by_country.dart';
import '../widgets/top_pages_table.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AnalyticsProvider>().fetchAnalytics());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = provider.analyticsData;
        final totalSales = data?['totalSales'] ?? 0;
        final totalOrders = data?['totalOrders'] ?? 0;
        final topProducts = data?['topProducts'] as List? ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KPI Grid
              GridView.count(
                crossAxisCount: 2, // 2 for better layout on smaller/web screens
                shrinkWrap: true,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 2.5,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _KPICard(
                    title: 'Total Orders',
                    value: totalOrders.toString(),
                    trend: '+ 0% Last Week',
                    isPositive: true,
                    icon: Icons.shopping_basket_outlined,
                    color: AdminColors.primary,
                  ),
                  _KPICard(
                    title: 'Total Revenue',
                    value: '\$${totalSales.toStringAsFixed(2)}',
                    trend: '+ 0% Last Month',
                    isPositive: true,
                    icon: Icons.attach_money_rounded,
                    color: AdminColors.primary,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Row 1: Main Charts (Simplified for proof of work)
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _DashContainer(
                      title: 'Performance Analytics',
                      child: SizedBox(height: 300, child: PerformanceChart()),
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: _DashContainer(
                      title: 'Conversion Breakdown',
                      child: SizedBox(height: 300, child: ConversionsGauge()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _DashContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AdminColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const Icon(Icons.more_horiz_rounded, color: AdminColors.textMuted),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class _KPICard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final bool isPositive;
  final IconData icon;
  final Color color;

  const _KPICard({
    required this.title,
    required this.value,
    required this.trend,
    required this.isPositive,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF332A25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AdminColors.primary, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(color: AdminColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
