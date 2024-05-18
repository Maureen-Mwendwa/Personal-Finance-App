import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:spendsense/screens/expense_tracking_page.dart';
import 'package:spendsense/screens/finance_page.dart';
import 'package:spendsense/screens/group_page.dart';
import 'package:spendsense/statemanagement/expense_provider.dart';
import 'package:spendsense/widget/login_screen.dart';
import 'package:spendsense/widget/mycustomform.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ExpenseProvider()),
      Provider(create: (context) => ExpenseTrackingPage()),
      Provider(create: (context) => FinancePage()),
      Provider(create: (context) => GroupPage()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Finance App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage(),
        routes: {
          '/expensetrackingpage': (context) => ExpenseTrackingPage(),
          '/grouppage': (context) => GroupPage(),
          '/financepage': (context) => FinancePage(),
        });
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
            // leading: Builder(
            //The leading widget is in the top left, the actions are in the top right. The Builder is used to ensure that the context refers to that part of the subtree. That way this code snippet can be used even inside the very code that is creating the [Scaffold] (in which case, without the [Builder], the 'context' wouldn't be able to see the [Scaffold])
            // builder: (BuildContext context) {
            // return IconButton(
            //   icon: const Icon(Icons.menu),
            //   onPressed: () {
            //     Scaffold.of(context).openDrawer();
            //   },
            //   tooltip:
            //       MaterialLocalizations.of(context).openAppDrawerTooltip,
            // );
            // }
            // ),
            title: Text('Welcome!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    foreground: Paint()
                      // ..style = PaintingStyle.stroke
                      // ..strokeWidth = 6
                      // ..color = Colors.blue[700]!
                      ..shader = ui.Gradient.linear(
                        const Offset(0, 20),
                        const Offset(150, 20),
                        <Color>[
                          Colors.red,
                          Colors.yellow,
                        ],
                      ))),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.account_box,
                    color: Colors.green, size: 30),
                tooltip: 'Create A New Account',
                onPressed: () {
                  //Show a dialog to create a new account
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Create Account'),
                      content: MyCustomForm(),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        //   //call the form submission logic from custom form
                        //   //Assuming having a method like 'submitForm' in the form widget e.g.
                        //   //if(MyCustomForm.submitForm()){
                        //   //Implement account creation logic here Navigator.pop(context);}
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.login, color: Colors.blue, size: 30),
                tooltip: 'Login',
                onPressed: () {
                  //Show a dialog to create a new account
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Login to your account'),
                      content: LoginScreen(),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.red, size: 30),
                tooltip: 'Logout',
                onPressed: () {
                  print('Logout pressed');
                },
              ),
            ]),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Logo image
              Container(
                height: 300.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage('assets/Logo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              // Text with finance management features
              Container(
                  color: Color.fromARGB(255, 4, 56, 99),
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text(
                    'Track, Manage, and Grow Your Finances Effortlessly',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
              SizedBox(height: 10.0),
              Text(
                'Your all-in-one financial companion for meticulous expense tracking, collaborative group finance management, and insghtful business financial analysis.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20.0),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow),
                      onPressed: () {
                        //Show a dialog to create a new account
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Create Account'),
                            content: MyCustomForm(),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Get Started',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
