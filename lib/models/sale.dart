class Sale {
  final String productName;
  final int quantity;
  final double sellingPrice;
  final double costPrice; // Rename this field if necessary
  final DateTime date;

  Sale({
    required this.productName,
    required this.quantity,
    required this.sellingPrice,
    required this.costPrice, // Rename this field if necessary
    required this.date,
  });
}
