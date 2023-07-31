import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financio/firebase/investment_collection.dart';
import 'package:financio/models/watchlist_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class AddWatchlist extends StatefulWidget {
  final Function(WatchListModel) onAddToWatchlist;
  const AddWatchlist({Key? key, required this.onAddToWatchlist})
      : super(key: key);

  @override
  AddWatchlistState createState() => AddWatchlistState();
}

class AddWatchlistState extends State<AddWatchlist> {
  final TextEditingController _tickerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
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
        title: const Text('Add To Watchlist',
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
            _tickerBox('Ticker', 'Enter ticker'),
            const SizedBox(height: 16),
            _inputBox('Description', 'Enter description',
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                try {
                  _saveToWatchlist();
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
              child: const Text('Save to watchlist'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputBox(String label, String hint,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 3}) {
    return TextField(
      controller: _descriptionController,
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

  void _saveToWatchlist() {
    String ticker = _tickerController.text;
    String descriptionText = _descriptionController.text;
    if (ticker.isEmpty || descriptionText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }
    WatchListModel newWatchlistItem = WatchListModel(
      ticker: ticker,
      descriptions: [
        DescriptionModel(
          timestamp: Timestamp.fromDate(DateTime.now()),
          description: descriptionText,
        )
      ],
    );
    try {
      InvestmentCollection.instance.addToWatchList(newWatchlistItem);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving transaction'),
        ),
      );
    }
    widget.onAddToWatchlist(newWatchlistItem);
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
