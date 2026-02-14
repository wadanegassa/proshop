import 'package:flutter/material.dart';

/// Reusable dialog for displaying connection errors with actionable guidance
class ConnectionErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onOpenSettings;
  final bool showSettings;

  const ConnectionErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.onOpenSettings,
    this.showSettings = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.cloud_off,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      actions: [
        if (showSettings && onOpenSettings != null)
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              onOpenSettings!();
            },
            icon: const Icon(Icons.settings),
            label: const Text('Settings'),
          ),
        if (onRetry != null)
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry!();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Dismiss'),
        ),
      ],
    );
  }

  /// Show the connection error dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onRetry,
    VoidCallback? onOpenSettings,
    bool showSettings = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConnectionErrorDialog(
        title: title,
        message: message,
        onRetry: onRetry,
        onOpenSettings: onOpenSettings,
        showSettings: showSettings,
      ),
    );
  }
}
