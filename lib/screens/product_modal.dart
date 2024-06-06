import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/models/product.dart';
import 'package:spendsense/statemanagement/product_provider.dart';
// Importing the intl package for internationalization and date formatting.
import 'package:intl/intl.dart';

class ProductModal extends StatefulWidget {
  // Declaring a final property `product` of type `Product?` which can be null.
  final Product? product;

  // Constructor for ProductModal, accepts an optional `product`.
  ProductModal({this.product});

  @override
  _ProductModalState createState() => _ProductModalState();
}

class _ProductModalState extends State<ProductModal> {
  // A GlobalKey for uniquely identifying the form and enabling validation.
  final _formKey = GlobalKey<FormState>();

  // Declaring TextEditingControllers to control and track changes in the input fields.
  late TextEditingController _nameController;
  late TextEditingController _costController;
  late TextEditingController _sellingController;
  late TextEditingController _quantityController;

  // Variable to hold the selected date for the product. Default is the current date.
  DateTime _selectedDate = DateTime.now();

  // Overriding the initState method to initialize the state of the widget.
  @override
  void initState() {
    super.initState();

    // Initializing the controllers with the product's existing data if it's provided.
    _nameController = TextEditingController(text: widget.product?.name);
    _costController =
        TextEditingController(text: widget.product?.costPrice.toString());
    _sellingController = TextEditingController(
        text: widget.product?.initialSellingPrice.toString());
    _quantityController =
        TextEditingController(text: widget.product?.initialQuantity.toString());

    // If a product is passed to this modal, initialize the selected date with the product's date.
    if (widget.product != null) {
      _selectedDate = widget.product!.date;
    }
  }

  // Overriding the dispose method to clean up the controllers when the widget is disposed.
  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    _sellingController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Returning an AlertDialog widget to create a modal dialog.
    return AlertDialog(
      // Setting the title of the dialog based on whether we are adding or editing a product.
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),

      // Adding a SingleChildScrollView to allow scrolling if the content overflows.
      content: SingleChildScrollView(
        // Creating a Form widget to wrap the form fields.
        child: Form(
          key: _formKey,

          // Adding a Column widget to layout the form fields vertically.
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Adding a TextFormField for the product name.
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                // Validator to ensure the product name is not empty.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),

              // Adding a TextFormField for the cost price.
              TextFormField(
                controller: _costController,
                decoration: InputDecoration(labelText: 'Cost Price'),
                keyboardType: TextInputType.number,
                // Validator to ensure the cost price is not empty.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cost price';
                  }
                  return null;
                },
              ),

              // Adding a TextFormField for the selling price.
              TextFormField(
                controller: _sellingController,
                decoration: InputDecoration(labelText: 'Selling Price'),
                keyboardType: TextInputType.number,
                // Validator to ensure the selling price is not empty.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter selling price';
                  }
                  return null;
                },
              ),

              // Adding a TextFormField for the initial quantity.
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Initial Quantity'),
                keyboardType: TextInputType.number,
                // Validator to ensure the initial quantity is not empty.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter initial quantity';
                  }
                  return null;
                },
              ),

              // Adding a SizedBox for vertical spacing.
              SizedBox(height: 10),

              // Adding a text to indicate date selection.
              Text(
                'Select Date:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              // Adding a SizedBox for vertical spacing.
              SizedBox(height: 10),

              // Adding a button to select the date.
              ElevatedButton(
                onPressed: () async {
                  // Showing a date picker to select the date.
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(3000),
                  );

                  // Updating the selected date if a new date is picked.
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                // Displaying the selected date on the button.
                child: Text(DateFormat.yMMMd().format(_selectedDate)),
              ),
            ],
          ),
        ),
      ),

      // Adding actions (buttons) to the dialog.
      actions: [
        // Adding a button to save the product.
        ElevatedButton(
          onPressed: () {
            // Validating the form fields before saving.
            if (_formKey.currentState!.validate()) {
              if (widget.product == null) {
                // If adding a new product, call addProduct on the provider.
                Provider.of<ProductProvider>(context, listen: false).addProduct(
                  name: _nameController.text,
                  costPrice: double.parse(_costController.text),
                  sellingPrice: double.parse(_sellingController.text),
                  initialQuantity: int.parse(_quantityController.text),
                  date: _selectedDate,
                );
              } else {
                // If editing an existing product, call updateProduct on the provider.
                Provider.of<ProductProvider>(context, listen: false)
                    .updateProduct(
                  widget.product!,
                  _nameController.text,
                  double.parse(_costController.text),
                  double.parse(_sellingController.text),
                  int.parse(_quantityController.text),
                  _selectedDate,
                );
              }
              // Closing the dialog after saving.
              Navigator.of(context).pop();
            }
          },
          // Setting the text of the save button.
          child: Text('Save'),
        ),

        // Adding a button to cancel and close the dialog.
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          // Setting the text of the cancel button.
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
