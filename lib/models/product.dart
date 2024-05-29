class Product {
  final String name;
  final double costPrice;
  final double initialSellingPrice;
  final int initialQuantity;
  int remainingQuantity; // Remove 'final'
  final DateTime date;

  Product({
    required this.name,
    required this.costPrice,
    required this.initialSellingPrice,
    required this.initialQuantity,
    required this.remainingQuantity,
    required this.date,
  });

  Product copyWith({
    String? name,
    double? costPrice,
    double? initialSellingPrice,
    int? initialQuantity,
    int? remainingQuantity,
    DateTime? date,
  }) {
    return Product(
      name: name ?? this.name,
      costPrice: costPrice ?? this.costPrice,
      initialSellingPrice: initialSellingPrice ?? this.initialSellingPrice,
      initialQuantity: initialQuantity ?? this.initialQuantity,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
      date: date ?? this.date,
    );
  }
}
