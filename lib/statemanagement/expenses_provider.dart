// expense_provider.dart
import 'package:flutter/material.dart';
import 'package:spendsense/models/expense.dart';

class ExpensesProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  void editExpense(Expense oldExpense, Expense newExpense) {
    final index = _expenses.indexOf(oldExpense);
    if (index >= 0) {
      _expenses[index] = newExpense;
      notifyListeners();
    }
  }

  void deleteExpense(Expense expense) {
    _expenses.remove(expense);
    notifyListeners();
  }

  double getTotalAmount(String category, String subcategory) {
    return _expenses
        .where((expense) =>
            expense.category == category && expense.subcategory == subcategory)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Expense? getHighestExpense(String category) {
    final categoryExpenses =
        _expenses.where((expense) => expense.category == category).toList();
    if (categoryExpenses.isEmpty) return null;
    categoryExpenses.sort((a, b) => b.amount.compareTo(a.amount));
    return categoryExpenses.first;
  }
}
