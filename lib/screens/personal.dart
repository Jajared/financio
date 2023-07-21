import 'package:finance_tracker/firebase/personal_collection.dart';
import 'package:finance_tracker/models/personal_model.dart';
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
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black, size: 30),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddTransaction(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 250, child: PersonalChart()),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Transactions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
                    return const CircularProgressIndicator();
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
            ),
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
