import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/models/product.dart';
import 'package:spendsense/statemanagement/product_provider.dart';
import 'package:intl/intl.dart';

class ProductModal extends StatefulWidget {
  final Product? product;

  ProductModal({this.product});

  @override
  _ProductModalState createState() => _ProductModalState();
}

class _ProductModalState extends State<ProductModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _costController;
  late TextEditingController _sellingController;
  late TextEditingController _quantityController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name);
    _costController =
        TextEditingController(text: widget.product?.costPrice.toString());
    _sellingController = TextEditingController(
        text: widget.product?.initialSellingPrice.toString());
    _quantityController =
        TextEditingController(text: widget.product?.initialQuantity.toString());
    if (widget.product != null) {
      _selectedDate = widget.product!.date;
    }
  }

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
    return AlertDialog(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _costController,
                decoration: InputDecoration(labelText: 'Cost Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cost price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sellingController,
                decoration: InputDecoration(labelText: 'Selling Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter selling price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Initial Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter initial quantity';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text(
                'Select Date:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: Text(DateFormat.yMMMd().format(_selectedDate)),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (widget.product == null) {
                Provider.of<ProductProvider>(context, listen: false).addProduct(
                  name: _nameController.text,
                  costPrice: double.parse(_costController.text),
                  sellingPrice: double.parse(_sellingController.text),
                  initialQuantity: int.parse(_quantityController.text),
                  date: _selectedDate,
                );
              } else {
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
              Navigator.of(context).pop();
            }
          },
          child: Text('Save'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
