// Responsible for displaying a form that allows users to add or edit an expense. This widget uses a form with text fields for the item name, amount, and data, and it handles the logic for saving the expense data.
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
  final _formKey = GlobalKey<
      FormState>(); //Declares a form key to uniquely identify the form.
  //Declare state variables for the item name, amount, and date.
  String _item = '';
  double _amount = 0.0;
  DateTime _date = DateTime.now();

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
//When the form is submitted, the _SaveForm method is called. This method validates the form, saves the data, and then creates a new Expense object with the entered details. After creating the newExpense object, the   Provider.of<ExpensesProvider>(context, listen: false) .addExpense(newExpense); line is executed to add the expense to the list managed by ExpensesProvider
      final newExpense = Expense(
        category: widget.category,
        subcategory: widget.subcategory,
        item: _item,
        amount: _amount,
        date: _date,
      );

//Provider.of<ExpensesProvider>: This is a method provided by the provider package to access the instance of a provider. In this case, it is accessing an instance of ExpensesProvider in this context. (context, listen: false). Context: The build context from which the provider is accessed. listen: false. When listen is set to false, it means that this widget does not need to rebuild if the ExpensesProvider changes. Essentially, you are telling flutter that you want to access the provider without listening for updates. This is useful in scenarios where you need to perform an action but don't need to rebuild the UI when the data changes.
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
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key:
              _formKey, //This assigns a global key to the form, allowing it to be uniquely identified and managed. The key is used for accessing the form's state, such as validation and saving.
          child: ListView(
            //The listview widget allows for verticla scrolling of its children. This is useful when the form has multiple fields that might not fit on the screen.
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Item',
                  prefixIcon: Icon(Icons.shopping_cart),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  //Validates the input. It checks if the filed is empty and returns an error message if it is.
                  if (value!.isEmpty) {
                    return 'Please enter an item.';
                  }
                  return null;
                },
                onSaved: (value) {
                  //Called when the form is saved. It assigns the input value to _item.
                  _item = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType
                    .number, //sets the keyboard type to number,making it easier for the user to enter numerical values.
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
                decoration: InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly:
                    true, //read-only input field for the date. Makes the text field read-only, so the user cannot type directly into it.
                controller: TextEditingController(
                    text: _date.toString().split(' ')[
                        0]), //Sets the initial value of the text field to the current date, formatted to show only the date part.
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    //Displays a date picker and stores the selected date in pickedDate.
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(3000),
                  );
                  if (pickedDate != null && pickedDate != _date)
                    setState(() {
                      _date = pickedDate;
                    });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    _saveForm, //Calls the _saveForm method when the button is pressed. This method validates and saves the form data.
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                child: Text('Save Expense', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
