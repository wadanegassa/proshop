import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/notification_model.dart';
import '../../../providers/notification_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/design_background.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      context.read<NotificationProvider>().fetchNotifications()
    );
  }

  Future<void> _onRefresh() async {
    await context.read<NotificationProvider>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DesignBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 40, width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.chevron_left, color: Colors.white),
                      ),
                    ),
                    Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Clear All Button
                    IconButton(
                      icon: const Icon(Icons.done_all, color: AppColors.primary),
                      onPressed: () {
                         context.read<NotificationProvider>().markAllAsRead();
                      },
                      tooltip: 'Mark all as read',
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: AppColors.primary,
                  child: Consumer<NotificationProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (provider.notifications.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.notifications_off_outlined, 
                                size: 80, color: AppColors.textMuted.withOpacity(0.5)),
                              const SizedBox(height: 16),
                              const Text(
                                'No notifications yet',
                                style: TextStyle(color: AppColors.textMuted, fontSize: 18),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: provider.notifications.length,
                        separatorBuilder: (ctx, i) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final notification = provider.notifications[index];
                          return _buildNotificationItem(context, notification, provider);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, NotificationModel notification, NotificationProvider provider) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        provider.deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted')),
        );
      },
      child: GestureDetector(
        onTap: () {
          if (!notification.read) {
            provider.markAsRead(notification.id);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.read 
                ? AppColors.surface.withOpacity(0.6) 
                : AppColors.surface,
            borderRadius: BorderRadius.circular(15),
            border: !notification.read 
                ? Border.all(color: AppColors.primary, width: 1.5)
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForType(notification.type),
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          _formatDate(notification.createdAt),
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.message,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'order': return Icons.local_shipping;
      case 'alert': return Icons.error_outline;
      case 'user': return Icons.person;
      default: return Icons.notifications;
    }
  }

  String _formatDate(DateTime date) {
    // Simple date formatting helper
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
