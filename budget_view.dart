import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetViewPage extends StatefulWidget {
  final String userId;

  BudgetViewPage({required this.userId});

  @override
  _BudgetViewPageState createState() => _BudgetViewPageState();
}

class _BudgetViewPageState extends State<BudgetViewPage> {
  double monthlyBudget = 0.0;
  double remainingBudget = 0.0;

  @override
  void initState() {
    super.initState();
    fetchMonthlyBudget();
  }

  void fetchMonthlyBudget() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('budgetSettings')
        .doc(widget.userId)
        .get();

    if (snapshot.exists) {
      setState(() {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        monthlyBudget = data['monthlyBudget'] ?? 0.0;
      });
      calculateRemainingBudget();
    }
  }

  void calculateRemainingBudget() async {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
        .collection('expenses')
        .doc(widget.userId)
        .collection('userExpenses')
        .where('dateTime', isGreaterThanOrEqualTo: startOfMonth)
        .where('dateTime', isLessThanOrEqualTo: endOfMonth)
        .get();

    if (expenseSnapshot.docs.isNotEmpty) {
      double totalExpenses = 0.0;

      for (var expense in expenseSnapshot.docs) {
        totalExpenses += expense.get('amount') ?? 0.0;
      }

      setState(() {
        remainingBudget = monthlyBudget - totalExpenses;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Monthly Budget: ${monthlyBudget.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Remaining Budget: ${remainingBudget.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}