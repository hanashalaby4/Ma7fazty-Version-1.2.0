import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'color.dart';
import 'custom_widgets.dart';

class BudgetSettingsPage extends StatefulWidget {
  final String userId;

  BudgetSettingsPage({required this.userId});

  @override
  _BudgetSettingsPageState createState() => _BudgetSettingsPageState();
}

class _BudgetSettingsPageState extends State<BudgetSettingsPage> {
  final formKey = GlobalKey<FormState>();
  double monthlyBudget = 0.0;

  void saveSettings() {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save();

      // Save settings to Cloud Firestore with user ID
      FirebaseFirestore.instance
          .collection('budgetSettings')
          .doc(widget.userId)
          .set({'monthlyBudget': monthlyBudget});

      Navigator.pop(context); // Go back to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View budget'),
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
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Please enter a budget for the current month:',
                style: TextStyle(fontSize: 16,
                color: cyan),
              ),
              TextFormField(
                style: TextStyle(
                    color: orange
                ),
                decoration: InputDecoration( labelStyle: TextStyle(
                    color: pink
                ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  final nonNullValue = value ?? '';
                  monthlyBudget = double.tryParse(nonNullValue) ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your monthly budget';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: buttonPrimary,
                  onPressed: saveSettings,
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
