import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financio/firebase/activity_collection.dart';
import 'package:financio/models/investment_model.dart';
import 'package:financio/models/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SellInvestment extends StatefulWidget {
  final InvestmentModel data;
  final String name;
  final double totalValue;
  final Function(InvestmentModel) onSell;
  const SellInvestment(
      {Key? key,
      required this.data,
      required this.name,
      required this.totalValue,
      required this.onSell})
      : super(key: key);

  @override
  SellInvestmentState createState() => SellInvestmentState();
}

class SellInvestmentState extends State<SellInvestment> {
  final TextEditingController _tickerController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  late String tickerSymbol = '';
  late double sharePrice = 0;
  late int quantity = 0;
  late double totalValue = 0;
  late Timestamp timestamp = Timestamp.fromDate(DateTime.now());

  @override
  void initState() {
    super.initState();
    tickerSymbol = widget.data.ticker;
    sharePrice = widget.data.sharePrice;
    quantity = widget.data.quantity;
    timestamp = widget.data.timestamp;
    totalValue = widget.totalValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme:
            const IconThemeData(color: Color.fromRGBO(255, 255, 255, 0.96)),
      ),
      backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.name,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.96))),
            const SizedBox(height: 10),
            Text(tickerSymbol,
                style: TextStyle(
                    fontSize: 16, color: Colors.white.withOpacity(0.67))),
            const SizedBox(height: 20),
            investmentData(),
            const SizedBox(height: 20),
            Text('Your Investment',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.96))),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("Date bought", style: TextStyle(color: Colors.white)),
              Text(DateFormat('MMM d').format(timestamp.toDate()),
                  style: const TextStyle(color: Colors.white)),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("Shares owned", style: TextStyle(color: Colors.white)),
              Text(quantity.toString(),
                  style: const TextStyle(color: Colors.white)),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("Average price",
                  style: TextStyle(color: Colors.white)),
              Text('\$${sharePrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white)),
            ]),
            const Expanded(
              child: SizedBox(),
            ),
            ElevatedButton(
              onPressed: () {
                _showBottomSheet(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sell Investment'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: const Color.fromRGBO(40, 40, 40, 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Sell $tickerSymbol',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  _inputBox('Quantity', 'Enter amount',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  _inputBox('Share Price', 'Enter price',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true)),
                  const SizedBox(height: 16),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Close'),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                _saveInvestment();
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Sell'),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ));
      },
    );
  }

  Widget _inputBox(String label, String hint,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: label == 'Ticker'
          ? _tickerController
          : label == 'Quantity'
              ? _quantityController
              : _priceController,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }

  Widget investmentData() {
    return Row(children: [
      CircularPercentIndicator(
        radius: 40.0,
        percent: quantity * sharePrice / totalValue,
        lineWidth: 10.0,
        animation: true,
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: const Color.fromRGBO(198, 81, 205, 1),
        center: Text(
          '${(quantity * sharePrice / totalValue * 100).toPrecision(1)}%',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      const SizedBox(width: 10),
      const Text("of your portfolio",
          style: TextStyle(fontSize: 16, color: Colors.white)),
    ]);
  }

  void _saveInvestment() async {
    String quantityText = _quantityController.text;
    String priceText = _priceController.text;
    if (quantityText.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }
    int quantitySold;
    double priceSold;
    try {
      quantitySold = int.parse(quantityText);
      priceSold = double.parse(priceText);
      if (quantitySold > quantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You do not own that many shares'),
          ),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid amount'),
        ),
      );
      return;
    }
    InvestmentModel sellInvestmentEvent = InvestmentModel(
      ticker: tickerSymbol,
      quantity: quantitySold,
      sharePrice: priceSold,
      timestamp: Timestamp.fromDate(DateTime.now()),
    );
    ActivityModel newActivity = ActivityModel(
      title: 'Sold $quantitySold shares of $tickerSymbol',
      type: 'Investment',
      timestamp: Timestamp.fromDate(DateTime.now()),
    );
    setState(() {
      quantity -= quantitySold;
      totalValue -= quantitySold * sharePrice;
    });
    try {
      ActivityCollection.instance.addActivity(newActivity);
      widget.onSell(sellInvestmentEvent);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving transaction'),
        ),
      );
    }
  }
}
