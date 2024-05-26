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

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
      ),
      body: Column(
        children: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
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
            ),
          ),

          // Category Expenses Bar Chart
          Text(
            'Category Expenses',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: categoryExpenses.entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key.hashCode,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value, // Updated toY
                        color: Colors.blue,
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final category = categoryExpenses.keys.firstWhere(
                            (key) => key.hashCode == value.toInt(),
                            orElse: () => '');
                        return SideTitleWidget(
                          child: Text(category),
                          axisSide: meta.axisSide,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Spending Trend Line Chart
          Text(
            'Spending Trend',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
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
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final date =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        final title = _selectedFilter == 'Day'
                            ? '${date.day}/${date.month}'
                            : _selectedFilter == 'Month'
                                ? '${date.month}/${date.year}'
                                : '${date.year}';
                        return SideTitleWidget(
                          child: Text(title),
                          axisSide: meta.axisSide,
                        );
                      },
                    ),
                  ),
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: true)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
