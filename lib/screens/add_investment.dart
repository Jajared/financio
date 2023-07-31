import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financio/firebase/activity_collection.dart';
import 'package:financio/firebase/investment_collection.dart';
import 'package:financio/models/investment_model.dart';
import 'package:financio/models/activity_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class AddInvestment extends StatefulWidget {
  final Function(InvestmentModel) addInvestment;
  final String? ticker;
  const AddInvestment({Key? key, required this.addInvestment, this.ticker})
      : super(key: key);

  @override
  AddInvestmentState createState() => AddInvestmentState();
}

class AddInvestmentState extends State<AddInvestment> {
  final TextEditingController _tickerController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<String> allTickerSymbols = [];
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    loadTickerSymbols();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Add Investment',
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
            widget.ticker == null
                ? _tickerBox('Ticker', 'Enter ticker')
                : Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          Colors.grey[800], // You can customize the color here
                    ),
                    child: Text(
                      widget.ticker!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
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
      controller: label == 'Quantity' ? _quantityController : _priceController,
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

  Widget _tickerBox(String label, String hint,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _tickerController,
          keyboardType: keyboardType,
          onChanged: searchTickerSymbols,
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
        ),
        if (searchResults.isNotEmpty)
          SizedBox(
            height: 200,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color.fromRGBO(70, 70, 70, 1)),
                  right: BorderSide(color: Color.fromRGBO(70, 70, 70, 1)),
                  bottom: BorderSide(color: Color.fromRGBO(70, 70, 70, 1)),
                ),
              ),
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  String ticker = searchResults[index];
                  return ListTile(
                    title: Text(ticker,
                        style: const TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(() {
                        _tickerController.text = ticker;
                        searchResults.clear();
                      });
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  void _saveInvestment() {
    String ticker = _tickerController.text;
    String quantityText = _quantityController.text;
    String priceText = _priceController.text;
    if ((ticker.isEmpty && widget.ticker == null) ||
        quantityText.isEmpty ||
        priceText.isEmpty) {
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
      ticker: widget.ticker != null ? widget.ticker! : ticker,
      quantity: quantity,
      sharePrice: price,
      timestamp: Timestamp.fromDate(DateTime.now()),
    );
    ActivityModel newActivity = ActivityModel(
      title:
          'Bought $quantity shares of ${widget.ticker != null ? widget.ticker! : ticker}',
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
    widget.addInvestment(newInvestment);
  }

  Future<void> loadTickerSymbols() async {
    String jsonData = await DefaultAssetBundle.of(context)
        .loadString('lib/assets/stock_tickers.json');
    List<dynamic> data = json.decode(jsonData);
    List<String> result =
        data.map((item) => item['Ticker'].toString()).toList();
    allTickerSymbols = result;
  }

  void searchTickerSymbols(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    List<String> matches = allTickerSymbols
        .where((ticker) => ticker.startsWith(query.toUpperCase()))
        .toList();

    setState(() {
      searchResults = matches;
    });
  }
}
