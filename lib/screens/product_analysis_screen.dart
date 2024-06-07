import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/screens/profit_loss_bar_chart.dart';
import 'package:spendsense/screens/revenue_pie_chart.dart';
import 'package:spendsense/screens/sales_bar_graph.dart';
import 'package:spendsense/statemanagement/product_provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          //Retrieve data from the provider
          final dailySalesData = provider.getDailySalesData();
          final productRevenueData = provider.getProductRevenueData();
          final profitLossData = provider.getProfitLossData();
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Revenue From All Sales By Day',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  DailySalesChart(data: dailySalesData),
                  SizedBox(height: 20),
                  Text(
                    'Product Revenue Breakdown For Each Product',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ProductRevenueChart(data: productRevenueData),
                  SizedBox(height: 20),
                  Text(
                    'Profit/Loss',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ProfitLossChart(data: profitLossData),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
