import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../firebase/activity_collection.dart';
import '../models/activity_model.dart';
import 'package:intl/intl.dart';

class Activity extends StatelessWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Recent Activity',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        body: Center(
          child: FutureBuilder<List<ActivityModel>>(
            future: ActivityCollection.instance.getAllActivity(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final data = snapshot.data!;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final activityItem = data[index];
                      return ActivityCard(
                        type: activityItem.type,
                        title: activityItem.title,
                        timestamp: activityItem.timestamp,
                      );
                    });
              }
            },
          ),
        ));
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard(
      {Key? key,
      required this.type,
      required this.title,
      required this.timestamp})
      : super(key: key);

  final String title;
  final String type;
  final Timestamp timestamp;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: _getIcon(),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${DateFormat('dd MMM').format(timestamp.toDate().toLocal())} at ${DateFormat('HH:mm').format(timestamp.toDate().toLocal())}",
        ),
      ),
    );
  }

  Icon _getIcon() {
    switch (type) {
      case "Investment":
        return const Icon(Icons.pie_chart);
      case "Personal":
        return const Icon(Icons.savings);
      default:
        return const Icon(Icons.error);
    }
  }
}
