//A page to log sales and calculate revenue, cost, and profit/loss
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/models/product.dart';
import 'package:spendsense/models/sale.dart';
import 'package:spendsense/statemanagement/product_provider.dart';
import 'package:intl/intl.dart';

class SalesLoggingPage extends StatefulWidget {
  @override
  State<SalesLoggingPage> createState() => _SalesLoggingPageState();
}

class _SalesLoggingPageState extends State<SalesLoggingPage> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Sales - ${DateFormat.yMMMd().format(_selectedDate)}'),
        actions: [
          IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(3000),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              })
        ],
      ),
      body: Column(
        children: [
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              final totalSales = provider.totalSalesByDate(_selectedDate);
              //  provider.sales.fold(
              //   0.0,
              //   (sum, sale) => sum + (sale.sellingPrice * sale.quantity),
              // );

              return Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.yellow[100],
                child: Text(
                  'Total Sales For ${DateFormat.yMMMd().format(_selectedDate)}: \$ ${totalSales.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.products.isEmpty) {
                  return Center(child: Text('No products available.'));
                }

                return ListView.builder(
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    final product = provider.products[index];
                    final sales = provider.sales
                        .where((sale) => sale.productName == product.name)
                        .toList();

                    return ListTile(
                      title: Text(product.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cost: \$${product.costPrice.toStringAsFixed(2)}, '
                            'Selling: \$${product.initialSellingPrice.toStringAsFixed(2)}, '
                            'Remaining Qty: ${product.remainingQuantity}',
                          ),
                          for (var sale in sales)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sold ${sale.quantity} @ \$${sale.sellingPrice.toStringAsFixed(2)} each on ${DateFormat.yMMMd().format(sale.date)}',
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          _showEditSaleDialog(
                                              context, provider, sale);
                                        }),
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          provider.deleteSale(sale);
                                        }),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          _showLogSaleDialog(context, provider, product);
                        },
                      ),
                    );
                  },
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
    final sellingPriceController = TextEditingController(
      text: product.initialSellingPrice.toString(),
    );
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
                TextField(
                  controller: sellingPriceController,
                  decoration: InputDecoration(labelText: 'Final Selling Price'),
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
                  double.parse(sellingPriceController.text),
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

  void _showEditSaleDialog(
      BuildContext context, ProductProvider provider, Sale sale) {
    final quantityController =
        TextEditingController(text: sale.quantity.toString());
    final sellingPriceController =
        TextEditingController(text: sale.sellingPrice.toString());
    DateTime selectedDate = sale.date;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Sale for ${sale.productName}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Quantity Sold'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: sellingPriceController,
                  decoration: InputDecoration(labelText: 'Final Selling Price'),
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
                provider.updateSale(
                  sale,
                  int.parse(quantityController.text),
                  double.parse(sellingPriceController.text),
                  selectedDate,
                );
                Navigator.of(context).pop();
              },
              child: Text('Update Sale'),
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
