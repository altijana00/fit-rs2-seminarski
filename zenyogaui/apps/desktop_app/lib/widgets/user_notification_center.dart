import 'package:core/dto/responses/notification_response_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:core/services/providers/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenyogaui/core/theme.dart';

import 'notification_card.dart';

class UserNotificationCenter extends StatefulWidget {
  const UserNotificationCenter({super.key});

  @override
  State<UserNotificationCenter> createState() => _UserNotificationCenterState();
}

class _UserNotificationCenterState extends State<UserNotificationCenter> {
  late Future<List<NotificationResponseDto>> _notificationsFuture;
  UserResponseDto? user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (user == null) {
      user = context.read<AuthProvider>().user;

      _notificationsFuture = context
          .read<NotificationProvider>()
          .repository
          .getByUserId(user!.id);
    }
  }

  Future<void> _reload() async {
    setState(() {
      _notificationsFuture = context
          .read<NotificationProvider>()
          .repository
          .getByUserId(user!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: AppColors.lavender,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<List<NotificationResponseDto>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading notifications",
                style: TextStyle(color: AppColors.darkRed),
              ),
            );
          }

          final notifications = snapshot.data ?? [];

          final unreadNotifications = notifications
              .where((n) => !n.isRead)
              .toList();

          final readNotifications = notifications
              .where((n) => n.isRead)
              .toList();

          if (notifications.isEmpty) {
            return const Center(
              child: Text("No notifications yet"),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                if (unreadNotifications.isNotEmpty) ...[
                  Text(
                    "Unread (${unreadNotifications.length})",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...unreadNotifications.map(
                        (notification) => NotificationCard(
                      notification: notification,
                          onMarkRead: () async {
                            await context
                                .read<NotificationProvider>()
                                 .repository
                                .toggleReadNotification(notification.id, user!.id);

                             _reload();
                          },
                          onDelete: () async {
                            await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Delete notification"),
                                content: Text(
                                  "Are you sure you want to delete notification?",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(ctx);
                                      await context
                                          .read<NotificationProvider>()
                                          .repository
                                          .deleteNotification(notification.id, user!.id);
                                      await _reload();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Notification deleted successfully"),
                                          backgroundColor: AppColors.deepGreen,
                                        ),
                                      );

                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                          },
                    ),
                  ),

                  const SizedBox(height: 24),
                ],

                if (readNotifications.isNotEmpty) ...[
                  Text(
                    "Read (${readNotifications.length})",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...readNotifications.map(
                        (notification) => NotificationCard(
                      notification: notification,
                          onMarkRead: () async {
                             await context
                                .read<NotificationProvider>()
                                .repository
                                .toggleReadNotification(notification.id, user!.id);

                             _reload();
                          },
                          onDelete: () async {
                            await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Delete notification"),
                                content: Text(
                                  "Are you sure you want to delete notification?",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(ctx);
                                      await context
                                          .read<NotificationProvider>()
                                          .repository
                                          .deleteNotification(notification.id, user!.id);
                                      await _reload();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Notification deleted successfully"),
                                          backgroundColor: AppColors.deepGreen,
                                        ),
                                      );

                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                          },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}