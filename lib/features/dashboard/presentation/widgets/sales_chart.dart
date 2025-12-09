import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:phone_management_system_admin/core/theme/app_colors.dart';

class SalesChart extends StatelessWidget {
  final List<double> data;

  const SalesChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: LineChart(
          LineChartData(
            minY: 0,
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  data.length,
                  (i) => FlSpot(i.toDouble(), data[i]),
                ),
                isCurved: true,
                color: AppColors.kPrimary,
                barWidth: 3,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.kPrimary.withOpacity(.15),
                ),
              ),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, meta) {
                    const labels = ["M", "T", "W", "T", "F", "S", "S"];
                    return Text(labels[v.toInt()],
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ));
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 50,
                  reservedSize: 35,
                  getTitlesWidget: (v, meta) {
                    return Text("\$${v.toInt()}",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ));
                  },
                ),
              ),
            ),
            gridData: const FlGridData(show: true, horizontalInterval: 50),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}
