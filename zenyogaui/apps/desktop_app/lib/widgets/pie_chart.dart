import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartCard extends StatelessWidget {
  final String title;
  final Map<String, double> data;
  final List<Color> colors;

  const PieChartCard({
    super.key,
    required this.title,
    required this.data,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 5),

            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sections: List.generate(entries.length, (i) {
                    final e = entries[i];
                    return PieChartSectionData(
                      value: e.value,
                      title: e.key,
                      color: colors[i % colors.length],
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}