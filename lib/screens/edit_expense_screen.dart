import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/models/expense.dart';
import 'package:spendsense/statemanagement/expenses_provider.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  final String category;
  final String subcategory;

  EditExpenseScreen({
    required this.expense,
    required this.category,
    required this.subcategory,
  });

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController _itemController;
  late TextEditingController _amountController;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController(text: widget.expense.item);
    _amountController =
        TextEditingController(text: widget.expense.amount.toStringAsFixed(2));
    _date = widget.expense.date;
  }

  @override
  void dispose() {
    _itemController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveExpense() {
    final newExpense = Expense(
      category: widget.category,
      subcategory: widget.subcategory,
      item: _itemController.text,
      amount: double.parse(_amountController.text),
      date: _date,
    );

    Provider.of<ExpensesProvider>(context, listen: false)
        .editExpense(widget.expense, newExpense);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _itemController,
              decoration: InputDecoration(
                labelText: 'Item',
              ),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            // Add a date picker widget or text field for editing the date
            ElevatedButton(
              onPressed: _saveExpense,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
