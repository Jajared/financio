class InvestmentModel {
  InvestmentModel({
    required this.ticker,
    required this.quantity,
    required this.sharePrice,
    required this.createdAt,
  });

  final String ticker;
  final int quantity;
  final double sharePrice;
  final DateTime createdAt;

  factory InvestmentModel.fromJson(Map<String, dynamic> json) =>
      InvestmentModel(
        ticker: json["ticker"],
        quantity: json["quantity"],
        sharePrice: json["sharePrice"].toDouble(),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "ticker": ticker,
        "quantity": quantity,
        "sharePrice": sharePrice,
        "createdAt": createdAt.toIso8601String(),
      };
}
