import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/screens/edit_expense_screen.dart';
import 'package:spendsense/statemanagement/expenses_provider.dart';
import '../models/category.dart';
import 'add_expense_screen.dart';

// The main class for the SubcategoriesScreen
class SubcategoriesScreen extends StatelessWidget {
  // The category for which subcategories are shown
  final Category category;

  // Constructor to initialize the category
  SubcategoriesScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    // Accessing the ExpensesProvider to get expense data
    final expensesProvider = Provider.of<ExpensesProvider>(context);
    // Getting the highest expense for the category
    final highestExpense = expensesProvider.getHighestExpense(category.name);

    return Scaffold(
      appBar: AppBar(
        // Displaying the category name in the AppBar title
        title: Text('${category.name} Subcategories'),
        // Adding custom background color
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Displaying the highest expense if it exists
          if (highestExpense != null)
            Card(
              // Adding custom margin and elevation for shadow effect
              margin: EdgeInsets.all(10),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                // Displaying the subcategory and amount of the highest expense
                title: Text(
                  'Highest Expense: ${highestExpense.subcategory}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Amount: \$${highestExpense.amount.toStringAsFixed(2)}',
                ),
              ),
            ),
          // Expanded widget to make the ListView take up remaining space
          Expanded(
            child: ListView.builder(
              // The number of subcategories to display
              itemCount: category.subcategories.length,
              itemBuilder: (ctx, i) {
                // Getting the current subcategory
                final subcategory = category.subcategories[i];
                // Calculating the total amount for the subcategory
                final totalAmount =
                    expensesProvider.getTotalAmount(category.name, subcategory);
                // Getting all expenses for the subcategory
                final subcategoryExpenses = expensesProvider.expenses
                    .where((expense) =>
                        expense.category == category.name &&
                        expense.subcategory == subcategory)
                    .toList();

                return Card(
                  // Adding custom margin and elevation for shadow effect
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ExpansionTile(
                    // Displaying the subcategory name and total amount
                    title: Text(
                      subcategory,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      '\$${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: subcategoryExpenses.map((expense) {
                      return ListTile(
                        // Displaying the item name and expense details
                        title: Text(
                          expense.item,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Amount: \$${expense.amount.toStringAsFixed(2)}, Date: ${expense.date.toString().split(' ')[0]}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Button to edit the expense
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () {
                                // Navigate to EditExpenseScreen to edit the expense
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditExpenseScreen(
                                      expense: expense,
                                      category: category.name,
                                      subcategory: subcategory,
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Button to delete the expense
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                // Call the deleteExpense method from the provider
                                Provider.of<ExpensesProvider>(context,
                                        listen: false)
                                    .deleteExpense(expense);
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    // Action to perform when the expansion tile is expanded
                    onExpansionChanged: (expanded) {
                      if (expanded) {
                        // Navigate to AddExpenseScreen to add a new expense
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddExpenseScreen(
                              category: category.name,
                              subcategory: subcategory),
                        ));
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
