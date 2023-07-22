import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/firebase/activity_collection.dart';
import 'package:finance_tracker/firebase/investment_collection.dart';
import 'package:finance_tracker/models/investment_model.dart';
import 'package:finance_tracker/models/activity_model.dart';
import 'package:flutter/material.dart';

class SellInvestment extends StatefulWidget {
  final String ticker;
  const SellInvestment({Key? key, required this.ticker}) : super(key: key);

  @override
  SellInvestmentState createState() => SellInvestmentState();
}

class SellInvestmentState extends State<SellInvestment> {
  final TextEditingController _tickerController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String ticker = widget.ticker;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Sell Investment',
            style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.96))),
        iconTheme:
            const IconThemeData(color: Color.fromRGBO(255, 255, 255, 0.96)),
      ),
      backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _inputBox(ticker, 'Enter ticker'),
            const SizedBox(height: 16),
            _inputBox('Quantity', 'Enter amount',
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _inputBox('Share Price', 'Enter price',
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                try {
                  _saveInvestment();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error saving transaction'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(
                    3, 169, 66, 0.6), // Set the primary color to green
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save Investment'),
            ),
          ],
        ),
      ),
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

  void _saveInvestment() {
    String ticker = _tickerController.text;
    String quantityText = _quantityController.text;
    String priceText = _priceController.text;
    if (ticker.isEmpty || quantityText.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }
    int quantity;
    double price;
    try {
      quantity = int.parse(quantityText);
      price = double.parse(priceText);
    } catch (e) {
      // Handle case when the amount cannot be parsed to double
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid amount'),
        ),
      );
      return;
    }
    InvestmentModel newInvestment = InvestmentModel(
      ticker: ticker,
      quantity: quantity,
      sharePrice: price,
      timestamp: Timestamp.fromDate(DateTime.now()),
    );
    ActivityModel newActivity = ActivityModel(
      title: 'Bought $quantity shares of $ticker',
      type: 'Investment',
      timestamp: Timestamp.fromDate(DateTime.now()),
    );
    try {
      ActivityCollection.instance.addActivity(newActivity);
      InvestmentCollection.instance.addInvestment(newInvestment);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving transaction'),
        ),
      );
    }
  }
}
