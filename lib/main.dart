import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const MyApp());
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
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
            leading: Builder(
              //The leading widget is in the top left, the actions are in the top right. The Builder is used to ensure that the context refers to that part of the subtree. That way this code snippet can be used even inside the very code that is creating the [Scaffold] (in which case, without the [Builder], the 'context' wouldn't be able to see the [Scaffold])
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
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
                  print('Account pressed');
                },
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.login, color: Colors.blue, size: 30),
                tooltip: 'Login',
                onPressed: () {
                  print('Login pressed');
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 105.0,
                    child: ElevatedButton(
                      onPressed: () => {print('Track Expenses button pressed')},
                      child: Text('Track Expenses'),
                    ),
                  ),
                  SizedBox(
                    width: 105.0,
                    child: ElevatedButton(
                      onPressed: () => {print('Manage groups button pressed')},
                      child: Text('Manage Groups'),
                    ),
                  ),
                  SizedBox(
                    width: 105.0,
                    child: ElevatedButton(
                      onPressed: () =>
                          {print('Analyze finances button pressed')},
                      child: Text('Analyze Finances'),
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
