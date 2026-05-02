import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:core/dto/responses/participants_by_city.dart';
import 'package:core/services/providers/app_analytics_service.dart';
import 'package:core/services/providers/studio_service.dart';
import 'package:core/services/providers/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:zenyogaui/core/theme.dart';
import '../widgets/kpi_card.dart';
import 'bar_chart.dart';

class StatisticsScreenView extends StatefulWidget {
  const StatisticsScreenView({super.key});

  @override
  State<StatisticsScreenView> createState() => _StatisticsScreenViewState();
}

class _StatisticsScreenViewState extends State<StatisticsScreenView> {
  late Future<List<ParticipantsByCity>> _citiesFuture;
  bool _isInitialized = false;
  final GlobalKey _barChartKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final studioProvider = context.read<StudioProvider>();

      _citiesFuture = studioProvider.repository.getMostPopularStudioCities();

      context.read<AppAnalyticsProvider>().repository.getAppAnalytics();

      _isInitialized = true;
    }
  }

  Future<Uint8List> captureWidget(GlobalKey key) async {
    final boundary =
    key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  Future<void> _downloadPdf() async {
    final analytics = context.read<AppAnalyticsProvider>().appAnalytics;

    if (analytics == null) return;

    // ensure widget is rendered before capture
    await Future.delayed(const Duration(milliseconds: 300));

    final barChartImage = await captureWidget(_barChartKey);

    final pdfBytes = await PdfService.generateReport(
      totalUsers: analytics.totalUsers!,
      totalStudios: analytics.totalStudios!,
      barChartImage: barChartImage,
    );

    await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
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

              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("Download PDF"),
                onPressed: _downloadPdf,
              ),

              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3,
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

              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  FutureBuilder<List<ParticipantsByCity>>(
                    future: _citiesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No data available");
                      }

                      final list = snapshot.data!;

                      final labels =
                      list.map((e) => e.cityName).toList();

                      final values = list
                          .map((e) => e.numberOfParticipants.toDouble())
                          .toList();

                      return RepaintBoundary(
                        key: _barChartKey,
                        child: BarChartCard(
                          title: "Most Popular Cities",
                          values: values,
                          labels: labels,
                          color: AppColors.deepGreen,
                        ),
                      );
                    },
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