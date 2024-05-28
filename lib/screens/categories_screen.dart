import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsense/screens/analysis_screen.dart';
import 'package:spendsense/screens/subcategories_screen.dart';
import 'package:spendsense/statemanagement/expenses_provider.dart';
import '../models/category.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final PageController pageController = PageController(
      initialPage: 0); // Controller to manage the pages in the PageView.
  int _selectedIndex = 0; // To keep track of the currently selected page/index.

  // List of categories, each with a name and a list of subcategories.
  final List<Category> categories = [
    Category(name: 'Housing', subcategories: [
      'Rent/Mortgage',
      'Utilities(electricity, gas, water, internet, etc)',
      'Home Maintenance and Repairs'
    ]),
    Category(
      name: 'Healthcare',
      subcategories: ['Medical Bills', 'Insurance premiums'],
    ),
    Category(
      name: 'Personalcare',
      subcategories: [
        'Haircuts and Grooming',
        'Cosmetics and Beauty Products',
        'Gym Memberships'
      ],
    ),
    Category(
      name: 'Food and Dining',
      subcategories: ['Groceries', 'Dining Out', 'Takeout/Delivery'],
    ),
    Category(
      name: 'Transportation',
      subcategories: [
        'Gas and Fuel',
        'Public Transportation',
        'Car Payments, Insurance, and Maintenance'
      ],
    ),
    Category(
      name: 'Financial',
      subcategories: [
        'Credit Card Payments',
        'Loan Repayments',
        'Investment contributions'
      ],
    ),
    Category(
      name: 'Education',
      subcategories: [
        'Tuition and Fees',
        'Books and Supplies',
        'Student Loan Payments'
      ],
    ),
    Category(
      name: 'Subscriptions and Memberships',
      subcategories: [
        'Streaming Services',
        'Magazine/Newspaper Subscriptions',
        'Professional Memberships'
      ],
    ),
    Category(
      name: 'Entertainment and Recreation',
      subcategories: [
        'Movies, Concerts, and Events',
        'Hobbies and Leisure Activities',
        'Travel and Vacations'
      ],
    ),
    Category(
      name: 'Charitable Giving',
      subcategories: [
        'Donations to Non-Profit Organizations',
        'Sponsorships and Fundraising contributions'
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String currentMonth = "${now.month}/${now.year}";
    final String currentDate = "${now.day}";
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Categories'), // Title of the AppBar.
      // ),
      body: Column(
        children: [
          SizedBox(
            height: 100.0,
            child: Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                leading: const Image(
                  image: AssetImage('assets/SpendSenseLogo.jpeg'),
                ),
                title: Text('Spending Awareness & Money Management',
                    style: TextStyle(fontSize: 20)),
                trailing: Stack(
                  children: [
                    Icon(Icons.calendar_today, size: 45.0, color: Colors.green),
                    Positioned(
                      // top: -7,
                      // right: -5,
                      // child: Container(
                      //   padding: EdgeInsets.all(3.0),
                      //   decoration: BoxDecoration(
                      //     color: Colors.black,
                      //     borderRadius: BorderRadius.circular(5.0),
                      //   ),
                      child: Text(
                        '$currentMonth\n$currentDate',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      //),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Total spendings container
          Consumer<ExpensesProvider>(
            builder: (context, expensesProvider, child) {
              double totalSpendings = expensesProvider.expenses
                  .fold(0.0, (sum, expense) => sum + expense.amount);
              return Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                width: double
                    .infinity, //make the container take the full width of the screen.
                height: 70.0,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20.0), // Rounded corners
                ),
                child: Center(
                  child: Text(
                    'Total Spendings: \$${totalSpendings.toStringAsFixed(2)}',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: PageView(
              controller:
                  pageController, // PageController to manage the page transitions.
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex =
                      index; // Update the selected index when the page changes.
                });
              },
              children: [
                _buildCategoryGrid(
                    context), // Grid of categories as the first page.
                AnalyticsScreen(), // Analytics screen as the second page.
              ],
            ),
          ),
          SizedBox(
            height: 60.0, // Fixed height for the bottom navigation bar.
            child: BottomNavigationBar(
              type: BottomNavigationBarType
                  .fixed, // Fixed type to show all items.
              backgroundColor:
                  Colors.purple, // Background color of the navigation bar.
              currentIndex: _selectedIndex, // Highlight the selected item.
              selectedItemColor: Colors.white, // Color of the selected item.
              unselectedItemColor:
                  Colors.black, // Color of the unselected items.
              onTap: (index) {
                setState(() {
                  _selectedIndex = index; // Update the selected index.
                  pageController
                      .jumpToPage(index); // Navigate to the selected page.
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: 'Analytics',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a grid of category cards.
  Widget _buildCategoryGrid(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      //The LayoutBuilder helps in deciding the number of columns based on the available width.
      // Calculate the number of columns based on the screen width.
      int crossAxisCount = (constraints.maxWidth / 150)
          .floor(); // The number of columns (crossAxisCount) is calculated by dividing the maximum width by the desired width of each card (e.g., 150 pixels).
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 10.0, // Vertical spacing between grid items.
          crossAxisSpacing: 5.0, // Horizontal spacing between grid items.
        ),
        shrinkWrap: true, // GridView will take only the necessary space.
        itemCount: categories.length, // Number of items in the grid.
        itemBuilder: (ctx, i) {
          final category = categories[i];
          final imagePath = _getCategoryImagePath(category.name);
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SubcategoriesScreen(category: category),
                )); // Navigate to the subcategories screen when tapped.
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit
                        .cover, // Ensures the image covers the entire card.
                  ),
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: Center(
                  child: Text(
                    category.name, // Display the category name.
                    style: TextStyle(
                      backgroundColor: Colors
                          .black54, // Semi-transparent background for text.
                      color: Colors.white, // White text color.
                      fontWeight: FontWeight.bold, // Bold text.
                      fontSize: 16.0, // Font size.
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // Method to get the image path based on category name.
  String _getCategoryImagePath(String categoryName) {
    switch (categoryName) {
      case 'Housing':
        return 'assets/Housing.jpg';
      case 'Healthcare':
        return 'assets/Healthcare.jpg';
      case 'Personalcare':
        return 'assets/Personalcare.jpg';
      case 'Food and Dining':
        return 'assets/FoodDining.jpg';
      case 'Transportation':
        return 'assets/Transportation.jpg';
      case 'Financial':
        return 'assets/Financial.jpg';
      case 'Education':
        return 'assets/Education.jpg';
      case 'Subscriptions and Memberships':
        return 'assets/Subscriptions.jpg';
      case 'Entertainment and Recreation':
        return 'assets/Entertainment.jpg';
      case 'Charitable Giving':
        return 'assets/Charitable giving.jpg';
      default:
        return 'assets/SpendSenseLogo.jpeg';
    }
  }
}
