import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import 'home_tab.dart';
import 'my_classes_tab.dart';
import 'profile_tab.dart';
import 'studios_tab.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: NavigationWidget(
        selectedIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}



