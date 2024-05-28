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
    _itemController = TextEditingController(
        text: widget.expense
            .item); // Initialize the item controller with the current item
    _amountController = TextEditingController(
        text: widget.expense.amount.toStringAsFixed(
            2)); // Initialize the amount controller with the current amount
    _date = widget
        .expense.date; // Initialize the date with the current expense date
  }

  @override
  void dispose() {
    _itemController
        .dispose(); // Dispose the item controller to free up resources
    _amountController
        .dispose(); // Dispose the amount controller to free up resources
    super.dispose();
  }

  void _saveExpense() {
    final newExpense = Expense(
      category: widget.category,
      subcategory: widget.subcategory,
      item: _itemController.text, // Get the updated item from the text field
      amount: double.parse(
          _amountController.text), // Get the updated amount from the text field
      date: _date, // Get the updated date
    );

    // Update the expense in the provider
    Provider.of<ExpensesProvider>(context, listen: false)
        .editExpense(widget.expense, newExpense);

    Navigator.of(context).pop(); // Navigate back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'),
        backgroundColor: Colors.teal, // Set the AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Align children to the start of the column
          children: [
            TextField(
              controller: _itemController,
              decoration: InputDecoration(
                labelText: 'Item',
                prefixIcon:
                    Icon(Icons.shopping_cart), // Add an icon to the input field
                border:
                    OutlineInputBorder(), // Add an outline border to the input field
              ),
            ),
            SizedBox(height: 16), // Add space between fields
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number, // Set keyboard type to number
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon:
                    Icon(Icons.attach_money), // Add an icon to the input field
                border:
                    OutlineInputBorder(), // Add an outline border to the input field
              ),
            ),
            SizedBox(height: 16), // Add space between fields
            TextField(
              readOnly: true, // Make the text field read-only
              decoration: InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(
                    Icons.calendar_today), // Add an icon to the input field
                border:
                    OutlineInputBorder(), // Add an outline border to the input field
              ),
              controller: TextEditingController(
                text: _date.toString().split(' ')[
                    0], // Set the initial value of the text field to the current date
              ),
              onTap: () async {
                // Display a date picker and store the selected date in pickedDate
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(3000),
                );
                if (pickedDate != null && pickedDate != _date) {
                  setState(() {
                    _date =
                        pickedDate; // Update the date if a new date is picked
                  });
                }
              },
            ),
            SizedBox(height: 20), // Add space before the button
            Center(
              child: ElevatedButton(
                onPressed:
                    _saveExpense, // Calls the _saveExpense method when the button is pressed
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Set button color
                  padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32), // Add padding inside the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Round the button corners
                  ),
                ),
                child: Text('Save Changes',
                    style: TextStyle(fontSize: 16)), // Set button text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
