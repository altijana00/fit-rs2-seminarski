import 'package:core/dto/responses/notification_response_dto.dart';
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

  @override
  void initState() {
    super.initState();

    _notificationsFuture = context
        .read<NotificationProvider>()
        .repository
        .getAllNotifications();
  }

  Future<void> _reload() async {
    setState(() {
      _notificationsFuture = context
          .read<NotificationProvider>()
          .repository
          .getAllNotifications();
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

          if (notifications.isEmpty) {
            return const Center(
              child: Text("No notifications yet"),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];

                return NotificationCard(
                  notification: n,
                  onMarkRead: () async {
                    // await context
                    //     .read<NotificationProvider>()
                    //     .repository
                    //     .markAsRead(n.id);
                    //
                    // _reload();
                  },
                  onDelete: () async {
                    // await context
                    //     .read<NotificationProvider>()
                    //     .repository
                    //     .deleteNotification(n.id);
                    //
                    // _reload();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}