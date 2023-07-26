import 'package:cloud_firestore/cloud_firestore.dart';

class InvestmentModel {
  final String ticker;
  final int quantity;
  final double sharePrice;
  final Timestamp timestamp;

  InvestmentModel({
    required this.ticker,
    required this.quantity,
    required this.sharePrice,
    required this.timestamp,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentModel(
      ticker: json["ticker"],
      quantity: json["quantity"],
      sharePrice: json["sharePrice"].toDouble(),
      timestamp: json["createdAt"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ticker": ticker,
      "quantity": quantity,
      "sharePrice": sharePrice,
      "createdAt": timestamp,
    };
  }
}
