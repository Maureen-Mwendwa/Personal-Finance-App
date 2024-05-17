import 'package:spendsense/models/expense_category.dart';
import 'package:spendsense/models/expense_subcategory.dart';

class Expense {
  final String item;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;
  final ExpenseSubcategory subcategory;

  Expense({
    required this.item,
    required this.amount,
    required this.date,
    required this.category,
    required this.subcategory,
  });
}
