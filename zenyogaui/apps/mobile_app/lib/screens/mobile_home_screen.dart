
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/profile_tab.dart';
import 'package:mobile_app/screens/studios_tab.dart';
import 'package:mobile_app/screens/user_notification_center.dart';

import '../widgets/navigation.dart';
import 'home_tab.dart';
import 'my_classes_tab.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  late final List<Widget> _tabs = const [
    HomeTab(),
    StudiosTab(),
    MyClassesTab(),
    ProfileTab(),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              }
          ),
        ],
      ),

      body: _tabs[_selectedIndex],

      bottomNavigationBar: NavigationWidget(
        selectedIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}