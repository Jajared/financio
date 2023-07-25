import 'package:flutter/material.dart';

class StockWatchList extends StatelessWidget {
  final List<StockWatchlistItem> watchlistItems = [
    StockWatchlistItem(symbol: "AAPL", name: "Apple Inc."),
    StockWatchlistItem(symbol: "GOOGL", name: "Alphabet Inc."),
    StockWatchlistItem(symbol: "AMZN", name: "Amazon.com Inc."),
    // Add more watchlist items here
  ];

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
        itemCount: watchlistItems.length,
        itemBuilder: (context, index) {
          final item = watchlistItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 2.0, // Add a shadow effect to the cards
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(item.symbol),
                trailing:
                    const Icon(Icons.arrow_forward_ios), // Add a trailing icon
                onTap: () {
                  // Implement the navigation to the detail page here
                  // For example, you can use Navigator.push to navigate to the detail page.
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class StockWatchlistItem {
  final String symbol;
  final String name;

  StockWatchlistItem({required this.symbol, required this.name});
}
