import 'package:flutter/material.dart';
import 'package:spendsense/screens/subcategories_screen.dart';
import '../models/category.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Category> categories = [
    Category(name: 'Housing', subcategories: [
      'Rent/Mortgage',
      'Utilities',
      'Home maintenance and Repairs'
    ]),
    Category(
        name: 'Healthcare',
        subcategories: ['Medical Bills', 'Insurance premiums']),
    // Add other categories and subcategories here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
        ),
        itemCount: categories.length,
        itemBuilder: (ctx, i) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      SubcategoriesScreen(category: categories[i]),
                ));
              },
              child: Center(
                child: Text(categories[i].name),
              ),
            ),
          );
        },
      ),
    );
  }
}
