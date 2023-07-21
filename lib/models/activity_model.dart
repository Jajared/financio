import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String title;
  final String type;
  final Timestamp timestamp;

  ActivityModel(
      {required this.title, required this.type, required this.timestamp});

  toJson() {
    return {
      'title': title,
      'type': type,
      'timestamp': timestamp,
    };
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      title: json['title'],
      type: json['type'],
      timestamp: json['timestamp'],
    );
  }
}
