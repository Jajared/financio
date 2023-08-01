import 'package:financio/screens/investment_statistics.dart';
import 'package:financio/screens/watchlist.dart';
import 'package:financio/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:financio/screens/add_investment.dart';
import 'package:financio/firebase/investment_collection.dart';
import 'package:financio/models/investment_model.dart';
import 'package:financio/widgets/investment_card.dart';
import 'package:financio/widgets/investment_summary.dart';

class Investments extends StatefulWidget {
  const Investments({Key? key}) : super(key: key);

  @override
  _InvestmentsState createState() => _InvestmentsState();
}

class _InvestmentsState extends State<Investments> {
  List<InvestmentModel> investmentData = [];
  List<dynamic> graphData = [];
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
        totalValue = result['graphData'].last["value"].toDouble();
        profit = result['profit'].toDouble();
        graphData = result['graphData'];
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text(
                "An error occurred while fetching investment summary data."),
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

  Future<void> _getInvestmentData() async {
    try {
      final result = await InvestmentCollection.instance.getAllInvestment();
      setState(() {
        investmentData = result;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content:
                const Text("An error occurred while fetching investment data."),
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

  void _onNewInvestmentAdded(InvestmentModel newTransaction) {
    setState(() {
      investmentData.add(newTransaction);
    });
    _getSummaryData();
  }

  void _onSellInvestment(List<InvestmentModel> updatedInvestments) {
    setState(() {
      investmentData = updatedInvestments;
    });
    _getSummaryData();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            InvestmentSummary(
                balance: totalValue, profit: profit, graphData: graphData),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CustomButton(
                    icon: Icons.bar_chart,
                    title: "Statistics",
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              InvestmentStatistics(graphData: graphData),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    icon: Icons.list,
                    title: "Watchlist",
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StockWatchList(
                              addNewInvestment: _onNewInvestmentAdded),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "My Portfolio",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 255, 255, 0.96),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: investmentData.length,
                itemBuilder: (context, index) {
                  return InvestmentCard(
                    tickerSymbol: investmentData[index].ticker,
                    sharePrice: investmentData[index].sharePrice,
                    quantity: investmentData[index].quantity,
                    onSell: _onSellInvestment,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  AddInvestment(addInvestment: _onNewInvestmentAdded),
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
