// Providers manage the state and business logic of the application. They ensure that changes in the data are reflected in the UI and handle operations like adding, editing, and deleting expenses.
//The provider (ExpensesProvider) uses ChangeNotifier to notify the UI when data changes.
import 'package:flutter/material.dart';
import 'package:spendsense/models/expense.dart';

class ExpensesProvider with ChangeNotifier {
  List<Expense> _expenses =
      []; //initializing a private list _expenses to hold the expense data. Using a private list ensures that the list can only be modified through methods defined in this class, maintaining data integrity.

  List<Expense> get expenses =>
      _expenses; //A getter method for _expenses. It allows read-only access to the list of expenses from outside the class.

//Method addExpense that takes an Expense object as a parameter.
  void addExpense(Expense expense) {
    _expenses.add(expense); //Adds the new expense to the _expenses list.
    notifyListeners(); //Calls notifyListeners to inform all the registered listeners (e.g., UI components that the data has changed, prompting them to rebuild and reflect the updated data. )
  }

//Defines a method editExpense that takes two Expense objects as parameters: oldExpense (the existing expense to be updated) and newExpense (the new data for the expense).
  void editExpense(Expense oldExpense, Expense newExpense) {
    final index = _expenses.indexOf(
        oldExpense); //Finds the index of the oldExpense in the _expenses list
    if (index >= 0) {
      //checks if the oldExpense was found in the list.
      _expenses[index] =
          newExpense; //Replaces the oldExpense with newExpense at the found index.
      notifyListeners();
    }
  }

  void deleteExpense(Expense expense) {
    _expenses.remove(expense);
    notifyListeners();
  }

//Defines a method getTotalAmount that takes two strings: category and subcategory. _expenses.where((expense)=> expense.category == category && expense.subcategory == subcategory): Filters the _expenses list to include only those expenses that match the specified category and subcategory. .fold(0.0, (sum, expense)=> sum + expense.amount): Sums up the amount of the filtered expenses, starting with an initial value of 0.0.
  double getTotalAmount(String category, String subcategory) {
    return _expenses
        .where((expense) =>
            expense.category == category && expense.subcategory == subcategory)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

//Defines a method getHighestExpense that takes a string category and returns an Expense object or null. final categoryExpenses = _expenses.where((expense)=> expense.category == category).toList(): Filters the _expenses list to include only those expenses that match the specified category and converts it to a list.  if(categoryExpenses.isEmpty) return null: Checks if the filtered list is empty. If so, returns null. categoryExpenses.sort((a,b)=> b.amount.compareTo(a.amount)): Sorts the filtered list in descending order based on the amount of the expenses. return categoryExpenses.first: returns the first expense in sorted list, which is the one with the highest amount.
  Expense? getHighestExpense(String category) {
    final categoryExpenses =
        _expenses.where((expense) => expense.category == category).toList();
    if (categoryExpenses.isEmpty) return null;
    categoryExpenses.sort((a, b) => b.amount.compareTo(a.amount));
    return categoryExpenses.first;
  }
}
