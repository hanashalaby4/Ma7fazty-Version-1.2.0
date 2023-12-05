import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'customer_support.dart';
import 'signin.dart';
import 'custom_widgets.dart';
import 'color.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _signUp() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text;
      
      // Check if email or password fields are empty
      if (email.isEmpty && password.isEmpty) {
        setState(() {
          _message = 'Please enter a password and email.';
        });
        return;
      }
      
       //Checking validity of email
      if (email.isNotEmpty && !_isValidEmail(email)) {
        setState(() {
          _message = 'Please enter a valid email address.';
        });
        return;
      }
     
      if (!_isValidPassword(password)) {
        setState(() {
          _message = 'The password must be at least 12 characters long and contain a combination of uppercase letters, lowercase letters, numbers, and special characters.';
        });
        return;
      }
      
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: password,
      );
      Fluttertoast.showToast(
        msg: "Sign up successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
        fontSize: 16.0,
      );


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    } catch (e) {
      print('Sign up failed: $e');

      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          setState(() {
            _message = 'The password provided is too weak.';
          });
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            _message = 'The account already exists for that email.';
          });
        } else if (e.code == 'invalid-email') {
          setState(() {
            _message = 'Please enter a valid email address.';
          });
        } else {
          setState(() {
            _message = 'An error occurred during sign up. Please try again later.';
          });
        }
      } else {
        setState(() {
          _message = 'An error occurred during sign up. Please try again later.';
        });
      }
    }
  }

  bool _isValidPassword(String password) {
    // Password validation using regular expressions
    RegExp lowercaseRegex = RegExp(r'[a-z]');
    RegExp uppercaseRegex = RegExp(r'[A-Z]');
    RegExp digitRegex = RegExp(r'\d');
    RegExp specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    return password.length >= 12 &&
        lowercaseRegex.hasMatch(password) &&
        uppercaseRegex.hasMatch(password) &&
        digitRegex.hasMatch(password) &&
        specialCharRegex.hasMatch(password);
  }
  
bool _isValidEmail(String email) {
    RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );

    return emailRegex.hasMatch(email);
  }

  void _goToSignInPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }
  void _goToCustomerSupportPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerSupportPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
        backgroundColor: cyan,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )
        )
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset('assets/images/logo2.png', fit: BoxFit.contain),
              ),
            ),
            new Text('Welcome to Ma7fazty!',
            style: TextStyle(
              color: cyan,
              fontSize: 25.0,
              fontWeight: FontWeight.bold
            )
            ),

            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              style: TextStyle(
                color: orange
              ),
              decoration: InputDecoration(
                labelText: 'Email',
                icon: Icon(
                    Icons.person,
                    color: orange
                ),
                labelStyle: TextStyle(
                  color: pink
                ),
                border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink), // Different color when focused, if desired
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              style: TextStyle(
                  color: orange
              ),
              decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(
                      Icons.lock,
                      color: orange
                  ),
              labelStyle: TextStyle(
                  color: pink
                ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink), // Different color when focused, if desired
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: buttonPrimary,
                onPressed: _signUp,
                child: const Text('Sign Up.'),
            ),
            SizedBox(height: 16.0),
           ElevatedButton(
             style: buttonPrimary,
             onPressed: _goToSignInPage,
             child:
             const Text('Already have an account? Sign In.'),
           ),
            SizedBox(height: 16.0),
            ElevatedButton(
                style: buttonPrimary,
                onPressed: _goToCustomerSupportPage,
                child: const Text('Contact Us.')
            ),
            // CustomButton(
            //   text: 'Contact us.',
            //   onPressed: _goToCustomerSupportPage,
            // ),
            SizedBox(height: 18.0),
            CustomText(
              text: _message,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
