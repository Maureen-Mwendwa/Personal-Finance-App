class Product {
  // This is a final instance variable, which means its value cannot be changed once assigned
  // It holds the name of the product as a String
  final String name;

  // This is a final instance variable that holds the cost price of the product as a double
  final double costPrice;

  // This is a final instance variable that holds the initial selling price of the product as a double
  final double initialSellingPrice;

  // This is a final instance variable that holds the initial quantity of the product as an integer
  final int initialQuantity;

  // This is an instance variable that holds the remaining quantity of the product as an integer
  // It is not marked as final, which means its value can be changed after initialization
  int remainingQuantity;

  // This is a final instance variable that holds the date associated with the product as a DateTime
  final DateTime date;

  // This is the constructor for the Product class
  // It takes in all the instance variables as required named parameters
  Product({
    required this.name, // The value passed in for the name parameter is assigned to the name instance variable
    required this.costPrice, // The value passed in for the costPrice parameter is assigned to the costPrice instance variable
    required this.initialSellingPrice, // The value passed in for the initialSellingPrice parameter is assigned to the initialSellingPrice instance variable
    required this.initialQuantity, // The value passed in for the initialQuantity parameter is assigned to the initialQuantity instance variable
    required this.remainingQuantity, // The value passed in for the remainingQuantity parameter is assigned to the remainingQuantity instance variable
    required this.date, // The value passed in for the date parameter is assigned to the date instance variable
  });

  // This is a method that creates a new instance of the Product class with the same properties as the current instance
  // It takes in optional parameters that allow specific properties to be overridden with new values
  Product copyWith({
    String?
        name, // An optional named parameter that allows you to override the name property with a new value
    double?
        costPrice, // An optional named parameter that allows you to override the costPrice property with a new value
    double?
        initialSellingPrice, // An optional named parameter that allows you to override the initialSellingPrice property with a new value
    int?
        initialQuantity, // An optional named parameter that allows you to override the initialQuantity property with a new value
    int?
        remainingQuantity, // An optional named parameter that allows you to override the remainingQuantity property with a new value
    DateTime?
        date, // An optional named parameter that allows you to override the date property with a new value
  }) {
    // A new instance of the Product class is created with the following properties:
    return Product(
      name: name ??
          this.name, // If a new name is provided, use it; otherwise, use the current instance's name
      costPrice: costPrice ??
          this.costPrice, // If a new costPrice is provided, use it; otherwise, use the current instance's costPrice
      initialSellingPrice: initialSellingPrice ??
          this.initialSellingPrice, // If a new initialSellingPrice is provided, use it; otherwise, use the current instance's initialSellingPrice
      initialQuantity: initialQuantity ??
          this.initialQuantity, // If a new initialQuantity is provided, use it; otherwise, use the current instance's initialQuantity
      remainingQuantity: remainingQuantity ??
          this.remainingQuantity, // If a new remainingQuantity is provided, use it; otherwise, use the current instance's remainingQuantity
      date: date ??
          this.date, // If a new date is provided, use it; otherwise, use the current instance's date
    );
  }
}
