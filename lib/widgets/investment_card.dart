import 'package:financio/models/investment_model.dart';
import 'package:financio/screens/sell_investment.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class InvestmentCard extends StatefulWidget {
  final InvestmentModel data;
  final double totalValue;
  final Function(InvestmentModel) onSell;

  const InvestmentCard(
      {Key? key,
      required this.data,
      required this.totalValue,
      required this.onSell})
      : super(key: key);

  @override
  _InvestmentCardState createState() => _InvestmentCardState();
}

class _InvestmentCardState extends State<InvestmentCard> {
  String fullStockName = '';
  String logoUrl = '';
  late String tickerSymbol = '';
  late double sharePrice = 0;
  late int quantity = 0;

  @override
  void initState() {
    super.initState();
    loadStockData();
    tickerSymbol = widget.data.ticker;
    sharePrice = widget.data.sharePrice;
    quantity = widget.data.quantity;
  }

  Future<void> loadStockData() async {
    fullStockName = await getStockFullName(tickerSymbol);
    final exchange = await getStockLogo(tickerSymbol);
    logoUrl = await getLogoUrl(exchange);
  }

  Future<String> getLogoUrl(exchange) async {
    switch (exchange) {
      case 'NASDAQ':
        return 'lib/assets/icons/nasdaq-icon.png';
      case 'NYSE':
        return 'lib/assets/icons/nyse-icon.png';
      default:
        return 'lib/assets/icons/nasdaq-icon.png';
    }
  }

  void _onSellInvestment(InvestmentModel sellInvestmentEvent) {
    widget.onSell(sellInvestmentEvent);
    setState(() {
      quantity -= sellInvestmentEvent.quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalValue = sharePrice * quantity;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SellInvestment(
              data: widget.data,
              name: fullStockName,
              totalValue: widget.totalValue,
              onSell: _onSellInvestment,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        color: const Color.fromRGBO(27, 27, 27, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: loadStockData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        logoUrl != ""
                            ? Image.asset(
                                logoUrl,
                                width: 24,
                                height: 24,
                              )
                            : const SizedBox(width: 24, height: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullStockName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tickerSymbol,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(255, 255, 255, 0.67),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${totalValue.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Get stock full name from json
  Future<String> getStockFullName(ticker) async {
    try {
      String jsonString = await DefaultAssetBundle.of(context)
          .loadString('lib/assets/stock_tickers.json');
      List<dynamic> data = json.decode(jsonString);
      Map<String, dynamic> stock = data.firstWhere(
        (stock) => stock['Ticker'] == ticker,
        orElse: () => null,
      );
      return stock['Name'];
    } catch (e) {
      return '';
    }
  }

  // Get stock logo from json
  Future<String> getStockLogo(ticker) async {
    try {
      String jsonString = await DefaultAssetBundle.of(context)
          .loadString('lib/assets/stock_tickers.json');
      List<dynamic> data = json.decode(jsonString);
      Map<String, dynamic> stock = data.firstWhere(
        (stock) => stock['Ticker'] == ticker,
        orElse: () => null,
      );
      final stockExchange = stock['Exchange'];
      return stockExchange;
    } catch (e) {
      return '';
    }
  }
}
