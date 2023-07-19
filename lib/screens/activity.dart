import 'package:flutter/material.dart';

class Activity extends StatelessWidget {
  Activity({Key? key}) : super(key: key);
  final List<Map<String, dynamic>> data = [
    {'type': "Investment", "title": "Item 1", "timestamp": "12 Jul"},
    {'type': "Personal", 'title': "Item 2", 'timestamp': "11 Jul"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Recent Activity'),
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final activityItem = data[index];
            return ActivityCard(
              type: activityItem['type'],
              title: activityItem['title'],
              timestamp: activityItem['timestamp'],
            );
          }),
    );
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
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: _getIcon(),
        title: Text(title),
        subtitle: Text(timestamp),
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
