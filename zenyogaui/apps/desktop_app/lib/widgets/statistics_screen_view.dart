import 'package:core/services/providers/app_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/kpi_card.dart';

class StatisticsScreenView extends StatefulWidget {
  const StatisticsScreenView({super.key});

  @override
  State<StatisticsScreenView> createState() => _StatisticsScreenViewState();
}

class _StatisticsScreenViewState extends State<StatisticsScreenView> {

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppAnalyticsProvider>().repository.getAppAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAnalyticsProvider>(
      builder: (context, provider, _) {

        if (provider.error != null) {
          return Center(
            child: Text(
              provider.error!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final analytics = provider.appAnalytics;
        if (analytics == null) {
          return const Center(child: Text("No analytics data available"));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "App Overview",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  KpiCard(
                    title: "Total Users",
                    value: analytics.totalUsers.toString(),
                    icon: Icons.person,
                    color: Colors.blue,
                  ),
                  KpiCard(
                    title: "Total Studios",
                    value: analytics.totalStudios.toString(),
                    icon: Icons.home_work,
                    color: Colors.deepPurple,
                  ),

                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
