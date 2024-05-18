import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/statemanagement/expenses_provider.dart';
import '../models/category.dart';
import 'add_expense_screen.dart';

class SubcategoriesScreen extends StatelessWidget {
  final Category category;

  SubcategoriesScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    final expensesProvider = Provider.of<ExpensesProvider>(context);
    final highestExpense = expensesProvider.getHighestExpense(category.name);

    return Scaffold(
      appBar: AppBar(
        title: Text('${category.name} Subcategories'),
      ),
      body: Column(
        children: [
          if (highestExpense != null)
            Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text('Highest Expense: ${highestExpense.subcategory}'),
                subtitle: Text(
                    'Amount: \$${highestExpense.amount.toStringAsFixed(2)}'),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: category.subcategories.length,
              itemBuilder: (ctx, i) {
                final subcategory = category.subcategories[i];
                final totalAmount =
                    expensesProvider.getTotalAmount(category.name, subcategory);
                final subcategoryExpenses = expensesProvider.expenses
                    .where((expense) =>
                        expense.category == category.name &&
                        expense.subcategory == subcategory)
                    .toList();

                return ExpansionTile(
                  title: Text(subcategory),
                  trailing: Text('\$${totalAmount.toStringAsFixed(2)}'),
                  children: subcategoryExpenses.map((expense) {
                    return ListTile(
                      title: Text(expense.item),
                      subtitle: Text(
                          'Amount: \$${expense.amount.toStringAsFixed(2)}, Date: ${expense.date.toString().split(' ')[0]}'),
                    );
                  }).toList(),
                  onExpansionChanged: (expanded) {
                    if (expanded) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddExpenseScreen(
                            category: category.name, subcategory: subcategory),
                      ));
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
