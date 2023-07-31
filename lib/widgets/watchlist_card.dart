import 'package:financio/models/investment_model.dart';
import 'package:financio/models/watchlist_model.dart';
import 'package:financio/screens/edit_watchlist.dart';
import 'package:flutter/material.dart';

class WatchlistItemCard extends StatelessWidget {
  final Function(WatchListModel) onDelete;
  final Function(InvestmentModel) addNewInvestment;
  final WatchListModel item;

  const WatchlistItemCard(
      {required this.onDelete,
      required this.addNewInvestment,
      required this.item});

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
          subtitle: Text(item.descriptions.last.description,
              style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios,
              color: Colors.white), // Add a trailing icon
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditWatchList(
                  addNewInvestment: addNewInvestment,
                  watchlist: item,
                  onDelete: (WatchListModel watchlist) {
                    onDelete(watchlist);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
