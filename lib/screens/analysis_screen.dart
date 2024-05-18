// // screens/analysis_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:spendsense/statemanagement/expenses_provider.dart';

// class AnalysisScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final expensesData = Provider.of<ExpensesProvider>(context);
//     final expenses = expensesData.expenses;

//     // Prepare data for charts
//     Map<String, double> categoryTotals = {};
//     expenses.forEach((expense) {
//       categoryTotals.update(
//         expense.category,
//         (value) => value + expense.amount,
//         ifAbsent: () => expense.amount,
//       );
//     });

//     final data = categoryTotals.entries.map((entry) {
//       return charts.SeriesEntry<String, double>(
//         entry.key,
//         entry.value,
//       );
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Analysis'),
//       ),
//       body: Center(
//         child: charts.PieChart<String>(
//           [
//             charts.Series<String, double>(
//               id: 'Expenses',
//               domainFn: (entry, _) => entry.key,
//               measureFn: (entry, _) => entry.value,
//               data: data,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
