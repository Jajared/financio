import 'package:flutter/material.dart';
import 'package:finance_tracker/screens/add_investment.dart';
import 'package:finance_tracker/widgets/investment_chart.dart';
import 'package:finance_tracker/firebase/investment_collection.dart';
import 'package:finance_tracker/models/investment_model.dart';
import 'package:finance_tracker/widgets/investment_card.dart';
import 'package:finance_tracker/widgets/investment_summary.dart';

class Investments extends StatefulWidget {
  const Investments({Key? key}) : super(key: key);

  @override
  _InvestmentsState createState() => _InvestmentsState();
}

class _InvestmentsState extends State<Investments> {
  List<InvestmentModel> investmentData = [];
  var totalValue = 0.0;
  var profit = 0.0;

  @override
  void initState() {
    super.initState();
    _getSummaryData();
    _getInvestmentData();
  }

  Future<void> _getSummaryData() async {
    try {
      final result = await InvestmentCollection.instance.getSummary();
      setState(() {
        totalValue = result['total_value'].toDouble();
        profit = result['profit'].toDouble();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getInvestmentData() async {
    try {
      final result = await InvestmentCollection.instance.getAllInvestment();
      setState(() {
        investmentData = result;
      });
    } catch (e) {
      print(e);
    }
  }

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
      ),
      backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
      body: Column(
        children: [
          InvestmentSummary(
            balance: totalValue,
            profit: profit,
          ),
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
                  color: Color.fromRGBO(255, 255, 255, 0.96),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: investmentData.length,
                itemBuilder: (context, index) {
                  return InvestmentCard(
                    tickerSymbol: investmentData[index].ticker,
                    sharePrice: investmentData[index].sharePrice,
                    quantity: investmentData[index].quantity,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddInvestment(),
            ),
          );
        },
        backgroundColor: const Color.fromRGBO(135, 57, 249, 1),
        mini: true,
        child: const Icon(Icons.add),
      ),
    );
  }
}
