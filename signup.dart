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
      String password = _passwordController.text;
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
      // Additional logic to store the user's name in Firestore or Realtime Database
      // You can use userCredential.user.uid as the user's unique identifier

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
        title: const Text('Sign In'),
        centerTitle: true,
        backgroundColor: softPurple,
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
            CustomTextField(
              textStyle:  TextStyle(
                  color: softPurple
              ),
              controller: _emailController,
              labelText: 'Email',
            ),
            SizedBox(height: 16.0),
            CustomTextField(
              textStyle:  TextStyle(
                color: softPurple
            ),
              controller: _passwordController,
              labelText: 'Password',
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            CustomButton(
               text: 'Sign In',
              onPressed: _signIn,
            ),
            SizedBox(height: 16.0),
            CustomText(
                text: _message,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                )
          ],
        ),
      ),
    );
  }
}
