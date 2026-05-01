import 'package:core/services/providers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:core/core/quotes.dart';

import '../core/theme.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    final now = DateTime.now();
    final quoteIndex = (now.day % AppQuotes.dailyQuotes.length);
    final todaysQuote =
    AppQuotes.dailyQuotes[quoteIndex];

    String getDayWithSuffix(int day) {
      if (day >= 11 && day <= 13) return '${day}th';
      switch (day % 10) {
        case 1:
          return '${day}st';
        case 2:
          return '${day}nd';
        case 3:
          return '${day}rd';
        default:
          return '${day}th';
      }
    }

    final formattedDate =
        "${DateFormat('EEEE').format(now)}, ${getDayWithSuffix(now.day)} ${DateFormat('MMMM').format(now)}";

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LOGO
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: 70,
              ),
            ),

            const SizedBox(height: 24),

            // WELCOME
            Text(
              "Welcome back, ${user.firstName} 🌿",
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 12),

            Text(
              formattedDate,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 12),


            // MEDITATION IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/meditation.png',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            //QUOTE
            Text(
              "“$todaysQuote”",
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 28),

            Text(
              "Upcoming classes",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.deepGreen,
              ),
            ),

            const SizedBox(height: 28),

          ],
        ),
      ),
    );
  }
}
