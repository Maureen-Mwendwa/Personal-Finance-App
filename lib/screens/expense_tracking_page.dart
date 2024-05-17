// expense_tracking_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/models/expense.dart';
import 'package:spendsense/models/expense_category.dart';
import 'package:spendsense/models/expense_subcategory.dart';
import 'package:spendsense/statemanagement/expense_provider.dart';

class ExpenseTrackingPage extends StatefulWidget {
  @override
  _ExpenseTrackingPageState createState() => _ExpenseTrackingPageState();
}

class _ExpenseTrackingPageState extends State<ExpenseTrackingPage> {
  final _formKey = GlobalKey<FormState>();
  String _item = '';
  double _amount = 0;
  DateTime _date = DateTime.now();
  ExpenseCategory _category = ExpenseCategory.housing;
  ExpenseSubcategory _subcategory = ExpenseSubcategory.rentMortgage;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Expense Tracking'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Expense',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Expense Item',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an expense item';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _item = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Amount',
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an amount';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _amount = double.parse(value!);
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<ExpenseCategory>(
                      value: _category,
                      decoration: InputDecoration(
                        labelText: 'Category',
                      ),
                      items: ExpenseCategory.values.map((category) {
                        return DropdownMenuItem<ExpenseCategory>(
                          value: category,
                          child: Text(category.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _category = value!;
                          _subcategory = ExpenseSubcategory.values.firstWhere(
                            (subcategory) => subcategory
                                .toString()
                                .startsWith(value.toString()),
                          );
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<ExpenseSubcategory>(
                      value: _subcategory,
                      decoration: InputDecoration(
                        labelText: 'Subcategory',
                      ),
                      items: ExpenseSubcategory.values
                          .where((subcategory) => subcategory
                              .toString()
                              .startsWith(_category.toString()))
                          .map((subcategory) {
                        return DropdownMenuItem<ExpenseSubcategory>(
                          value: subcategory,
                          child: Text(subcategory.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _subcategory = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          context.read<ExpenseProvider>().addExpense(
                                Expense(
                                  item: _item,
                                  amount: _amount,
                                  date: _date,
                                  category: _category,
                                  subcategory: _subcategory,
                                ),
                              );
                          _formKey.currentState!.reset();
                          setState(() {
                            _item = '';
                            _amount = 0;
                            _date = DateTime.now();
                            _category = ExpenseCategory.housing;
                            _subcategory = ExpenseSubcategory.rentMortgage;
                          });
                        }
                      },
                      child: Text('Add Expense'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Expenses',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Consumer<ExpenseProvider>(
                  builder: (context, provider, child) {
                    final expenses = provider.expenses;
                    return ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return Dismissible(
                          key: Key(expense.item),
                          onDismissed: (direction) {
                            provider.deleteExpense(index);
                          },
                          background: Container(
                            color: Colors.red,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          child: ListTile(
                            title: Text(expense.item),
                            subtitle: Text(
                              '${expense.category.toString().split('.').last} - ${expense.subcategory.toString().split('.').last}',
                            ),
                            trailing:
                                Text('\$${expense.amount.toStringAsFixed(2)}'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
