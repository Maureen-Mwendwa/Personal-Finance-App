import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/models/product.dart';
import 'package:spendsense/screens/product_modal.dart';
import 'package:spendsense/statemanagement/product_provider.dart';
// Importing the intl package for internationalizing and formatting dates.
import 'package:intl/intl.dart';

class ProductListPage extends StatefulWidget {
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  // Creating a TextEditingController to control the search input field.
  // This will be used to retrieve the text entered by the user in the search bar.
  final _searchController = TextEditingController();
  // Variable to hold the current search query entered by the user.
  String _searchQuery = '';

  // Overriding the dispose method to clean up the controller when the widget is disposed.
  @override
  void dispose() {
    // Disposing the search controller to free up resources.
    _searchController.dispose();
    // Calling the dispose method of the superclass.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Returning a Scaffold widget which provides the basic structure of the screen.
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Product Inventory - Date Today ${DateFormat.yMMMd().format(DateTime.now())}'),
        centerTitle: true,
        backgroundColor: Colors.purple[300],
        // Customizing the shape of the app bar to have rounded corners at the bottom.
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25))),
        // Adding action buttons to the app bar.
        actions: [
          IconButton(
            icon: Icon(Icons.attach_money),
            // Setting a tooltip that appears when the user hovers over the button.
            tooltip: 'Navigate to enter/view your sales',
            onPressed: () {
              // Navigating to the sales logging page using a named route.
              Navigator.pushNamed(context, '/salesloggingpage');
            },
          ),
          IconButton(
            icon: Icon(Icons.show_chart),
            // Setting a tooltip that appears when the user hovers over the button.
            tooltip: 'View Visualizations',
            onPressed: () {
              // Navigating to the product analysis screen using a named route.
              Navigator.pushNamed(context, '/productanalysisscreen');
            },
          ),
        ],
      ),
      // Using the Consumer widget to listen to changes in the ProductProvider.
      // The Consumer widget rebuilds when the provider changes.
      body: Consumer<ProductProvider>(
        // The builder function defines how the UI should be updated when the provider changes.
        builder: (context, provider, child) {
          // Calculating the total valuation of the products.
          // fold method is used to iterate over the products and sum their valuations.
          double totalValuation = provider.products.fold(
            0.0,
            (sum, product) =>
                sum + (product.initialSellingPrice * product.remainingQuantity),
          );

          // Filtering the products based on the search query.
          // The where method is used to filter products that match the search query.
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  // Creating a TextField widget for the search bar.
                  child: TextField(
                    // Associating the search controller with the TextField.
                    controller: _searchController,
                    // Defining the onChanged callback to update the search query when the user types.
                    onChanged: (value) {
                      // Using setState to update the search query and rebuild the widget.
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    // Adding decoration to the TextField.
                    decoration: InputDecoration(
                      // Placeholder text for the search bar.
                      hintText: 'Search products',
                      // Adding a search icon at the beginning of the TextField.
                      prefixIcon: Icon(Icons.search),
                      // Adding an outline border with rounded corners to the TextField.
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
                  // Displaying the total valuation in a Text widget.
                  child: Text(
                    'Total Valuation: \$${totalValuation.toStringAsFixed(2)}',
                    // Styling the text with a larger font size and bold weight.
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Using an Expanded widget to make the ListView take the remaining space.
              Expanded(
                // Creating a ListView.builder to build a list of filtered products.
                child: ListView.builder(
                  // Setting the item count to the number of filtered products.
                  itemCount: filteredProducts.length,
                  // Defining the itemBuilder function to build each item in the list.
                  itemBuilder: (context, index) {
                    // Getting the current product from the filtered products list.
                    final product = filteredProducts[index];
                    // Returning a Material widget to create a ListTile for the product.
                    return Material(
                      // Creating a ListTile widget to display the product information.
                      child: ListTile(
                        // Setting the title of the ListTile to the product name.
                        title: Text(product.name),
                        // Setting the subtitle of the ListTile to display product details.
                        subtitle: Text(
                          'Cost: \$${product.costPrice}, Selling: \$${product.initialSellingPrice}, Initial Qty: ${product.initialQuantity}, Remaining: ${product.remainingQuantity}, Date: ${DateFormat.yMMMd().format(product.date)}',
                        ),
                        // Making the ListTile appear selected.
                        selected: true,
                        // Setting the background color of the selected ListTile.
                        selectedTileColor: Colors.amber[200],
                        // Defining the onTap callback for the ListTile.
                        onTap: () {},
                        // Adding trailing icons to the ListTile for editing and deleting the product.
                        trailing: Row(
                          // Setting the main axis size to minimum to fit the icons.
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              // Defining the onPressed callback to show the edit product modal.
                              onPressed: () {
                                _showEditProductModal(
                                    context, provider, product);
                              },
                            ),
                            // Delete button
                            Container(
                              // Wrapping the delete icon button in a Container to style it.
                              child: IconButton(
                                icon: Icon(Icons.delete),
                                // Defining the onPressed callback to delete the product.
                                onPressed: () {
                                  provider.deleteProduct(product.name);
                                },
                              ),
                              // Adding a circular shape and red background to the delete button.
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              // Aligning the delete button to the center.
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
      // Adding a floating action button to add new products.
      floatingActionButton: FloatingActionButton(
        // Setting the background color of the button to green.
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        // Setting a tooltip that appears when the user hovers over the button.
        tooltip: 'Add Products',
        // Defining the onPressed callback to show the add product modal.
        onPressed: () {
          _showAddProductModal(context);
        },
        // Setting the icon of the button to a plus symbol.
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // Function to show the add product modal.
  void _showAddProductModal(BuildContext context) {
    // Showing a dialog with the add product modal.
    showDialog(
      context: context,
      builder: (context) {
        // Centering the modal on the screen.
        return Center(
          // Returning the ProductModal widget to add a new product.
          child: ProductModal(),
        );
      },
    );
  }

  // Function to show the edit product modal.
  void _showEditProductModal(
      BuildContext context, ProductProvider provider, Product product) {
    // Creating controllers for the text fields in the edit modal.
    final nameController = TextEditingController(text: product.name);
    final costPriceController =
        TextEditingController(text: product.costPrice.toString());
    final sellingPriceController =
        TextEditingController(text: product.initialSellingPrice.toString());
    final quantityController =
        TextEditingController(text: product.initialQuantity.toString());
    // Variable to hold the selected date for the product.
    DateTime selectedDate = product.date;

    // Showing a dialog with the edit product modal.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Setting the title of the dialog.
          title: Text('Edit Product ${product.name}'),
          // Adding a SingleChildScrollView to allow scrolling if content overflows.
          content: SingleChildScrollView(
            // Adding a Column widget to layout the text fields vertically.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Adding a TextField for the product name.
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                ),
                // Adding a TextField for the cost price.
                TextField(
                  controller: costPriceController,
                  decoration: InputDecoration(labelText: 'Cost Price'),
                  keyboardType: TextInputType.number,
                ),
                // Adding a TextField for the selling price.
                TextField(
                  controller: sellingPriceController,
                  decoration: InputDecoration(labelText: 'Selling Price'),
                  keyboardType: TextInputType.number,
                ),
                // Adding a TextField for the initial quantity.
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Initial Quantity'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                // Adding a text to indicate date selection.
                Text(
                  'Select Date:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                // Adding a space of 10 pixels height.
                SizedBox(height: 10),
                // Adding a button to select the date.
                ElevatedButton(
                  onPressed: () async {
                    // Showing a date picker to select the date.
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(3000),
                    );
                    // Updating the selected date if a new date is picked.
                    if (picked != null && picked != selectedDate)
                      selectedDate = picked;
                  },
                  // Setting the button text to "Select Date".
                  child: Text("Select Date"),
                ),
                // Displaying the selected date.
                Text(
                  "${DateFormat.yMMMd().format(selectedDate)}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Adding actions (buttons) to the dialog.
          actions: [
            // Adding a button to update the product.
            ElevatedButton(
              onPressed: () {
                // Calling the updateProduct method of the provider to update the product.
                provider.updateProduct(
                  product,
                  nameController.text,
                  double.parse(costPriceController.text),
                  double.parse(sellingPriceController.text),
                  int.parse(quantityController.text),
                  selectedDate,
                );
                // Closing the dialog.
                Navigator.of(context).pop();
              },
              // Setting the button text to "Update Product".
              child: Text('Update Product'),
            ),
            // Adding a button to cancel the edit operation.
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              // Setting the button text to "Cancel".
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
