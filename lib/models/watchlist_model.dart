class WatchListModel {
  final String ticker;
  final String description;

  WatchListModel({required this.ticker, required this.description});

  toJson() {
    return {
      'ticker': ticker,
      'description': description,
    };
  }

  factory WatchListModel.fromJson(Map<String, dynamic> json) {
    return WatchListModel(
      ticker: json['ticker'],
      description: json['description'],
    );
  }
}
