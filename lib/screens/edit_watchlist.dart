import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<DescriptionModel> descriptions = [];

  @override
  void initState() {
    super.initState();
    descriptions = widget.watchlist.descriptions;
  }

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
              itemCount: descriptions.length,
              itemBuilder: (context, index) {
                DescriptionModel description = descriptions[index];
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
                      _showUpdateBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(135, 57, 249, 1),
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

  // Function to show the bottom sheet
  void _showUpdateBottomSheet(BuildContext context) {
    TextEditingController _updateController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: const Color.fromRGBO(40, 40, 40, 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add Update for ${widget.watchlist.ticker}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextField(
                controller: _updateController,
                decoration: InputDecoration(
                  hintText: 'Enter update...',
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(
                            198, 81, 205, 1)), // Change the color here
                    borderRadius: BorderRadius.circular(
                        8), // You can adjust the radius as needed
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
              ),
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
                            String update = _updateController.text.trim();
                            if (update.isNotEmpty) {
                              DescriptionModel newUpdate = DescriptionModel(
                                  description: update,
                                  timestamp:
                                      Timestamp.fromDate(DateTime.now()));
                              List<DescriptionModel> updatedDescriptions =
                                  List.of(descriptions)..add(newUpdate);

                              WatchListModel updatedWatchListitem =
                                  WatchListModel(
                                      ticker: widget.watchlist.ticker,
                                      descriptions: updatedDescriptions);
                              InvestmentCollection.instance.updateWatchListItem(
                                  widget.watchlist, updatedWatchListitem);
                              setState(
                                  () => descriptions = updatedDescriptions);
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Update'),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }
}
