import 'package:core/services/providers/auth_service.dart';
import 'package:core/services/providers/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/profile_tab.dart';
import 'package:mobile_app/screens/settings_screen.dart';
import 'package:mobile_app/screens/studios_tab.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../widgets/navigation.dart';
import 'home_tab.dart';
import 'my_classes_tab.dart';

class AppShell extends StatefulWidget {
  final void Function(bool) onThemeChanged;
  const AppShell({super.key, required this.onThemeChanged});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with RouteAware {
  int _selectedIndex = 0;

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() {});
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return "Home";
      case 1:
        return "Studios";
      case 2:
        return "My Classes";
      case 3:
        return "Profile";
      case 4:
        return "Settings";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const HomeTab(),
      const StudiosTab(),
      const MyClassesTab(),
      const ProfileTab(),
      SettingsScreen(onThemeChanged: widget.onThemeChanged),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, _) {
              final authUser = context.read<AuthProvider>().user;

              if (authUser == null) {
                return const SizedBox.shrink();
              }

              return FutureBuilder(
                future: context
                    .read<NotificationProvider>()
                    .repository
                    .getByUserId(authUser.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {
                        Navigator.pushNamed(context, '/notifications');
                        if (mounted) setState(() {});
                      },
                    );
                  }

                  final notifications = snapshot.data!;
                  final unreadCount =
                      notifications.where((n) => !n.isRead).length;

                  return IconButton(
                    icon: Stack(
                      children: [
                        const Icon(Icons.notifications_none),
                        if (unreadCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: NavigationWidget(
        selectedIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
