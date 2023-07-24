import 'package:finance_tracker/firebase/personal_collection.dart';
import 'package:finance_tracker/models/personal_model.dart';
import 'package:finance_tracker/widgets/personal_category_chart.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/screens/add_personal.dart';
import 'package:intl/intl.dart';
import '../widgets/personal_card.dart';
import '../widgets/personal_chart.dart';

class Personal extends StatelessWidget {
  const Personal({Key? key}) : super(key: key);

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
      body: Column(
        children: [
          const SizedBox(height: 250, child: PersonalChart()),
          const SizedBox(height: 200, child: PersonalCategoryChart()),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Transactions",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 255, 255, 0.96)),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder<List<PersonalModel>>(
                future: PersonalCollection.instance.getAllPersonal(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                        color: Color.fromRGBO(198, 81, 205, 1));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final data = snapshot.data!;
                    final groupedTransactions = _groupTransactionsByDate(data);
                    return ListView.separated(
                      itemCount: groupedTransactions.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final date = groupedTransactions.keys.elementAt(index);
                        final transactions = groupedTransactions[date];
                        return _buildTransactionGroup(date, transactions!);
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the page where you want to add a new transaction
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddTransaction(),
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
            );
          },
        ),
      ],
    );
  }
}
