import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String title;
  final String type;
  final dynamic timestamp; // Recheck for type

  ActivityModel(
      {required this.title, required this.type, required this.timestamp});

  toJson() {
    return {
      'title': title,
      'type': type,
      'timestamp': timestamp,
    };
  }

  factory ActivityModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return ActivityModel(
      title: data!['title'],
      type: data['type'],
      timestamp: data['timestamp'],
    );
  }
}
