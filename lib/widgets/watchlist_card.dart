import 'package:financio/models/watchlist_model.dart';
import 'package:flutter/material.dart';

class WatchlistItemCard extends StatelessWidget {
  final WatchListModel item;

  const WatchlistItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 2.0,
        color: const Color.fromRGBO(27, 27, 27, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          title: Text(
            item.ticker,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(item.description,
              style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios), // Add a trailing icon
          onTap: () {
            // Implement the navigation to the detail page here
            // For example, you can use Navigator.push to navigate to the detail page.
          },
        ),
      ),
    );
  }
}
