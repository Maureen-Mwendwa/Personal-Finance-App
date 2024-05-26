//represents an individual expense entry.
//Contains details such as the category, subcategory, item name, amount and date.
//This structure provides a comprehensive representation of each expense, making it easier to perform operations like tracking, editing, and deleting expenses.
class Expense {
  final String category;
  final String subcategory;
  final String item;
  final double amount;
  final DateTime date;

  Expense({
    required this.category,
    required this.subcategory,
    required this.item,
    required this.amount,
    required this.date,
  });
}
