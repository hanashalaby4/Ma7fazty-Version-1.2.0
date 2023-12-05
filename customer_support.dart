import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'color.dart';
import 'custom_widgets.dart';


class CustomerSupportPage extends StatefulWidget {
  @override
  _CustomerSupportPageState createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();

  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase
    Firebase.initializeApp();
  }

  void _checkButtonStatus() {
    setState(() {
      _isButtonDisabled =
          _emailController.text.isEmpty ||
              _titleController.text.isEmpty ||
              _issueController.text.isEmpty ||
              !_isValidEmail(_emailController.text);
    });
  }

  bool _isValidEmail(String email) {

    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email);
  }

  void _submitIssue() {
    Timestamp timestamp = Timestamp.now();
    FirebaseFirestore.instance.collection("issues").add({
      "email": _emailController.text,
      "title": _titleController.text,
      "issue": _issueController.text,
      "timestamp": timestamp,
    }).then((value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Issue submitted successfully!"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      // Clear the text fields
      _emailController.clear();
      _titleController.clear();
      _issueController.clear();
      _checkButtonStatus();
    }).catchError((error) {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to submit issue. Please try again."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Customer Support'),
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
                      onChanged: (value) => _checkButtonStatus(),
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
                    TextField(
                      controller: _titleController,
                      onChanged: (value) => _checkButtonStatus(),
                      decoration: InputDecoration(
                        labelText: 'Title',
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
                    TextField(
                      controller: _issueController,
                      onChanged: (value) => _checkButtonStatus(),
                      decoration: InputDecoration(
                        labelText: 'Issue description',
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
                    ElevatedButton(
                      style: buttonPrimary,
                      onPressed: _isButtonDisabled ? null : _submitIssue,
                      child: Text("Submit"),
                    ),
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
