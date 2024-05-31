import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/models/product.dart';
import 'package:spendsense/screens/product_modal.dart';
import 'package:spendsense/statemanagement/product_provider.dart';
import 'package:intl/intl.dart';

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Product Inventory - ${DateFormat.yMMMd().format(DateTime.now())}'),
        actions: [
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () {
              Navigator.pushNamed(context, '/productanalysisscreen');
            },
          ),
          IconButton(
            icon: Icon(Icons.attach_money),
            onPressed: () {
              Navigator.pushNamed(context, '/salesloggingpage');
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          double totalValuation = provider.products.fold(
            0.0,
            (sum, product) =>
                sum + (product.initialSellingPrice * product.remainingQuantity),
          );

          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.amber,
                child: Text(
                  'Total Valuation: \$${totalValuation.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    final product = provider.products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text(
                        'Cost: \$${product.costPrice}, Selling: \$${product.initialSellingPrice}, Initial Qty: ${product.initialQuantity}, Remaining: ${product.remainingQuantity}, Date: ${DateFormat.yMMMd().format(product.date)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showEditProductModal(context, provider, product);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              provider.deleteProduct(product.name);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductModal(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddProductModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: ProductModal(),
        );
      },
    );
  }

  void _showEditProductModal(
      BuildContext context, ProductProvider provider, Product product) {
    final nameController = TextEditingController(text: product.name);
    final costPriceController =
        TextEditingController(text: product.costPrice.toString());
    final sellingPriceController =
        TextEditingController(text: product.initialSellingPrice.toString());
    final quantityController =
        TextEditingController(text: product.initialQuantity.toString());
    DateTime selectedDate = product.date;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Product ${product.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: costPriceController,
                  decoration: InputDecoration(labelText: 'Cost Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: sellingPriceController,
                  decoration: InputDecoration(labelText: 'Selling Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Initial Quantity'),
                  keyboardType: TextInputType.number,
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
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != selectedDate)
                      selectedDate = picked;
                  },
                  child: Text("Select Date"),
                ),
                Text(
                  "${DateFormat.yMMMd().format(selectedDate)}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                provider.updateProduct(
                  product,
                  nameController.text,
                  double.parse(costPriceController.text),
                  double.parse(sellingPriceController.text),
                  int.parse(quantityController.text),
                  selectedDate,
                );
                Navigator.of(context).pop();
              },
              child: Text('Update Product'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
