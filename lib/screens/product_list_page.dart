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
          return ListView.builder(
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final product = provider.products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(
                  'Cost: \$${product.costPrice}, Selling: \$${product.initialSellingPrice}, Initial Qty: ${product.initialQuantity}, Remaining: ${product.remainingQuantity}',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    provider.deleteProduct(product.name);
                  },
                ),
                onTap: () {
                  _showEditProductModal(context, product);
                },
              );
            },
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

  void _showEditProductModal(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: ProductModal(product: product),
        );
      },
    );
  }
}
