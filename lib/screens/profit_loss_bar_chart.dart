import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendsense/models/product.dart';
import 'package:spendsense/models/profitloss.dart';

class ProfitLossBarChart extends StatelessWidget {
  final List<Product> products;

  ProfitLossBarChart(this.products);

  @override
  Widget build(BuildContext context) {
    final List<ProfitLoss> data = products.map((product) {
      final profitLoss = (product.initialSellingPrice - product.costPrice) *
          product.initialQuantity;
      return ProfitLoss(product.name, profitLoss);
    }).toList();

    List<BarChartGroupData> barGroups = data.map((entry) {
      int index = data.indexOf(entry);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.amount,
            color: entry.amount >= 0 ? Colors.green : Colors.red,
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                int index = value.toInt();
                if (index < 0 || index >= data.length) return Text('');
                return Text(data[index].product);
              },
            ),
          ),
        ),
      ),
    );
  }
}
