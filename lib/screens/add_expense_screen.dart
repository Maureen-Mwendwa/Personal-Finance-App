// screens/add_expense_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/statemanagement/expenses_provider.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final String category;
  final String subcategory;

  AddExpenseScreen({required this.category, required this.subcategory});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _item = '';
  double _amount = 0.0;
  DateTime _date = DateTime.now();

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newExpense = Expense(
        category: widget.category,
        subcategory: widget.subcategory,
        item: _item,
        amount: _amount,
        date: _date,
      );
      Provider.of<ExpensesProvider>(context, listen: false)
          .addExpense(newExpense);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Item'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an item.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _item = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an amount.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                readOnly: true,
                controller:
                    TextEditingController(text: _date.toString().split(' ')[0]),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _date)
                    setState(() {
                      _date = pickedDate;
                    });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
