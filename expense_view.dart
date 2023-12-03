import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseViewPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userID;

  ExpenseViewPage({required this.userID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense View'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('expenses')
            .doc(userID)
            .collection('userExpenses')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final expenses = snapshot.data!.docs.reversed.toList();

          // Calculate total amount for each category
          Map<String, double> categoryAmounts = {};
          expenses.forEach((expense) {
            final category = expense['category'] as String;
            final amount = expense['amount'] as double;

            if (categoryAmounts.containsKey(category)) {
              categoryAmounts[category] = categoryAmounts[category]! + amount;
            } else {
              categoryAmounts[category] = amount;
            }
          });

          // Prepare data for the pie chart
          List<PieChartSectionData> pieChartData = [];
          int colorIndex = 0;
          List<Color> colors = [
            Colors.blue,
            Colors.green,
            Colors.red,
            Colors.orange,
            Colors.purple,
            Colors.yellow,
          ];

          categoryAmounts.forEach((category, amount) {
            final pieChartSectionData = PieChartSectionData(
              color: colors[colorIndex % colors.length],
              value: amount,
              title: '$category',
              radius: 120,
              titleStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff),
              ),
            );

            pieChartData.add(pieChartSectionData);
            colorIndex++;
          });

          return SingleChildScrollView(
            child: Column(
              children: [
                // Pie chart
                AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      sections: pieChartData,
                      centerSpaceRadius: 0,
                    ),
                  ),
                ),

                // Expense list
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: expenses.length,
                  itemBuilder: (BuildContext context, int index) {
                    final expense = expenses[index];

                    final name = expense['name'] as String;
                    final category = expense['category'] as String;
                    final amount = expense['amount'] as double;
                    final dateTime = (expense['dateTime'] as Timestamp).toDate();

                    final formattedDateTime =
                    DateFormat('MM/dd/yyyy HH:mm').format(dateTime);

                    final isExpired = dateTime.isAfter(DateTime.now());

                    return ListTile(
                      title: Text(
                        name,
                        style: TextStyle(
                          color: isExpired ? Colors.red : Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category: $category',
                            style: TextStyle(
                              color: isExpired ? Colors.red : Colors.black,
                            ),
                          ),
                          Text(
                            'Amount: $amount',
                            style: TextStyle(
                              color: isExpired ? Colors.red : Colors.black,
                            ),
                          ),
                          Text(
                            'Date and Time: $formattedDateTime',
                            style: TextStyle(
                              color: isExpired ? Colors.red : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}