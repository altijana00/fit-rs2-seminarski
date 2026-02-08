import 'package:flutter/material.dart';

class NavigationWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const NavigationWidget({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Studios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'My Classes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),

      ],
    );
  }
}
