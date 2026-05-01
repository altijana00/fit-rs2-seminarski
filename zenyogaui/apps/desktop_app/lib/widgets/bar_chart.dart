import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartCard extends StatelessWidget {
  final String title;
  final List<double> values;
  final List<String> labels;
  final Color color;

  const BarChartCard({
    super.key,
    required this.title,
    required this.values,
    required this.labels,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1, // 👈 only whole numbers
                        getTitlesWidget: (value, meta) {
                          if (value % 1 != 0) return const SizedBox(); // 👈 extra safety
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),

                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // 👈 REMOVE right side
                    ),

                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // 👈 clean look
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= labels.length) return const SizedBox();

                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              labels[index],
                              style: const TextStyle(fontSize: 10),
                              overflow: TextOverflow.ellipsis, // 👈 prevents overflow
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(values.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: values[i],
                          borderRadius: BorderRadius.circular(0),
                          width: 15
                        ),
                      ],
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