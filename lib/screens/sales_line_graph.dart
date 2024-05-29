import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:spendsense/models/dailysales.dart';
import 'package:spendsense/models/product.dart';
import 'package:spendsense/models/sale.dart';

class SalesLineGraph extends StatelessWidget {
  final List<Sale> sales;
  final List<Product> products;

  SalesLineGraph(this.sales, this.products);

  @override
  Widget build(BuildContext context) {
    final salesData =
        groupBy(sales, (Sale sale) => sale.date).entries.map((entry) {
      final date = entry.key;
      final totalSales = entry.value
          .fold(0.0, (sum, sale) => sum + (sale.sellingPrice * sale.quantity));
      final totalCost = entry.value.fold(0.0, (sum, sale) {
        final product = products.firstWhere((p) => p.name == sale.productName);
        return sum + (product.costPrice * sale.quantity);
      });
      final profitLoss = totalSales - totalCost;
      return DailySales(date, totalSales, profitLoss);
    }).toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: salesData
                .map((data) => FlSpot(
                    data.date.millisecondsSinceEpoch.toDouble(),
                    data.totalSales))
                .toList(),
            isCurved: true,
            barWidth: 2,
            color: Colors.blue,
          ),
          LineChartBarData(
            spots: salesData
                .map((data) => FlSpot(
                    data.date.millisecondsSinceEpoch.toDouble(),
                    data.profitLoss))
                .toList(),
            isCurved: true,
            barWidth: 2,
            color: Colors.green,
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Text(DateFormat.MMMd().format(date));
              },
            ),
          ),
        ),
      ),
    );
  }
}
