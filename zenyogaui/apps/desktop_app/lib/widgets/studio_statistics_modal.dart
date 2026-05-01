import 'package:core/dto/responses/groupped_classes.dart';
import 'package:core/services/providers/class_service.dart';
import 'package:core/services/providers/studio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenyogaui/widgets/pie_chart.dart';
import '../core/theme.dart';
import '../widgets/kpi_card.dart';

class StudioStatisticsDialog extends StatelessWidget {
  final int studioId;

  const StudioStatisticsDialog({super.key, required this.studioId});

  @override
  Widget build(BuildContext context) {
    final studioProvider = Provider.of<StudioProvider>(context, listen: false);
    final classProvider = Provider.of<ClassProvider>(context, listen: false);


    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

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

              const SizedBox(height: 20),


              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  FutureBuilder<double>(
                    future: studioProvider.repository.getPayments(studioId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const KpiCard(
                          title: "Total Revenue",
                          value: "...",
                          icon: Icons.money,
                          color: Colors.green,
                        );
                      }
                      if (snapshot.hasError) {
                        return KpiCard(
                          title: "Total Revenue",
                          value: "Error",
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
                    future: studioProvider.repository.getParticipants(studioId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const KpiCard(
                          title: "Participants",
                          value: "...",
                          icon: Icons.people,
                          color: AppColors.lavender,
                        );
                      }
                      if (snapshot.hasError) {
                        return KpiCard(
                          title: "Participants",
                          value: "Error",
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

                ]
              ),

              const SizedBox(height: 24),
              GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    FutureBuilder<GrouppedClasses>(
                      future: classProvider.repository.getStudioGroupped(studioId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const PieChartCard(
                            title: "Classes by Type",
                            data: {},
                            colors: [
                              Colors.green,
                              Colors.blue,
                              Colors.orange,
                            ],
                          );
                        }

                        if (snapshot.hasError) {
                          return const PieChartCard(
                            title: "Classes by Type",
                            data: {},
                            colors: [
                              Colors.green,
                              Colors.blue,
                              Colors.orange,
                            ],
                          );
                        }

                        final grouped = snapshot.data!;

                        final data = {
                          "Hatha": grouped.hathaYoga.length.toDouble(),
                          "Yin": grouped.yinYoga.length.toDouble(),
                          "Vinyasa": grouped.vinyasaYoga.length.toDouble(),
                        };

                        return PieChartCard(
                          title: "Classes by Type",
                          data: data,
                          colors: const [
                            Colors.green,
                            Colors.blue,
                            Colors.orange,
                          ],
                        );
                      },
                    ),
                  ],


              ),

              const SizedBox(height: 24),



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
