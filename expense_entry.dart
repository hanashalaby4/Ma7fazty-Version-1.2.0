import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'color.dart';
import 'custom_widgets.dart';


class ExpenseEntryPage extends StatefulWidget {
  @override
  _ExpenseEntryPageState createState() => _ExpenseEntryPageState();
}

class _ExpenseEntryPageState extends State<ExpenseEntryPage> {
  final TextEditingController _nameController = TextEditingController();
  String? selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  DateTime? selectedDateTime;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isFormValid =>
      _nameController.text.isNotEmpty &&
          selectedCategory != null &&
          _amountController.text.isNotEmpty &&
          selectedDateTime != null;

  void _addExpense() async {
    if (isFormValid) {
      String name = _nameController.text;
      double amount = double.parse(_amountController.text);
      DateTime? dateTime = selectedDateTime;

      // Get the current user
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        // Store the expense with the user's credentials
        FirebaseFirestore.instance
            .collection('expenses')
            .doc(userId)
            .collection('userExpenses')
            .add({
          'name': name,
          'category': selectedCategory,
          'amount': amount,
          'dateTime': dateTime,
        });

        // Clear the text fields after adding the expense
        _nameController.clear();
        _amountController.clear();
        setState(() {
          selectedCategory = null;
          selectedDateTime = null;
        });
      }
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            // Customize the date picker
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.softCyan, // Set the color of the date picker buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Enter Expenses'),
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
                    SizedBox(height: 16.0),
                    TextField(
                      style: TextStyle(
                          color: orange
                      ),
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Expense Name',
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
                    Theme(data: Theme.of(context).copyWith(
                      popupMenuTheme: PopupMenuThemeData(
                        color: softCyan,
                            textStyle: TextStyle(color: blackPrimary),
                      )
                    ), child:  PopupMenuButton<String>(
                      onSelected: (category) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'Food',
                          child: Text('Food'),
                        ),
                        PopupMenuItem(
                          value: 'Utilities',
                          child: Text('Utilities'),
                        ),
                        PopupMenuItem(
                          value: 'Clothing',
                          child: Text('Clothing'),
                        ),
                        PopupMenuItem(
                          value: 'Medical',
                          child: Text('Medical'),
                        ),
                        PopupMenuItem(
                          value: 'Insurance',
                          child: Text('Insurance'),
                        ),
                        PopupMenuItem(
                          value: 'Education',
                          child: Text('Education'),
                        ),
                        PopupMenuItem(
                          value: 'Gifts/Donations',
                          child: Text('Gifts/Donations'),
                        ),
                        PopupMenuItem(
                          value: 'Entertainment',
                          child: Text('Entertainment'),
                        ),
                        PopupMenuItem(
                          value: 'Other',
                          child: Text('Other'),
                        ),
                      ],
                      child: ListTile(
                        title: Text('Category',
                            style: TextStyle(
                                color: pink)
                        ),
                        subtitle: Text(selectedCategory ?? 'Choose a category',
                            style: TextStyle(
                                color: orange)
                        ),
                      ),
                    )

                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      style: TextStyle(
                          color: orange
                      ),
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
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
                      onPressed: () {
                        _selectDateTime(context);
                      },
                      child: Text('Select date and time'),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     _selectDateTime(context);
                    //   },
                    //   child: Text('Select Date and Time'),
                    // ),
                    SizedBox(height: 16.0),
                    CustomText(
                      fontSize: 20.0,
                      color: cyan,
                      text: 'Selected Date and Time: ${selectedDateTime != null ? DateFormat('MM/dd/yyyy HH:mm').format(selectedDateTime!) : 'Not selected'}',
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: buttonPrimary,
                      child: Text('Enter New Expense'),
                      onPressed: isFormValid ? _addExpense : null,
                    ),
                  ]

                ),
              )

            ),
          ],
        ),
      ),
    );
  }
}
