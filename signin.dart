import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'color.dart';
import 'home.dart';
import 'custom_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Fluttertoast.showToast(
        msg: "Sign in successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userCredential), // Pass the user credentials
        ),
      );
    } catch (e) {
      print('Sign in failed: $e');

      // Check the error type
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          setState(() {
            _message = 'No user found for that email.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _message = 'Incorrect password.';
          });
        } else if (e.code == 'invalid-email') {
          setState(() {
            _message = 'Please enter a valid email address.';
          });
        } else {
          setState(() {
            _message = 'An error occurred during sign in. Please try again later.';
          });
        }
      } else {
        setState(() {
          _message = 'An error occurred during sign in. Please try again later.';
        });
      }
    }
  }@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
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
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/logo3.png',
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
            child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: [
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
                            borderSide: BorderSide(color: Colors.pink),
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
                              borderSide: BorderSide(color: Colors.pink),
                            ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                            style: buttonPrimary,
                            onPressed: _signIn,
                            child: const Text('Sign In.')
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
    )

          ],
        ),
      ),
    );
  }
}
  }
}
