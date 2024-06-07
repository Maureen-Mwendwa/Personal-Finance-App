// Importing the Flutter material package which provides widgets to create UI components.
import 'package:flutter/material.dart';
// Importing the fl_chart package which provides a variety of chart widgets for Flutter applications.
import 'package:fl_chart/fl_chart.dart';
import 'package:spendsense/models/productrevenue.dart';

class ProductRevenueChart extends StatelessWidget {
  // Declaring a final property `data` of type List<ProductRevenue> to hold the revenue data for different products.
  final List<ProductRevenue> data;

  // Constructor for ProductRevenueChart, requires `data` to be provided.
  ProductRevenueChart({required this.data});

  @override
  Widget build(BuildContext context) {
    // Returning an AspectRatio widget to maintain a specific aspect ratio for the chart.
    return AspectRatio(
      aspectRatio: 1, // Setting the aspect ratio to 1 (width:height = 1:1).
      child: PieChart(
        // Creating a PieChart widget with the provided PieChartData.
        PieChartData(
          // Mapping each product revenue data to a PieChartSectionData.
          sections: data.map((productRevenue) {
            return PieChartSectionData(
              value: productRevenue
                  .amount, // Setting the value of the section to the product's revenue amount.
              title: productRevenue
                  .product, // Setting the title of the section to the product's name.
              color: Colors.primaries[data.indexOf(productRevenue) %
                  Colors.primaries
                      .length], // Assigns a color from Colors.primaries, cycling through the available colors.
            );
          }).toList(), // Converting the mapped data to a list.
          sectionsSpace: 10, // Setting the space between sections.
          centerSpaceRadius: 40, // Setting the radius of the central space.
          borderData:
              FlBorderData(show: false), // Hiding the border around the chart.
        ),
      ),
    );
  }
}
