import 'package:core/dto/responses/notification_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:zenyogaui/core/theme.dart';

class NotificationCard extends StatelessWidget {
  final NotificationResponseDto notification;
  final VoidCallback? onMarkRead;
  final VoidCallback? onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onMarkRead,
    this.onDelete,
  });

  Color _getColor() {
    switch (notification.type) {
      case "success":
        return Colors.green;
      case "warning":
        return Colors.orange;
      case "error":
        return AppColors.darkRed;
      default:
        return Colors.blue;
    }
  }

  IconData _getIcon() {
    switch (notification.type) {
      case "success":
        return Icons.check_circle;
      case "warning":
        return Icons.warning;
      case "error":
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Card(
      elevation: notification.isRead ? 1 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 5)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_getIcon(), color: color, size: 28),
            const SizedBox(width: 12),

            /// TEXT CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: notification.isRead
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.content!,
                    style: TextStyle(
                      color: notification.isRead
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// DATE
                  Text(
                    _formatDate(notification.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            /// ACTIONS
            Column(
              children: [
                IconButton(
                  tooltip: "Mark as read",
                  icon: Icon(
                    notification.isRead
                        ? Icons.mark_email_read
                        : Icons.mark_email_unread,
                    color: Colors.indigo,
                  ),
                  onPressed: onMarkRead,
                ),
                IconButton(
                  tooltip: "Delete",
                  icon: const Icon(Icons.delete, color: AppColors.darkRed),
                  onPressed: onDelete,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}.${date.month}.${date.year}";
  }
}