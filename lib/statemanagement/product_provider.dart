import 'package:flutter/material.dart';
import 'package:spendsense/models/dailysales.dart';
import 'package:spendsense/models/product.dart';
import 'package:spendsense/models/productrevenue.dart';
import 'package:spendsense/models/profitloss.dart';
import 'package:spendsense/models/sale.dart';

// This class extends ChangeNotifier to enable state management in Flutter
class ProductProvider extends ChangeNotifier {
  List<Product> _products = []; // Private list to store Product objects
  List<Sale> _sales = []; // Private list to store Sale objects

  List<Product> get products =>
      _products; // Getter to access the list of products
  List<Sale> get sales => _sales; // Getter to access the list of sales

  // Method to add a new product
  void addProduct({
    required String name, // Product name (required)
    required double costPrice, // Cost price of the product (required)
    required double sellingPrice, // Selling price of the product (required)
    required int initialQuantity, // Initial quantity of the product (required)
    required DateTime date, // Date when the product was added (required)
  }) {
    //Check if the product already exists
    if (_products.any((product) => product.name == name)) {
      throw Exception('Product with this name already exists');
    }
    final newProduct = Product(
      // Create a new Product object
      name: name, // Set the product name
      costPrice: costPrice, // Set the cost price of the product
      initialSellingPrice:
          sellingPrice, // Set the initial selling price of the product
      initialQuantity:
          initialQuantity, // Set the initial quantity of the product
      remainingQuantity:
          initialQuantity, // Set the remaining quantity to the initial quantity
      date: date, // Set the date when the product was added
    );
    _products.add(newProduct); // Add the new product to the list
    notifyListeners(); // Notify listeners (UI) about the change
  }

  // Method to update an existing product
  void updateProduct(
    Product existingProduct, // The existing product to be updated
    String name, // New product name
    double costPrice, // New cost price
    double sellingPrice, // New selling price
    int initialQuantity, // New initial quantity
    DateTime date, // New date
  ) {
    final updatedProduct = existingProduct.copyWith(
      // Create a copy of the existing product with updated values
      name: name, // Set the new product name
      costPrice: costPrice, // Set the new cost price
      initialSellingPrice: sellingPrice, // Set the new initial selling price
      initialQuantity: initialQuantity, // Set the new initial quantity
      remainingQuantity:
          initialQuantity, // Set the new remaining quantity to the new initial quantity
      date: date, // Set the new date
    );
    final index = _products.indexWhere((product) =>
        product.name ==
        existingProduct
            .name); // Find the index of the existing product in the list
    if (index != -1) {
      // If the product is found in the list
      _products[index] = updatedProduct; // Update the product in the list
      notifyListeners(); // Notify listeners (UI) about the change
    }
  }

  // Method to delete a product
  void deleteProduct(String productName) {
    //Remove associated sales
    _sales.removeWhere((sale) =>
        sale.productName ==
        productName); // Remove all sales associated with the product
    //Remove the product
    _products.removeWhere((product) =>
        product.name == productName); // Remove the product from the list
    notifyListeners(); // Notify listeners (UI) about the change
  }

  // Method to log a sale
  void logSale(Product product, int quantitySold, double sellingPrice,
      DateTime saleDate) {
    final normalizedDate =
        DateTime(saleDate.year, saleDate.month, saleDate.day);
    if (product.remainingQuantity < quantitySold) {
      throw Exception('Not enough stock available');
    }
    final sale = Sale(
      // Create a new Sale object
      productName: product.name, // Set the product name
      sellingPrice: sellingPrice, // Set the selling price for the sale
      quantity: quantitySold, // Set the quantity sold
      date: normalizedDate, // Set the date of the sale
      costPrice: product.costPrice, // Set the cost price of the product
    );

    _sales.add(sale); // Add the sale to the list
    final index = _products.indexWhere((p) =>
        p.name == product.name); // Find the index of the product in the list
    if (index != -1) {
      // If the product is found in the list
      _products[index].remainingQuantity -=
          quantitySold; // Update the remaining quantity of the product
      notifyListeners(); // Notify listeners (UI) about the change
    }
  }

  // Method to delete a sale
  void deleteSale(Sale sale) {
    // Find the product associated with the sale
    Product? product;
    for (var prod in products) {
      // Loop through the list of products
      if (prod.name == sale.productName) {
        // If the product name matches the sale's product name
        product = prod; // Assign the product to the variable
        break; // Exit the loop
      }
    }

    if (product != null) {
      // If a product was found
      // Update the product's remaining quantity
      product.remainingQuantity +=
          sale.quantity; // Add the sale quantity to the remaining quantity

      // Remove the sale from the list of sales
      sales.remove(sale); // Remove the sale from the list

      // Notify listeners to update the UI
      notifyListeners(); // Notify listeners (UI) about the change
    }
  }

