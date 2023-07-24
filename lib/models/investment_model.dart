import 'package:cloud_firestore/cloud_firestore.dart';

class InvestmentModel {
  InvestmentModel({
    required this.ticker,
    required this.quantity,
    required this.sharePrice,
    required this.timestamp,
  });

  final String ticker;
  final int quantity;
  final double sharePrice;
  final Timestamp timestamp;

  factory InvestmentModel.fromJson(Map<String, dynamic> json) =>
      InvestmentModel(
        ticker: json["ticker"],
        quantity: json["quantity"],
        sharePrice: json["sharePrice"].toDouble(),
        timestamp: json["createdAt"],
      );

  toJson() => {
        "ticker": ticker,
        "quantity": quantity,
        "sharePrice": sharePrice,
        "createdAt": timestamp,
      };
}
