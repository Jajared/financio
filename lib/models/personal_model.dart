import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalModel {
  PersonalModel({
    required this.category,
    required this.amount,
    required this.description,
    required this.timestamp,
  });

  final String category;
  final double amount;
  final String description;
  final Timestamp timestamp;

  factory PersonalModel.fromJson(Map<String, dynamic> json) => PersonalModel(
        category: json["category"],
        amount: json["amount"].toDouble(),
        description: json["description"],
        timestamp: json["createdAt"],
      );

  toJson() => {
        "category": category,
        "amount": amount,
        "description": description,
        "createdAt": timestamp,
      };
}
