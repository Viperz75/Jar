import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class StackedBarChart extends StatelessWidget {
  final List<double> history;
  final double goalAmount;

  const StackedBarChart({
    required this.history,
    required this.goalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: goalAmount, // Set maximum Y value to the goal amount
        barGroups: [
          BarChartGroupData(
            x: 0,
            barsSpace: 4,
            barRods: [
              BarChartRodData(
                y: goalAmount, // Set the goal amount as the height of the first bar
                colors: [Colors.blue], // Color for the goal amount bar
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barsSpace: 4,
            barRods: history.map((value) {
              return BarChartRodData(
                y: value,
                colors: [Colors.green], // Color for history bars
              );
            }).toList(),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: SideTitles(showTitles: false),
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
