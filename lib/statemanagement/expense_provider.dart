// expense_provider.dart
import 'package:flutter/material.dart';
import 'package:spendsense/models/expense.dart';
import 'package:spendsense/models/expense_category.dart';
import 'package:spendsense/models/expense_subcategory.dart';

//In the ExpenseProvider class, we have a list of Expense objects and methods to add, edit, and delete expenses. We also have methods to calculate the total spending for a particular category or subcategory.
class ExpenseProvider extends ChangeNotifier {
  //ExpenseProvider
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  void editExpense(int index, Expense updatedExpense) {
    _expenses[index] = updatedExpense;
    notifyListeners();
  }

  void deleteExpense(int index) {
    _expenses.removeAt(index);
    notifyListeners();
  }

  double getTotalSpendingForCategory(ExpenseCategory category) {
    double total = 0;
    for (var expense in _expenses) {
      if (expense.category == category) {
        total += expense.amount;
      }
    }
    return total;
  }

  double getTotalSpendingForSubcategory(ExpenseSubcategory subcategory) {
    double total = 0;
    for (var expense in _expenses) {
      if (expense.subcategory == subcategory) {
        total += expense.amount;
      }
    }
    return total;
  }
}
