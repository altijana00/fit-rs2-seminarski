import 'package:core/services/providers/city_service.dart';
import 'package:core/services/providers/role_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/centered_card_layout.dart';
import '../widgets/signup_form.dart';

class DesktopSignupScreen extends StatelessWidget {
  const DesktopSignupScreen({super.key});

  Future<Map<String, dynamic>> _loadData(BuildContext context) async {
    final cityProvider = context.read<CityProvider>();
    final roleProvider = context.read<RoleProvider>();

    final cities = await cityProvider.repository.getAllCities();
    final roles = await roleProvider.repository.getAllRoles();

    return {
      'cities': cities,
      'roles': roles,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Failed to load data"));
          }

          final cities = snapshot.data!['cities'];
          final roles = snapshot.data!['roles'];

          return CenteredCardLayout(
            backgroundAsset: 'assets/login-back.png',
            child: SignupForm(
              cities: cities,
              roles: roles,
            ),
          );
        },
      ),
    );
  }
}
