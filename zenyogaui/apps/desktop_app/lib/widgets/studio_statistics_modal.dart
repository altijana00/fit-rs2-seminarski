import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:core/dto/responses/groupped_classes.dart';
import 'package:core/dto/responses/instructor_classes.dart';
import 'package:core/services/providers/class_service.dart';
import 'package:core/services/providers/pdf_service.dart';
import 'package:core/services/providers/studio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import 'package:zenyogaui/widgets/pie_chart.dart';
import '../core/theme.dart';
import '../widgets/kpi_card.dart';
import 'bar_chart.dart';

class StudioStatisticsDialog extends StatefulWidget {
  final int studioId;

  const StudioStatisticsDialog({super.key, required this.studioId});

  @override
  State<StudioStatisticsDialog> createState() =>
      _StudioStatisticsDialogState();
}

class _StudioStatisticsDialogState extends State<StudioStatisticsDialog> {
  final GlobalKey _pieChartKey = GlobalKey();
  final GlobalKey _barChartKey = GlobalKey();

  Future<Uint8List> captureWidget(GlobalKey key) async {
    final boundary =
    key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  Future<void> _downloadPdf() async {
    final studioProvider = context.read<StudioProvider>();
    final classProvider = context.read<ClassProvider>();

    final revenue =
    await studioProvider.repository.getPayments(widget.studioId);

    final participants =
    await studioProvider.repository.getParticipants(widget.studioId);

    final pieImage = await captureWidget(_pieChartKey);
    final barImage = await captureWidget(_barChartKey);

    final pdfBytes = await PdfService.generateStudioReport(
      revenue: revenue,
      participants: participants,
      pieChartImage: pieImage,
      barChartImage: barImage,
    );

    await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
  }

  @override
  Widget build(BuildContext context) {
    final studioProvider = context.read<StudioProvider>();
    final classProvider = context.read<ClassProvider>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 900,
        height: 650,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Studio Statistics",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),

              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text("Download PDF"),
                  onPressed: _downloadPdf,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// KPI GRID
                      GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2.4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          FutureBuilder<double>(
                            future: studioProvider.repository
                                .getPayments(widget.studioId),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const KpiCard(
                                  title: "Total Revenue",
                                  value: "...",
                                  icon: Icons.money,
                                  color: Colors.green,
                                );
                              }

                              return KpiCard(
                                title: "Total Revenue",
                                value: snapshot.data.toString(),
                                icon: Icons.money,
                                color: Colors.green,
                              );
                            },
                          ),
                          FutureBuilder<int>(
                            future: studioProvider.repository
                                .getParticipants(widget.studioId),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const KpiCard(
                                  title: "Participants",
                                  value: "...",
                                  icon: Icons.people,
                                  color: AppColors.lavender,
                                );
                              }

                              return KpiCard(
                                title: "Participants",
                                value: snapshot.data.toString(),
                                icon: Icons.people,
                                color: AppColors.lavender,
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// CHARTS
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 700;

                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              SizedBox(
                                width: isWide
                                    ? (constraints.maxWidth / 2) - 8
                                    : constraints.maxWidth,
                                child: FutureBuilder<GrouppedClasses>(
                                  future: classProvider.repository
                                      .getStudioGroupped(widget.studioId),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    final g = snapshot.data!;

                                    final data = {
                                      "Hatha": g.hathaYoga.length.toDouble(),
                                      "Yin": g.yinYoga.length.toDouble(),
                                      "Vinyasa":
                                      g.vinyasaYoga.length.toDouble(),
                                    };

                                    return RepaintBoundary(
                                      key: _pieChartKey,
                                      child: PieChartCard(
                                        title: "Classes by Type",
                                        data: data,
                                        colors: const [
                                          Colors.green,
                                          Colors.blue,
                                          Colors.orange,
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                              SizedBox(
                                width: isWide
                                    ? (constraints.maxWidth / 2) - 8
                                    : constraints.maxWidth,
                                child: FutureBuilder<List<InstructorClasses>>(
                                  future: classProvider.repository
                                      .getInstructorGroupedByStudioId(
                                      widget.studioId),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    final list = snapshot.data!;

                                    final labels =
                                    list.map((e) => e.name).toList();
                                    final values = list
                                        .map((e) =>
                                        e.numberOfClasses.toDouble())
                                        .toList();

                                    return RepaintBoundary(
                                      key: _barChartKey,
                                      child: BarChartCard(
                                        title: "Classes by Instructor",
                                        values: values,
                                        labels: labels,
                                        color: Colors.blue,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}