import 'package:finance_tracker/firebase/investment_collection.dart';
import 'package:finance_tracker/models/watchlist_model.dart';
import 'package:finance_tracker/screens/add_watchlist.dart';
import 'package:finance_tracker/widgets/watchlist_card.dart';
import 'package:flutter/material.dart';

class StockWatchList extends StatefulWidget {
  const StockWatchList({Key? key}) : super(key: key);

  @override
  StockWatchListState createState() => StockWatchListState();
}

class StockWatchListState extends State<StockWatchList> {
  List<WatchListModel> allWatchlistItems = [];

  @override
  void initState() {
    super.initState();
    _getWatchlistData();
  }

  Future<void> _getWatchlistData() async {
    try {
      final result = await InvestmentCollection.instance.getAllWatchList();
      setState(() {
        allWatchlistItems = result;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content:
                const Text("An error occurred while fetching watchlist data."),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Watchlist',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.96),
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
      body: ListView.builder(
        itemCount: allWatchlistItems.length,
        itemBuilder: (context, index) {
          final item = allWatchlistItems[index];
          return WatchlistItemCard(item: item);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  AddWatchlist(onAddToWatchlist: _onAddToWatchlist),
            ),
          );
        },
        backgroundColor: const Color.fromRGBO(135, 57, 249, 1),
        mini: true,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onAddToWatchlist(WatchListModel newWatchlistItem) {
    setState(() {
      allWatchlistItems.add(newWatchlistItem);
    });
  }
}
