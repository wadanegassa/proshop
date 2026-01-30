import 'package:flutter/material.dart';
import '../../../../core/constants/admin_colors.dart';


class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'CALENDAR',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Create Event'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: MediaQuery.of(context).size.height - 240,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left - Mini Calendar and Upcoming Events
              const SizedBox(
                width: 280,
                child: Column(
                  children: [
                    _MiniCalendar(),
                    SizedBox(height: 24),
                    _UpcomingEvents(),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Main - Calendar Grid
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AdminColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AdminColors.divider),
                  ),
                  child: const Column(
                    children: [
                      _CalendarHeader(),
                      SizedBox(height: 24),
                      Expanded(child: _CalendarGrid()),
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

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('April 2024', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
            IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: () {}, child: const Text('Month')),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: () {}, child: const Text('Week')),
          ],
        ),
      ],
    );
  }
}

class _MiniCalendar extends StatelessWidget {
  const _MiniCalendar();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AdminColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AdminColors.divider)),
      child: const Text('Mini Calendar Placeholder', style: TextStyle(color: AdminColors.textMuted)),
    );
  }
}

class _UpcomingEvents extends StatelessWidget {
  const _UpcomingEvents();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AdminColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AdminColors.divider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Upcoming Events', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildEvent('Team Meeting', '10:00 AM', Colors.blue),
          _buildEvent('Product Launch', '02:00 PM', Colors.green),
          _buildEvent('Client Review', '04:30 PM', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildEvent(String title, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(width: 4, height: 32, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text(time, style: const TextStyle(color: AdminColors.textMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.2,
      ),
      itemCount: 35,
      itemBuilder: (context, index) {
        final day = index - 3;
        final isToday = day == 23;
        return Container(
          decoration: BoxDecoration(border: Border.all(color: AdminColors.divider, width: 0.2)),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (day > 0 && day <= 30)
                Text(day.toString(), style: TextStyle(color: isToday ? AdminColors.primary : AdminColors.textPrimary, fontWeight: isToday ? FontWeight.bold : FontWeight.normal)),
              if (isToday)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: AdminColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Dev Sync', style: TextStyle(color: AdminColors.primary, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        );
      },
    );
  }
}
