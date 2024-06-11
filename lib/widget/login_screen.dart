import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:spendsense/screens/categories_screen.dart';
import 'package:spendsense/widget/mycustomform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Duration for the simulated delay during login
  Duration get loginTime => const Duration(milliseconds: 2250);

  // Method to authenticate the user by checking Firestore
  Future<String?> _authUser(LoginData data) async {
    try {
      // Query the Firestore 'users' collection to find the document where the email field matches the provided email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('Email', isEqualTo: data.name)
          .get();

      // If no documents are found, return an error message
      if (querySnapshot.docs.isEmpty) {
        return 'User does not exist';
      }

      // Get the user data from the first document found
      final userData = querySnapshot.docs.first.data();

      // If the password doesn't match, return an error message
      if (userData['Password'] != data.password) {
        return 'Password does not match';
      }

      // If everything is correct, return null indicating a successful login
      return null;
    } catch (e) {
      // If there is any error during the process, return an error message
      return 'An error occurred. Please try again.';
    }
  }

  // Method to handle user signup by showing a dialog
  Future<String?> _signupUser(BuildContext context) async {
    // Show a dialog to create a new account
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create a new account'), // Title of the dialog
          content:
              MyCustomForm(), // Content of the dialog, which is a custom form for user input
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context,
                    'cancel'); // Close the dialog if 'Cancel' is pressed
              },
              child: Text('Cancel'),
            ),
            // You can add another TextButton here for 'Submit' to handle form submission
          ],
        );
      },
    );
  }

  // Method to recover the user's password
  Future<String?> _recoverPassword(String name) async {
    try {
      // Query the Firestore 'users' collection to find the document where the email field matches the provided email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: name)
          .get();

      // If no documents are found, return an error message
      if (querySnapshot.docs.isEmpty) {
        return 'User does not exist';
      }

      // Add logic to send password recovery email or show instructions (currently not implemented)
      return null;
    } catch (e) {
      // If there is any error during the process, return an error message
      return 'An error occurred. Please try again.';
    }
  }

  // Build method to create the UI
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'SpendSense', // Title of the login screen
      logo: const AssetImage('assets/SpendSenseLogo.webp'), // Logo image
      onLogin: _authUser, // Method to call on login
      onSignup: (signupData) =>
          _signupUser(context), // Method to call on signup
      onSubmitAnimationCompleted: () {
        // Navigate to CategoriesScreen after the submit animation completes
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CategoriesScreen(),
          ),
        );
      },
      onRecoverPassword:
          _recoverPassword, // Method to call on password recovery
    );
  }
}
