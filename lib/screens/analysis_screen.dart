import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/statemanagement/expenses_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedFilter = 'Month'; // Default filter

  final List<Color> _categoryColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    final expensesProvider = Provider.of<ExpensesProvider>(context);
    final expenses = expensesProvider.expenses;

    // Prepare data for charts and visualizations
    final Map<String, double> categoryExpenses = {};
    final Map<DateTime, double> dateExpenses = {};

    for (final expense in expenses) {
      // Category expenses
      categoryExpenses.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );

      // Date-based expenses for trend line
      final date =
          DateTime(expense.date.year, expense.date.month, expense.date.day);
      dateExpenses.update(
        date,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    List<Color> getCategoryColors() {
      return List.generate(
        categoryExpenses.length,
        (index) => _categoryColors[index % _categoryColors.length],
      );
    }

    final categoryColors = getCategoryColors();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Align children to the start of the column
            children: [
              // Filter Dropdown
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DropdownButton<String>(
                  value: _selectedFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                    });
                  },
                  items: <String>['Day', 'Month', 'Year']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  isExpanded: true, // Make the dropdown expand to full width
                ),
              ),
              // Category Expenses Bar Chart
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Category Expenses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 300, // Fixed height for the chart
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: categoryExpenses.entries.map((entry) {
                      final index =
                          categoryExpenses.keys.toList().indexOf(entry.key);
                      final color = categoryColors[index];
                      return BarChartGroupData(
                        x: entry.key.hashCode,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value, // Updated toY
                            color: color,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Text(
                              value.toString(),
                              style: TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final category = categoryExpenses.keys.firstWhere(
                                (key) => key.hashCode == value.toInt(),
                                orElse: () => '');
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(category,
                                  style: TextStyle(fontSize: 10)),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData:
                        FlGridData(show: false), // Hide grid lines for clarity
                    borderData: FlBorderData(
                      show: false, // Hide chart borders
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(), // Add a divider for better visual separation
              ),
              // Spending Trend Line Chart
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Spending Trend',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 300, // Fixed height for the chart
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: dateExpenses.entries.map((entry) {
                          return FlSpot(
                            entry.key.millisecondsSinceEpoch.toDouble(),
                            entry.value,
                          );
                        }).toList(),
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 2,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final date = DateTime.fromMillisecondsSinceEpoch(
                                value.toInt());
                            final title = _selectedFilter == 'Day'
                                ? '${date.day}/${date.month}'
                                : _selectedFilter == 'Month'
                                    ? '${date.month}/${date.year}'
                                    : '${date.year}';
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child:
                                  Text(title, style: TextStyle(fontSize: 10)),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Text(
                              value.toString(),
                              style: TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData:
                        FlGridData(show: false), // Hide grid lines for clarity
                    borderData: FlBorderData(
                      show: false, // Hide chart borders
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
