import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bharat_heritage/core/theme/app_theme.dart';

class CrowdTrendsChart extends StatelessWidget {
  const CrowdTrendsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 3),
              FlSpot(1, 4),
              FlSpot(2, 3.5),
              FlSpot(3, 5),
              FlSpot(4, 4),
              FlSpot(5, 6),
            ],
            isCurved: true,
            color: AppColors.tertiary,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.tertiary.withOpacity(0.2),
            ),
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
