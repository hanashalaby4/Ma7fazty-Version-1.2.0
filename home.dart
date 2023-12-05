import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'budget_setting.dart';
import 'budget_view.dart';
import 'color.dart';
import 'custom_widgets.dart';
import 'expense_view.dart';
import 'expense_entry.dart';




class HomePage extends StatelessWidget {
  final UserCredential userCredential;

  HomePage(this.userCredential);

 @override
  Widget build(BuildContext context) {
    String email = userCredential.user?.email ?? '';
    String userName = email.split('@')[0];

    return Scaffold(
      appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
          backgroundColor: cyan,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              )
          )
      ),
      body:
        Column(
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
                  ElevatedButton(
                  style: buttonPrimary,
                    child: const Text('Enter New Expenses'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpenseEntryPage(),
                          settings: RouteSettings(
                            arguments: userCredential,
                          ),
                        ),
                      );
                    },
                  ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: buttonPrimary,
                      child:  const Text('View Expenses'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpenseViewPage(userID: userCredential.user?.uid ?? ''),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: buttonPrimary,
                      child: const Text('Set a New Budget'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BudgetSettingsPage(userId: userCredential.user?.uid ?? ''),
                            settings: RouteSettings(
                              arguments: userCredential,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: buttonPrimary,
                      child: const Text('View Budgets'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BudgetViewPage(),
                            settings: RouteSettings(
                              arguments: userCredential,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }
}
