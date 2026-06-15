import 'package:flutter/material.dart';

import '../core/theme.dart';

class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({super.key, required this.role});

  Color _getColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return AppColors.darkRed;
      case 'owner':
        return AppColors.lavender;
      case 'instructor':
        return Colors.blue;
      case 'participant':
        return AppColors.deepGreen;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(role);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}