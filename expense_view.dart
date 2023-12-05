import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'custom_widgets.dart';
import 'color.dart';

class ExpenseViewPage extends StatefulWidget {
  final String userID;

  ExpenseViewPage({required this.userID});

  @override
  _ExpenseViewPageState createState() => _ExpenseViewPageState();
}

class _ExpenseViewPageState extends State<ExpenseViewPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool showCurrentMonthExpenses = true; // Default to show current month expenses
  String? categoryFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('View Expenses'),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:CustomText(
              text: 'View expenses for:',
              color: cyan,
              fontSize: 20.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: true,
                groupValue: showCurrentMonthExpenses,
                onChanged: (value) {
                  setState(() {
                    showCurrentMonthExpenses = value!;
                  });
                },
              ),
              CustomText(
                  text: 'Entries of current month',
                color: cyan,

              ),
              Radio(
                value: false,
                groupValue: showCurrentMonthExpenses,
                onChanged: (value) {
                  setState(() {
                    showCurrentMonthExpenses = value!;
                  });
                },
              ),
              CustomText(
                  text: 'All entries',
                  color: cyan
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(
                color: orange
              ),
              onChanged: (value) {
                setState(() {
                  categoryFilter = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter category to filter',
                labelStyle: TextStyle(
                    color: pink
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink), // Different color when focused, if desired
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('expenses')
                  .doc(widget.userID)
                  .collection('userExpenses')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final now = DateTime.now();
                final filteredExpenses = showCurrentMonthExpenses
                    ? snapshot.data!.docs
                    .where((expense) =>
                (expense['dateTime'] as Timestamp).toDate().month == now.month)
                    .toList()
                    : snapshot.data!.docs.reversed.toList();

                if (categoryFilter != null && categoryFilter!.isNotEmpty) {
                  filteredExpenses.retainWhere(
                          (expense) => (expense['category'] as String).toLowerCase() == categoryFilter!.toLowerCase());
                }

                final data = calculateCategoryExpenses(filteredExpenses);

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredExpenses.length,
                        itemBuilder: (BuildContext context, int index) {
                          final expense = filteredExpenses[index];

                          final name = expense['name'] as String;
                          final category = expense['category'] as String;
                          final amount = expense['amount'] as double;
                          final dateTime = (expense['dateTime'] as Timestamp).toDate();

                          final formattedDateTime = DateFormat('MM/dd/yyyy HH:mm').format(dateTime);

                          return ListTile(
                            title: CustomText(
                              text: name,
                              color: cyan,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Category: $category',
                                  color: cyan,
                                ),
                                CustomText(
                                  text: 'Amount: $amount',
                                  color: cyan,
                                ),
                                CustomText(
                                  text: 'Date and time: $formattedDateTime',
                                  color: cyan,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                sections: _createPieChartData(data),
                                sectionsSpace: 0,
                                centerSpaceRadius: 40,
                                startDegreeOffset: -90,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(data.length, (index) {
                                final categoryExpense = data[index];
                                final categoryName = categoryExpense.category;
                                final color = customColors[data.indexOf(categoryExpense) % customColors.length];

                                return Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      color: color,
                                    ),
                                    SizedBox(width: 8),
                                    CustomText(
                                      text: categoryName,
                                      color: cyan
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: buttonPrimary,
                      onPressed: () {
                        _shareExpenses(filteredExpenses);
                      },
                      child: Text('Share Expenses'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      ),
    );
  }

  List<CategoryExpense> calculateCategoryExpenses(List<QueryDocumentSnapshot> expenses) {
    final categories = Set<String>();
    final Map<String, double> categoryExpenses = {};

    for (final expense in expenses) {
      final category = expense['category'] as String;
      final amount = expense['amount'] as double;

      categories.add(category);

      if (categoryExpenses.containsKey(category)) {
        categoryExpenses[category] = categoryExpenses[category]! + amount;
      } else {
        categoryExpenses[category] = amount;
      }
    }

    return categories
        .map((category) => CategoryExpense(category: category, expense: categoryExpenses[category]!))
        .toList();
  }

  List<PieChartSectionData> _createPieChartData(List<CategoryExpense> data) {
    return data.map((categoryExpense) {
      final double expense = categoryExpense.expense;
      final double totalExpense = data.fold(0, (sum, categoryExpense) => sum + categoryExpense.expense);
      final double percentage = totalExpense != 0 ? (expense / totalExpense) * 100 : 0;

      return PieChartSectionData(
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: customColors[data.indexOf(categoryExpense) % customColors.length],
      );
    }).toList();
  }

  void _shareExpenses(List<QueryDocumentSnapshot> expenses) {
    String expenseList = '';

    for (final expense in expenses) {
      final name = expense['name'] as String;
      final category = expense['category'] as String;
      final amount = expense['amount'] as double;
      final dateTime = (expense['dateTime'] as Timestamp).toDate();

      final formattedDateTime = DateFormat('MM/dd/yyyy HH:mm').format(dateTime);

      expenseList += 'Name: $name\n';
      expenseList += 'Category: $category\n';
      expenseList += 'Amount: $amount\n';
      expenseList += 'Date and Time: $formattedDateTime\n\n';
    }

    Clipboard.setData(ClipboardData(text: expenseList));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: softCyan,
            textTheme: TextTheme(
              bodyText2: TextStyle(color: blackPrimary),
              subtitle1: TextStyle(color: blackPrimary),
            ),
          ),
          child: AlertDialog(
          title: Text('Expenses Shared'),
          content: Text('The list of expenses has been copied to the clipboard.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK',
                         style: TextStyle(color: blackPrimary)),
            ),
          ],
        ),
        );
        // return 
      },
    );
  }
}

class CategoryExpense {
  final String category;
  final double expense;

  CategoryExpense({required this.category, required this.expense});
}
