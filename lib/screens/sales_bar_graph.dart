import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendsense/models/dailysales.dart';

class DailySalesChart extends StatelessWidget {
  // Declare a final list of DailySales objects that will hold the data to be displayed
  final List<DailySales> data;

  // Constructor for the DailySalesChart widget that takes in a required list of DailySales objects
  DailySalesChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // Aspect ratio of the chart, determines the width-to-height ratio
      aspectRatio: 1.7,
      // BarChart widget from the fl_chart package to display a bar chart
      child: BarChart(
        // BarChartData object to provide data and configuration for the bar chart
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(
            border: const Border(
              top: BorderSide.none,
              right: BorderSide.none,
              left: BorderSide(width: 1),
              bottom: BorderSide(width: 1),
            ),
          ),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final date =
                      DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return Text('${date.day}/${date.month}/${date.year}');
                },
              ),
            ),
          ),
          barGroups: data.map((dailySales) {
            return BarChartGroupData(
              // Use a simple integer as the x-value to represent the position in the list
              x: dailySales.date.millisecondsSinceEpoch,
              // List of BarChartRodData objects representing individual bars
              barRods: [
                // Create a BarChartRodData object for the bar
                BarChartRodData(
                  fromY: 0, // The starting Y value of the bar
                  toY: dailySales
                      .totalSales, // The ending Y value of the bar, representing the total sales
                  width: 15,
                  // Set the color of the bar: green for non-negative sales, red for negative sales
                  color: dailySales.totalSales >= 0 ? Colors.green : Colors.red,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
