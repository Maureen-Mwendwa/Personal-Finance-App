import 'package:flutter/material.dart';
import 'package:spendsense/models/product.dart';
import 'package:spendsense/models/sale.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Sale> _sales = [];

  List<Product> get products => _products;
  List<Sale> get sales => _sales;

  void addProduct({
    required String name,
    required double costPrice,
    required double sellingPrice,
    required int initialQuantity,
    required DateTime date,
  }) {
    final newProduct = Product(
      name: name,
      costPrice: costPrice,
      initialSellingPrice: sellingPrice,
      initialQuantity: initialQuantity,
      remainingQuantity: initialQuantity,
      date: date,
    );
    _products.add(newProduct);
    notifyListeners();
  }

  void updateProduct(
    Product existingProduct,
    String name,
    double costPrice,
    double sellingPrice,
    int initialQuantity,
    DateTime date,
  ) {
    final updatedProduct = existingProduct.copyWith(
      name: name,
      costPrice: costPrice,
      initialSellingPrice: sellingPrice,
      initialQuantity: initialQuantity,
      remainingQuantity: initialQuantity,
      date: date,
    );
    final index =
        _products.indexWhere((product) => product.name == existingProduct.name);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String productName) {
    _products.removeWhere((product) => product.name == productName);
    notifyListeners();
  }

  void logSale(Product product, int quantitySold, double sellingPrice,
      DateTime saleDate) {
    final sale = Sale(
      productName: product.name,
      sellingPrice: product.initialSellingPrice,
      quantity: quantitySold,
      date: saleDate,
      costPrice: product.costPrice,
    );

    _sales.add(sale);
    final index = _products.indexWhere((p) => p.name == product.name);
    if (index != -1) {
      _products[index].remainingQuantity -= quantitySold;
      notifyListeners();
    }
  }

  double get totalRevenue {
    return _sales.fold(
        0, (sum, sale) => sum + (sale.sellingPrice * sale.quantity));
  }

  double get totalCost {
    return _sales.fold(0, (sum, sale) {
      final product =
          _products.firstWhere((product) => product.name == sale.productName);
      return sum + (product.costPrice * sale.quantity);
    });
  }

  double get overallProfitLoss {
    return totalRevenue - totalCost;
  }

  List<Sale> salesByDate(DateTime date) {
    return _sales.where((sale) => sale.date == date).toList();
  }
}
