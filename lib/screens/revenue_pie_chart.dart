import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
import 'package:spendsense/models/product.dart';
import 'package:spendsense/models/productrevenue.dart';
import 'package:spendsense/models/sale.dart';

class RevenuePieChart extends StatelessWidget {
  final List<Product> products;
  final List<Sale> sales;

  RevenuePieChart(this.products, this.sales);

  @override
  Widget build(BuildContext context) {
    final groupedSales = groupBy(sales, (Sale sale) => sale.productName);

    final revenueData = groupedSales.entries.map((entry) {
      final productName = entry.key;
      final totalRevenue = entry.value
          .fold(0.0, (sum, sale) => sum + (sale.sellingPrice * sale.quantity));
      return ProductRevenue(productName, totalRevenue);
    }).toList();

    List<PieChartSectionData> pieSections = revenueData.map((data) {
      return PieChartSectionData(
        value: data.amount,
        title: data.product,
        color: Colors
            .primaries[revenueData.indexOf(data) % Colors.primaries.length],
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: pieSections,
        centerSpaceRadius: 40,
        borderData: FlBorderData(show: false),
        sectionsSpace: 0,
      ),
    );
  }
}
