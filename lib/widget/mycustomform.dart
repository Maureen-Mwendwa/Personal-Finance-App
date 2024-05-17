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
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  //Using a GlobalKey is the recommended way to access a form. Storing it as a variable allows it to be accessed at different points.
  Widget build(BuildContext context) {
    //Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          //TextFormFields and ElevatedButton with validation logic
          //The TextFormField widget renders a material design text field
          //and can display validation errors when they occur.
          //Validate the input by providing a validator() function to the TextFormField.
          //If the user's input isn't valid, the validator function returns a String containing an error message.
          //If there are no errors, the validator must return null.
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
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
          TextFormField(
            controller: _passwordController,
            obscureText:
                true, //usually for sensitive information like passwords. When set to true, it displays the text as hidden characters (commonly dots or asterisks) to prevent others from seeing it. Crucial for enhancing the security of user inputs in applications.
            decoration: InputDecoration(labelText: 'Password'),
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please enter a password';
            //   }
            //   if (value.length < 8) {
            //     return 'Password must be at least 8 characters long';
            //   }
            //   return null;
            // },
          ),
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
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(labelText: 'Confirm Password'),
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
          SizedBox(height: 100),
          ElevatedButton(
            onPressed: () {
              //Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                //_formKey.currentState returns an instance of FormState?, which means it can either be a FormState object or null. The null assertion operator ! is used to assert that _formKey.currentState is not null before calling the validate() method on the FormState instance associated with the Form widget.
                //If the form is valid, display a snackbar.
                //In the real world, you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Row(
                    children: [
                      Text('Details Submitted Successfully',
                          style: TextStyle(color: Colors.green)),
                      Icon(Icons.check_circle, color: Colors.green)
                    ],
                  )),
                );
              }
            },
            child: const Text('Submit', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
