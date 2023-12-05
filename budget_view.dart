import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'color.dart';


class BudgetViewPage extends StatefulWidget {
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
        .doc('userSettings')
        .get();

    if (snapshot.exists) {
      setState(() {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        monthlyBudget = data['monthlyBudget'] ?? 0.0;
      });

      calculateRemainingBudget(); // Call calculateRemainingBudget here
    }
  }

  void calculateRemainingBudget() async {
    QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
        .collection('expenses')
        .where('month', isEqualTo: DateTime.now().month)
        .get();

    double totalExpenses = 0.0;

    expenseSnapshot.docs.forEach((expense) {
      totalExpenses += expense.get('amount') ?? 0.0;
    });

    setState(() {
      remainingBudget = monthlyBudget - totalExpenses;
    });
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
           Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(
                     'Monthly Budget: ${monthlyBudget.toStringAsFixed(2)}',
                     style: TextStyle(fontSize: 24,
                         color: cyan),
                   ),
                   SizedBox(height: 16),
                   Text(
                     'Remaining Budget: ${remainingBudget.toStringAsFixed(2)}',
                     style: TextStyle(fontSize: 24,
                         color: cyan
                     ),
                   ),
                 ],
               ),
             ),
           ],
         )
       )
  
    );
  }
}

