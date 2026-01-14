import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenyogaui/widgets/statistics_screen_view.dart';
import 'package:zenyogaui/widgets/studios_table_source.dart';
import 'package:zenyogaui/widgets/users_table_source.dart';

import '../core/theme.dart';

//import '../../../../shared/dto/responses/user_response_dto.dart';



class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  // Screens for each section
  final List<Widget> _screens = [
    UsersTableView(),
    StudiosTableView(),
    StatisticsScreenView(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserResponseDto;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text("Users"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.home_work),
                label: Text("Studios"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart),
                label: Text("Statistics"),
              ),

            ],


          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthProvider>().logout();

              if (!context.mounted) return;

              Navigator.of(context).pushNamedAndRemoveUntil(
                '/',
                    (_) => false,
              );
            },
            child: const Text("Logout"),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This expands to fill the remaining space
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome, ${user.firstName} ${user.lastName}!",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: _screens[_selectedIndex],
                    ),
                  ],
                ),
              )),

        ],
      ),
    );
  }
}



