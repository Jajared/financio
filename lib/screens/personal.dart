import 'package:financio/firebase/personal_collection.dart';
import 'package:financio/models/personal_model.dart';
import 'package:financio/widgets/custom_button.dart';
import 'package:financio/screens/personal_statistics.dart';
import 'package:flutter/material.dart';
import 'package:financio/screens/add_personal.dart';
import 'package:intl/intl.dart';
import '../widgets/personal_card.dart';
import '../widgets/personal_chart.dart';

class Personal extends StatefulWidget {
  const Personal({Key? key}) : super(key: key);

  @override
  _PersonalState createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  List<PersonalModel> transactionData = [];

  @override
  void initState() {
    super.initState();
    _getTransactionData();
  }

  Future<void> _getTransactionData() async {
    try {
      final result = await PersonalCollection.instance.getAllPersonal();
      setState(() {
        transactionData = result;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text(
                "An error occurred while fetching personal transaction data."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  void _onNewTransactionAdded(PersonalModel newTransaction) {
    setState(() {
      transactionData.add(newTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Personal',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.96),
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: 200,
                child: PersonalChart(transactionData: transactionData)),
            CustomButton(
                icon: Icons.pie_chart,
                title: "Statistics",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PersonalStatistics(transactionData: transactionData),
                    ),
                  );
                }),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "Transactions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 255, 255, 0.96),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _groupTransactionsByDate(transactionData).length,
                itemBuilder: (context, index) {
                  final groupedData = _groupTransactionsByDate(transactionData);
                  final date = groupedData.keys.elementAt(index);
                  final transactions = groupedData[date]!;
                  return _buildTransactionGroup(date, transactions);
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the page where you want to add a new transaction
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddTransaction(
                    onNewTransactionAdded: _onNewTransactionAdded),
              ),
            );
          },
          backgroundColor: const Color.fromRGBO(135, 57, 249, 1),
          mini: true,
          child: const Icon(Icons.add)),
    );
  }

  // Helper method to group transactions by date
  Map<DateTime, List<PersonalModel>> _groupTransactionsByDate(
    List<PersonalModel> transactions,
  ) {
    final groupedTransactions = <DateTime, List<PersonalModel>>{};
    for (final transaction in transactions) {
      final date = DateTime(
        transaction.timestamp.toDate().year,
        transaction.timestamp.toDate().month,
        transaction.timestamp.toDate().day,
      );
      if (groupedTransactions.containsKey(date)) {
        groupedTransactions[date]!.add(transaction);
      } else {
        groupedTransactions[date] = [transaction];
      }
    }
    return groupedTransactions;
  }

  // Helper method to build a widget for displaying transactions for each date group
  Widget _buildTransactionGroup(
      DateTime date, List<PersonalModel> transactions) {
    final formattedDate = DateFormat('MMM d, yyyy').format(date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            formattedDate,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 255, 255, 0.67)),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final personalItem = transactions[index];
            return PersonalCard(
              category: personalItem.category,
              amount: personalItem.amount,
              description: personalItem.description,
              timestamp: personalItem.timestamp,
              onDelete: (deletedItem) {
                setState(() {
                  transactionData.removeWhere((item) =>
                      item.amount == deletedItem.amount &&
                      item.category == deletedItem.category &&
                      item.description == deletedItem.description &&
                      item.timestamp.toDate() ==
                          deletedItem.timestamp.toDate());
                  PersonalCollection.instance.deletePersonal(deletedItem);
                });
              },
            );
          },
        ),
      ],
    );
  }
}
