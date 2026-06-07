import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/dto/responses/notification_response_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:core/services/providers/notification_service.dart';

import '../core/theme.dart';
import '../widgets/notification_card.dart';

class UserNotificationCenter extends StatefulWidget {
  const UserNotificationCenter({super.key});

  @override
  State<UserNotificationCenter> createState() =>
      _UserNotificationCenterState();
}

class _UserNotificationCenterState extends State<UserNotificationCenter> {
  Future<List<NotificationResponseDto>>? _future;
  UserResponseDto? user;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authUser = context.read<AuthProvider>().user;

      if (authUser == null) return;

      setState(() {
        user = authUser;
        _future = context
            .read<NotificationProvider>()
            .repository
            .getByUserId(authUser.id);
      });
    });
  }

  void _reload() {
    if (user == null) return;

    setState(() {
      _future = context
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          )
        ],
      ),
      body: _future == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<NotificationResponseDto>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Failed to load notifications"),
            );
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(
              child: Text("No notifications yet"),
            );
          }

          final unread =
          notifications.where((n) => !n.isRead).toList();
          final read =
          notifications.where((n) => n.isRead).toList();

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (unread.isNotEmpty) ...[
                  _sectionTitle("Unread", unread.length),
                  const SizedBox(height: 10),
                  ...unread.map((n) => NotificationCard(
                    notification: n,
                    onMarkRead: () async {
                      await context
                          .read<NotificationProvider>()
                          .repository
                          .toggleReadNotification(n.id, user!.id);

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
                                    .deleteNotification(n.id, user!.id);
                                _reload();
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
                  )),
                  const SizedBox(height: 20),
                ],

                if (read.isNotEmpty) ...[
                  _sectionTitle("Read", read.length),
                  const SizedBox(height: 10),
                  ...read.map((n) => Opacity(
                    opacity: 0.6,
                    child: NotificationCard(
                      notification: n,
                      onMarkRead: () async {
                        await context
                            .read<NotificationProvider>()
                            .repository
                            .toggleReadNotification(n.id, user!.id);

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
                                      .deleteNotification(n.id, user!.id);
                                  _reload();
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
                  )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title, int count) {
    return Text(
      "$title ($count)",
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}