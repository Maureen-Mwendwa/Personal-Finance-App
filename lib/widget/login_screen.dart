import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:spendsense/screens/expense_tracking_page.dart';

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

  Future<String?> _signupUser(SignupData data) async {
    // Here you should add logic to create a new user
    return await Future.delayed(loginTime).then((_) => null);
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
      onSignup: _signupUser,
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
