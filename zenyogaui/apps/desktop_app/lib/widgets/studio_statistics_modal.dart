import 'package:core/services/providers/studio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../widgets/kpi_card.dart';

class StudioStatisticsDialog extends StatelessWidget {
  final int studioId;

  const StudioStatisticsDialog({super.key, required this.studioId});

  @override
  Widget build(BuildContext context) {
    final studioProvider = Provider.of<StudioProvider>(context, listen: false);


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
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
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
