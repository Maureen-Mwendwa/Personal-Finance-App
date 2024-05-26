//models are the fundamental building blocks representing the data in the application. They define the structure of the data and ensure that it is organized and accessible in a consistent manner.
//Represents a primary expense category.
//Contains a list of subcategories.
//This structure allows easy grouping and retrieval of expenses under a specific category and sub category.
class Category {
  final String name;
  final List<String> subcategories;

  Category({required this.name, required this.subcategories});
}
