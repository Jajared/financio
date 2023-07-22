import 'package:flutter/material.dart';
import 'package:finance_tracker/screens/add_investment.dart';
import 'package:finance_tracker/widgets/investment_chart.dart';
import 'package:finance_tracker/firebase/investment_collection.dart';
import 'package:finance_tracker/models/investment_model.dart';
import 'package:finance_tracker/widgets/investment_card.dart';

class Investments extends StatelessWidget {
  const Investments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Investments',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.96),
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddInvestment(),
                  ),
                );
              },
            ),
          ]),
      backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
      body: Column(children: [
        const SizedBox(height: 250, child: InvestmentChart()),
        const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Positions",
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
            child: FutureBuilder<List<InvestmentModel>>(
              future: InvestmentCollection.instance.getAllInvestment(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                      color: Color.fromRGBO(198, 81, 205, 1));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final data = snapshot.data!;
                  print(data);
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return InvestmentCard(
                          tickerSymbol: data[index].ticker,
                          sharePrice: data[index].sharePrice,
                          quantity: data[index].quantity);
                    },
                  );
                }
              },
            ),
          ),
        ),
      ]),
    );
  }
}
