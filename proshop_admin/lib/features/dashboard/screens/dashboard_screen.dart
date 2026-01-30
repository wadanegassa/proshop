import 'package:flutter/material.dart';
import '../../../core/constants/admin_colors.dart';

import '../widgets/performance_chart.dart';
import '../widgets/conversions_gauge.dart';
import '../widgets/sessions_by_country.dart';
import '../widgets/top_pages_table.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Banner
          // Alert Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF422C2C), // Brownish dark background
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF633636)),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Color(0xFFE56A6A), size: 20),
                SizedBox(width: 12),
                Text(
                  'We regret to inform you that our server is currently experiencing technical difficulties.',
                  style: TextStyle(color: Color(0xFFE56A6A), fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // KPI Grid
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.8,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              _KPICard(
                title: 'Total Orders',
                value: '13,647',
                trend: '+ 2.3% Last Week',
                isPositive: true,
                icon: Icons.shopping_basket_outlined,
                color: AdminColors.primary,
              ),
              _KPICard(
                title: 'New Leads',
                value: '9,526',
                trend: '+ 8.1% Last Month',
                isPositive: true,
                icon: Icons.lightbulb_outline,
                color: AdminColors.primary,
              ),
              _KPICard(
                title: 'Deals',
                value: '976',
                trend: '- 0.3% Last Month',
                isPositive: false,
                icon: Icons.local_offer_outlined,
                color: AdminColors.primary,
              ),
              _KPICard(
                title: 'Booked Revenue',
                value: r'$123.6k',
                trend: '+ 10.6% Last Month',
                isPositive: true,
                icon: Icons.attach_money_rounded,
                color: AdminColors.primary,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Row 1: Main Charts
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _DashContainer(
                  title: 'Performance Analytics',
                  child: SizedBox(height: 400, child: PerformanceChart()),
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _DashContainer(
                  title: 'Conversion Breakdown',
                  child: SizedBox(height: 400, child: ConversionsGauge()),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Row 2: Tables & Geography
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DashContainer(
                  title: 'Active Sessions by Country',
                  child: SizedBox(height: 400, child: SessionsByCountry()),
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _DashContainer(
                  title: 'Top Performing Pages',
                  child: SizedBox(height: 400, child: TopPagesTable()),
                ),
              ),
            ],
          ),
        ],
      ),
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
        borderRadius: BorderRadius.circular(4), // Less rounded
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF332A25), // Dark orange/brown background
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AdminColors.primary, size: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: AdminColors.textMuted, fontSize: 13, fontWeight: FontWeight.normal),
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
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                size: 20,
                color: isPositive ? AdminColors.success : AdminColors.error,
              ),
              Text(
                trend,
                style: TextStyle(
                  color: isPositive ? AdminColors.success : AdminColors.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!trend.contains('Last')) ...[ // Fallback if trend string is short
                 const SizedBox(width: 4),
                 const Text(
                  'Last Month',
                  style: TextStyle(color: AdminColors.textMuted, fontSize: 11),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
