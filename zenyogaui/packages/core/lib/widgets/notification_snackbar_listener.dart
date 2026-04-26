import 'package:core/services/providers/realtime_notification_provider.dart';
import 'package:core/services/signalr_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationSnackbarListener extends StatefulWidget {
  final Widget child;
  const NotificationSnackbarListener({super.key, required this.child});

  @override
  State<NotificationSnackbarListener> createState() =>
      _NotificationSnackbarListenerState();
}

class _NotificationSnackbarListenerState
    extends State<NotificationSnackbarListener> {
  AppNotification? _lastShown;

  @override
  Widget build(BuildContext context) {
    final latest = context.select<RealtimeNotificationProvider, AppNotification?>(
          (p) => p.latest,
    );

    if (latest != null && latest != _lastShown) {
      _lastShown = latest;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSnackbar(context, latest);
      });
    }

    return widget.child;
  }

  void _showSnackbar(BuildContext context, AppNotification n) {
    final (color, icon) = switch (n.type) {
      'Success' => (Colors.green.shade700,  Icons.check_circle_outline),
      'Warning' => (Colors.orange.shade700, Icons.warning_amber_outlined),
      'Error'   => (Colors.red.shade700,    Icons.error_outline),
      _         => (Colors.blueGrey.shade700, Icons.info_outline),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(n.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(n.message,
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}