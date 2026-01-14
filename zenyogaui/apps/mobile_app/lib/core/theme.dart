

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const lavender = Color(0xFF896082);
  static const deepGreen = Color(0xFF26462E);
  static const darkRed = Color(0xFF660000);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.deepGreen,
  scaffoldBackgroundColor: Colors.white,
  dataTableTheme: DataTableThemeData(
    headingRowColor: MaterialStateProperty.all(
        AppColors.lavender,
    ),
    headingTextStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    dataRowColor: MaterialStateProperty.resolveWith(
          (states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.lavender.withOpacity(0.15);
        }
        return Colors.grey.shade50;
      },
    ),
    dataTextStyle: const TextStyle(
      color: Colors.black54,
      fontSize: 14,
      fontWeight: FontWeight.w500
    ),
    dividerThickness: 0.6,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.lavender,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      padding: EdgeInsets.symmetric(vertical: 14),
    ),
  ),
);