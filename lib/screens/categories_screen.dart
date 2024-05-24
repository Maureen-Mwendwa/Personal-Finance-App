import 'package:flutter/material.dart';
import 'package:spendsense/screens/analysis_screen.dart';
import 'package:spendsense/screens/subcategories_screen.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'), // Title of the AppBar.
      ),
      body: Column(
        children: [
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
            height: 100.0, // Fixed height for the bottom navigation bar.
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
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // Number of columns in the grid.
        mainAxisSpacing: 10.0, // Vertical spacing between grid items.
        crossAxisSpacing: 5.0, // Horizontal spacing between grid items.
      ),
      shrinkWrap: true, // GridView will take only the necessary space.
      itemCount: categories.length, // Number of items in the grid.
      itemBuilder: (ctx, i) {
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SubcategoriesScreen(
                    category: categories[
                        i]), // Navigate to the subcategories screen when tapped.
              ));
            },
            child: Center(
              child: Text(categories[i].name), // Display the category name.
            ),
          ),
        );
      },
    );
  }
}
