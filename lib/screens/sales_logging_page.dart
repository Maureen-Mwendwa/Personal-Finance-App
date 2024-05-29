//A page to log sales and calculate revenue, cost, and profit/loss
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/models/product.dart';
import 'package:spendsense/statemanagement/product_provider.dart';
import 'package:intl/intl.dart';

class SalesLoggingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final totalSales = provider.sales
        .fold(0.0, (sum, sale) => sum + (sale.sellingPrice * sale.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text('Log Sales - ${DateFormat.yMMMd().format(DateTime.now())}'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.yellow[100],
            child: Text(
              'Total Sales for the Day: \$${totalSales.toStringAsFixed(2)}',
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
                  subtitle:
                      Text('Selling Price: \$${product.initialSellingPrice}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () =>
                        _showLogSaleDialog(context, provider, product),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLogSaleDialog(
      BuildContext context, ProductProvider provider, Product product) {
    final quantityController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Log Sale for ${product.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Quantity Sold'),
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
                provider.logSale(
                  product,
                  int.parse(quantityController.text),
                  selectedDate,
                );
                Navigator.of(context).pop();
              },
              child: Text('Log Sale'),
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
