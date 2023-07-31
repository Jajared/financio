import 'package:financio/firebase/investment_collection.dart';
import 'package:financio/models/investment_model.dart';
import 'package:financio/models/watchlist_model.dart';
import 'package:financio/screens/add_investment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditWatchList extends StatefulWidget {
  final Function(WatchListModel) onDelete;
  final Function(InvestmentModel) addNewInvestment;
  final WatchListModel watchlist;
  const EditWatchList(
      {Key? key,
      required this.onDelete,
      required this.addNewInvestment,
      required this.watchlist})
      : super(key: key);

  @override
  EditWatchListState createState() => EditWatchListState();
}

class EditWatchListState extends State<EditWatchList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.watchlist.ticker),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              widget.onDelete(widget.watchlist);
              InvestmentCollection.instance
                  .deleteFromWatchList(widget.watchlist);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
      body: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text("📈 Watchlist Updates",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.watchlist.descriptions.length,
              itemBuilder: (context, index) {
                DescriptionModel description =
                    widget.watchlist.descriptions[index];
                return ListTile(
                  title: Text(
                    description.description,
                    style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.96)),
                  ),
                  subtitle: Text(
                    DateFormat('MMM d, HH:mm')
                        .format(description.timestamp.toDate()),
                    style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.96)),
                  ),
                  // You can add any other UI components you want for each description
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // Add horizontal padding
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => AddInvestment(
                                addInvestment: widget.addNewInvestment,
                                ticker: widget.watchlist.ticker)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(198, 81, 205, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Adjust border radius as needed Add border
                      ),
                    ),
                    child: const Text("Add to Investment"),
                  ),
                ),
                const SizedBox(
                    width: 20), // Add some spacing between the buttons
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your logic here for the "Add New Watchlist Updates" button
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    child: const Text("Update"),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
