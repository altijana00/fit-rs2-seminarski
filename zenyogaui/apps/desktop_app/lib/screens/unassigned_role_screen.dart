import 'package:flutter/material.dart';

import '../core/theme.dart';

class UnassignedRoleScreen extends StatelessWidget {
  const UnassignedRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Image.asset(
                'assets/logo.png',
                height: 64,
              ),
            ),
            const Text(
              "Welcome to Zen&Yoga. Please be patient until an app admin assigns you your role.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.lavender,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/');
              },
              child: const Text(
                'Log out ->',
                style: TextStyle(
                  color: AppColors.deepGreen,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}