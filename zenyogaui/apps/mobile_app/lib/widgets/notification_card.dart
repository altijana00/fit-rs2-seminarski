import 'package:core/dto/responses/notification_response_dto.dart';
import 'package:flutter/material.dart';

import '../core/theme.dart';

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
      elevation: notification.isRead ? 1 : 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onMarkRead,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ICON + UNREAD DOT
              Stack(
                children: [
                  Icon(_getIcon(), color: color, size: 26),

                  if (!notification.isRead)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12),

              /// CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: notification.isRead
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 6),

                    if (notification.content != null)
                      Text(
                        notification.content!,
                        style: TextStyle(
                          fontSize: 13,
                          color: notification.isRead
                              ? Colors.grey
                              : Colors.black87,
                        ),
                      ),

                    const SizedBox(height: 8),

                    Text(
                      _formatDate(notification.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),


              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'read') onMarkRead?.call();
                  if (value == 'delete') onDelete?.call();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'read',
                    child: Text(notification.isRead
                        ? "Mark as unread"
                        : "Mark as read"),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}.${date.month}.${date.year}";
  }
}