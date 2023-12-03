import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ma7fazti/budget_setting.dart';
import 'package:ma7fazti/expense_view.dart';
import 'package:ma7fazti/expense_entry.dart';
import 'package:ma7fazti/budget_view.dart';

class HomePage extends StatelessWidget {
  final UserCredential userCredential;

  HomePage(this.userCredential);

  @override
  Widget build(BuildContext context) {
    String email = userCredential.user?.email ?? '';
    String userName = email.split('@')[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Enter New Expenses'),
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
            ElevatedButton(
              child: Text('View Expenses'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpenseViewPage(userID: userCredential.user?.uid ?? ''),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text('Set a New Budget'),
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
            ElevatedButton(
              child: Text('View Budgets'),
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
    );
  }
}
