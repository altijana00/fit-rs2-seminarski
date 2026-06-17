import 'package:core/services/providers/app_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:core/core/quotes.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:zenyogaui/widgets/kpi_card.dart';
import '../core/theme.dart';


class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Future _analyticsFuture;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final analyticsProvider = context.read<AppAnalyticsProvider>();

      _analyticsFuture =
          analyticsProvider.repository.getAppAnalyticsForParticipant();

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    final now = DateTime.now();
    final quoteIndex = now.day % AppQuotes.dailyQuotes.length;
    final todaysQuote = AppQuotes.dailyQuotes[quoteIndex];

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
            Center(
              child: Image.asset('assets/logo.png', height: 70),
            ),

            const SizedBox(height: 24),

            Text(
              "Welcome back, ${user.firstName} 🌿",
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 12),

            Text(
              formattedDate,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[600]),
            ),

            const SizedBox(height: 12),

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

            Text(
              "“$todaysQuote”",
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 28),

            Text(
              "Your Overview",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.deepGreen,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            FutureBuilder(
              future: _analyticsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                final data = snapshot.data;

                if (data == null) {
                  return const Text("No analytics data");
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth < 400 ? 1 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: constraints.maxWidth < 400 ? 3.5 : 3,
                      ),
                      children: [
                        KpiCard(
                          title: "Total Classes Joined",
                          value: data.numberOfClasses?.toString() ?? "0",
                          icon: Icons.menu_book,
                          color: Colors.orange,
                        ),
                        KpiCard(
                          title: "Member of Studios",
                          value: data.numberOfStudios?.toString() ?? "0",
                          icon: Icons.home_work,
                          color: Colors.deepPurple,
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}