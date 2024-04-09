import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<double> history;
  final double goalAmount;

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  LineChartWidget({
    Key? key,
    required this.history,
    required this.goalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxY = goalAmount;
    for (double value in history) {
      if (value > maxY) {
        maxY = value;
      }
    }

    double yAxisInterval = maxY / 6;
    List<double> yValues = List.generate(7, (index) => index * yAxisInterval);

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, goalAmount),
            ],
            isCurved: true,
            colors: [Colors.blue],
            barWidth: 4,
          ),
          LineChartBarData(
            spots: history.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble() + 1, entry.value);
            }).toList(),
            isCurved: true,
            colors: gradientColors,
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
              colors: gradientColors.map(
                  (Color) => Color.withOpacity(0.3)
              ).toList(),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: SideTitles(
            showTitles: true,
            interval: yAxisInterval,
            getTitles: (value) {
              return value.toStringAsFixed(0);
            },
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              if (value == 0) {
                return 'Goal';
              } else if (value == 1) {
                return 'History';
              }
              return '';
            },
          ),
        ),
      ),
    );
  }
}
