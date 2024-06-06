import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/models/product.dart';
import 'package:spendsense/screens/product_modal.dart';
import 'package:spendsense/statemanagement/product_provider.dart';
import 'package:intl/intl.dart';

class ProductListPage extends StatefulWidget {
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Product Inventory - Date Today ${DateFormat.yMMMd().format(DateTime.now())}'),
        centerTitle: true,
        backgroundColor: Colors.purple[300],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25))),
        actions: [
          IconButton(
            icon: Icon(Icons.attach_money),
            tooltip: 'Navigate to enter/view your sales',
            onPressed: () {
              Navigator.pushNamed(context, '/salesloggingpage');
            },
          ),
          IconButton(
            icon: Icon(Icons.show_chart),
            tooltip: 'View Visualizations',
            onPressed: () {
              Navigator.pushNamed(context, '/productanalysisscreen');
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

          // Filter the products based on the search query
          final filteredProducts = provider.products
              .where((product) => product.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();

          return Column(
            children: [
              SizedBox(height: 10),
              SizedBox(
                width: 250,
                child: Container(
                  // search bar
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search products',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 500,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.amber,
                  child: Text(
                    'Total Valuation: \$${totalValuation.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return Material(
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          'Cost: \$${product.costPrice}, Selling: \$${product.initialSellingPrice}, Initial Qty: ${product.initialQuantity}, Remaining: ${product.remainingQuantity}, Date: ${DateFormat.yMMMd().format(product.date)}',
                        ),
                        selected: true,
                        selectedTileColor: Colors.amber[200],
                        onTap: () {},
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showEditProductModal(
                                    context, provider, product);
                              },
                            ),
                            Container(
                              child: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  provider.deleteProduct(product.name);
                                },
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              alignment: Alignment.center,
                            ),
                          ],
                        ),
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
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        tooltip: 'Add Products',
        onPressed: () {
          _showAddProductModal(context);
        },
        child: Icon(Icons.add, color: Colors.white, size: 28),
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
