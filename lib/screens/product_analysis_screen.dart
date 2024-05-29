import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:spendsense/screens/profit_loss_bar_chart.dart';
import 'package:spendsense/screens/revenue_pie_chart.dart';
import 'package:spendsense/screens/sales_line_graph.dart';
import 'package:spendsense/statemanagement/product_provider.dart';

class VisualizationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Visualizations - ${DateFormat.yMMMd().format(DateTime.now())}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: ProfitLossBarChart(provider.products),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: SalesLineGraph(provider.sales, provider.products),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: RevenuePieChart(provider.products, provider.sales),
            ),
          ],
        ),
      ),
    );
  }
}
