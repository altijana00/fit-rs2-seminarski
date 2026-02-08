import 'package:flutter/material.dart';
import '../../../widgets/centered_card_layout.dart';
import '../widgets/login_form.dart';

class DesktopLoginScreen extends StatelessWidget {
  const DesktopLoginScreen({super.key});

  void _navigateByRole(BuildContext context, String role) {
    if (role == '2') {
      Navigator.pushReplacementNamed(context, '/ownerDashboard');
    } else if (role == '3') {
      Navigator.pushReplacementNamed(context, '/instructorDashboard');
    } else if (role=='1') {
      Navigator.pushReplacementNamed(context, '/adminDashboard');
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