  // Method to update a sale
  void updateSale(
      Sale existingSale, int quantity, double sellingPrice, DateTime date) {
    final updatedSale = Sale(
      // Create a new Sale object with updated values
      productName: existingSale.productName, // Set the product name
      quantity: quantity, // Set the new quantity
      sellingPrice: sellingPrice, // Set the new selling price
      costPrice:
          existingSale.costPrice, // Set the cost price from the existing sale
      date: date, // Set the new date
    );

    final saleIndex = _sales.indexWhere((sale) =>
        sale ==
        existingSale); // Find the index of the existing sale in the list
    if (saleIndex != -1) {
      // If the sale is found in the list
      _sales[saleIndex] = updatedSale; // Update the sale in the list

      // Update the remaining quantity of the product
      final product = _products.firstWhere((p) =>
          p.name ==
          existingSale
              .productName); // Find the product associated with the sale
      final productIndex = _products
          .indexOf(product); // Get the index of the product in the list
      _products[productIndex].remainingQuantity += existingSale.quantity -
          quantity; // Update the remaining quantity of the product based on the quantity change

      notifyListeners(); // Notify listeners (UI) about the change
    }
  }

  // Getter to calculate the total revenue
  double get totalRevenue {
    return _sales.fold(
        // Use the fold method to calculate the total revenue
        0,
        (sum, sale) =>
            sum +
            (sale.sellingPrice *
                sale.quantity)); // Sum up the revenue for each sale
  }

  // Getter to calculate the total cost
  double get totalCost {
    return _sales.fold(0, (sum, sale) {
      // Use the fold method to calculate the total cost
      final product = _products.firstWhere((product) =>
          product.name ==
          sale.productName); // Find the product associated with the sale
      return sum +
          (product.costPrice * sale.quantity); // Sum up the cost for each sale
    });
  }

  // Getter to calculate the overall profit/loss
  double get overallProfitLoss {
    return totalRevenue -
        totalCost; // Calculate the overall profit/loss by subtracting the total cost from the total revenue
  }

  // Method to get a list of sales for a specific date
  List<Sale> salesByDate(DateTime date) {
    return _sales
        .where((sale) => sale.date == date)
        .toList(); // Filter the list of sales by date and convert to a list
  }

  // Method to get daily sales data
  List<DailySales> getDailySalesData() {
    Map<DateTime, double> salesMap =
        {}; // Initialize an empty map to store total sales for each date
    Map<DateTime, double> profitLossMap =
        {}; // Initialize an empty map to store total profit/loss for each date

    for (var sale in _sales) {
      final normalizedDate =
          DateTime(sale.date.year, sale.date.month, sale.date.day);
      // Iterate over each sale in the _sales list
      salesMap[normalizedDate] = (salesMap[normalizedDate] ?? 0) +
          (sale.sellingPrice *
              sale.quantity); // Update the total sales for the sale's date
      profitLossMap[normalizedDate] = (profitLossMap[normalizedDate] ?? 0) +
          ((sale.sellingPrice - sale.costPrice) *
              sale.quantity); // Update the total profit/loss for the sale's date
    }
    return salesMap.entries.map((entry) {
      // Convert the salesMap to a list of DailySales objects
      return DailySales(
          entry.key,
          entry.value,
          profitLossMap[entry.key] ??
              0); // Create a DailySales object with date, total sales, and total profit/loss
    }).toList();
  }

  // Method to get product revenue data
  List<ProductRevenue> getProductRevenueData() {
    Map<String, double> revenueMap =
        {}; // Initialize an empty map to store total revenue for each product

    for (var sale in _sales) {
      // Iterate over each sale in the _sales list
      revenueMap[sale.productName] = (revenueMap[sale.productName] ?? 0) +
          (sale.sellingPrice *
              sale.quantity); // Update the total revenue for the sale's product
    }
    return revenueMap.entries.map((entry) {
      // Convert the revenueMap to a list of ProductRevenue objects
      return ProductRevenue(
          entry.key,
          entry
              .value); // Create a ProductRevenue object with product name and total revenue
    }).toList();
  }

  // Method to get profit/loss data for each product
  List<ProfitLoss> getProfitLossData() {
    Map<String, double> profitLossMap =
        {}; // Initialize an empty map to store total profit/loss for each product

    for (var sale in _sales) {
      // Iterate over each sale in the _sales list
      profitLossMap[sale.productName] = (profitLossMap[sale.productName] ?? 0) +
          ((sale.sellingPrice - sale.costPrice) *
              sale.quantity); // Update the total profit/loss for the sale's product
    }
    return profitLossMap.entries.map((entry) {
      // Convert the profitLossMap to a list of ProfitLoss objects
      return ProfitLoss(
          entry.key,
          entry
              .value); // Create a ProfitLoss object with product name and total profit/loss
    }).toList();
  }
}
