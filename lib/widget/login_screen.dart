import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:spendsense/screens/expense_tracking_page.dart';
import 'package:spendsense/widget/mycustomform.dart';

// Define a constant users map that stores user credentials.
const users = {
  'mwendwaamaureen@gmail.com': 'Mugambi#12345',
};

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    return await Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User does not exist';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null; // Indicates successful login
    });
  }

  Future<String?> _signupUser(BuildContext context) async {
    // Show a dialog to create a new account
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create a new account'),
          content: MyCustomForm(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'cancel');
              },
              child: Text('Cancel'),
            ),
            // TextButton(
            //   onPressed: () {
            //     // Here you should add logic to handle form submission
            //     // For demonstration purposes, we will just pop with a success message
            //     Navigator.pop(context, 'success');
            //   },
            //   child: Text('Submit'),
            // ),
          ],
        );
      },
    );
    // .then((result) {
    //   if (result == 'success') {
    //     // Add your user creation logic here, e.g., call to an API
    //     return Future.delayed(loginTime)
    //         .then((_) => null); // Simulate delay for user creation
    //   } else {
    //     return null; // User cancelled the signup process
    //   }
    // });
  }

  Future<String?> _recoverPassword(String name) async {
    return await Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User does not exist';
      }
      // Here you should add logic to recover the password
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'SpendSense',
      logo: const AssetImage('assets/SpendSenseLogo.jpeg'),
      onLogin: _authUser,
      onSignup: (signupData) => _signupUser(context),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ExpenseTrackingPage(),
          ),
        );
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
