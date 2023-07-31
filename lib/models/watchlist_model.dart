import 'package:cloud_firestore/cloud_firestore.dart';

class WatchListModel {
  final String ticker;
  final List<DescriptionModel> descriptions;

  WatchListModel({required this.ticker, required this.descriptions});

  toJson() {
    return {
      'ticker': ticker,
      'descriptions': descriptions,
    };
  }

  factory WatchListModel.fromJson(Map<String, dynamic> json) {
    return WatchListModel(
      ticker: json['ticker'],
      descriptions: json['descriptions'].map<DescriptionModel>((item) {
        return DescriptionModel.fromJson(item);
      }).toList(),
    );
  }
}

class DescriptionModel {
  final String description;
  final Timestamp timestamp;

  DescriptionModel({required this.description, required this.timestamp});

  Map<String, dynamic> toJson() {
    return {'description': description, 'timestamp': timestamp};
  }

  factory DescriptionModel.fromJson(Map<String, dynamic> json) {
    return DescriptionModel(
      description: json['description'],
      timestamp: json['timestamp'],
    );
  }
}
