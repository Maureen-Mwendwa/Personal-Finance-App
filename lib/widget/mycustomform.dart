import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

//Define a custom Form widget
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

//Define a corresponding State class
//This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  //Create a global key that uniquely identifies the Form widget
  //and allows validation of the form.
  //Note: This is a 'GlobalKey<FormState>', not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  // Expose the _formKey as a getter
  GlobalKey<FormState> get formKey => _formKey;
  final _passwordController =
      TextEditingController(); //creating an instance of the TextEditingController class using TextEditingController() constructor and assigning it to the variable _passwordController which is private to indicate that it is accessible only within the current class or file. TextEditingController is used to manage the text input in text fields. It provides various properties and methods to interact with the text, such as retrieving the current text value, setting the text value, and adding listeners to monitor text changes. By creating an instance of TextEditingController, you can associate it with a TextField or TextFormField widget using the controller property. This allows you to access and control the text input programmatically. i.e. TextField(controller: _passwordController). By doing this, you can access the text value entered by the user using _passwordController.text, set the initial text value using _passwordController.text = 'initial value', or listen to text changes using _passwordController.addListener((){/*handle text changes*/}. NB: TextEditingController instances should be disposed of when they are no longer needed to avoid memory leaks.
  final _emailController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  //_formKey.currentState returns an instance of FormState?, which means it can either be a FormState object or null. The null assertion operator ! is used to assert that _formKey.currentState is not null before calling the validate() method on the FormState instance associated with the Form widget.  //Validate returns true if the form is valid, or false otherwise.

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        //Create User with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        //Add user details to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'Email': _emailController.text,
          'Password': _passwordController.text
        }); //Store hashed password in prectice
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Row(
            children: [
              Text('Details Submitted Successfully!',
                  style: TextStyle(color: Colors.green)),
              Icon(Icons.check_circle, color: Colors.green),
            ],
          )),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The password provided is too weak.')),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('The account already exists for that email.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  //Using a GlobalKey is the recommended way to access a form. Storing it as a variable allows it to be accessed at different points.
  Widget build(BuildContext context) {
    //Build a Form widget using the _formKey created above.
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/SpendSenseLogo.jpeg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          //Form Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 6.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          //TextFormFields and ElevatedButton with validation logic
                          //The TextFormField widget renders a material design text field
                          //and can display validation errors when they occur.
                          //Validate the input by providing a validator() function to the TextFormField.
                          //If the user's input isn't valid, the validator function returns a String containing an error message.
                          //If there are no errors, the validator must return null.
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                            ),
                            //The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              if (!EmailValidator.validate(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordController,
                            obscureText:
                                !_passwordVisible, //usually for sensitive information like passwords. When set to true, it displays the text as hidden characters (commonly dots or asterisks) to prevent others from seeing it. Crucial for enhancing the security of user inputs in applications.
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters long';
                              }
                              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return 'Password must contain at least one uppercase letter';
                              }
                              if (!RegExp(r'[a-z]').hasMatch(value)) {
                                return 'Password must contain at least one lowercase letter';
                              }
                              if (!RegExp(r'\d').hasMatch(value)) {
                                return 'Password must contain at least one number';
                              }
                              if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                                return 'Password must contain at least one special character';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          FlutterPwValidator(
                            controller: _passwordController,
                            minLength: 8,
                            uppercaseCharCount: 1,
                            lowercaseCharCount: 1,
                            numericCharCount: 1,
                            specialCharCount: 1,
                            width: 200,
                            height: 90,
                            defaultColor: Color(0xFFd3d3d3),
                            successColor: Color(0xFF2ee292),
                            failureColor: Color(0xFFf9433e),
                            onSuccess: () {
                              // success callback function
                              print('Password is valid');
                            },
                            onFail: () {
                              // failure callback function
                              print(
                                  'Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, one number, and one special character.');
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            obscureText: !_confirmPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_confirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please re-enter your password';
                              }
                              // logic to compare with the password field
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          //When the user attempts to submit the form, check if the form is valid.
                          //If it is, display a success message.
                          //If it isn't (the text field has no content) display the error message.
                          SizedBox(height: 32.0),
                          ElevatedButton(
                            onPressed: _registerUser,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            child: const Text('Register',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
