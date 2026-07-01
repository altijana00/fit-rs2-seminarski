import 'package:flutter/material.dart';
import 'package:zenyogaui/core/app_roles.dart';
import '../../../widgets/centered_card_layout.dart';
import '../widgets/login_form.dart';

class DesktopLoginScreen extends StatelessWidget {
  const DesktopLoginScreen({super.key});

  void _navigateByRole(BuildContext context, String role) {
    if (role == AppRole.owner.toString()) {
      Navigator.pushReplacementNamed(context, '/ownerDashboard');
    } else if (role == AppRole.instructor.toString()) {
      Navigator.pushReplacementNamed(context, '/instructorDashboard');
    } else if (role == AppRole.admin.toString()) {
      Navigator.pushReplacementNamed(context, '/adminDashboard');
    } else if (role == AppRole.participant.toString()) {
      Navigator.pushReplacementNamed(context, '/general');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CenteredCardLayout(
        backgroundAsset: 'assets/login-back.png',
        child: LoginForm(onLoginSuccess: (role) => _navigateByRole(context, role)),
      ),
    );
  }
}