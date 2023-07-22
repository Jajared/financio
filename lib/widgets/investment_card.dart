import 'package:finance_tracker/screens/sell_investment.dart';
import 'package:flutter/material.dart';

class InvestmentCard extends StatelessWidget {
  final String tickerSymbol;
  final double sharePrice;
  final int quantity;

  const InvestmentCard({
    Key? key,
    required this.tickerSymbol,
    required this.sharePrice,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalValue = sharePrice * quantity;

    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SellInvestment(ticker: tickerSymbol),
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
                Text(
                  tickerSymbol,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(255, 255, 255, 0.96)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Share Price: \$${sharePrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromRGBO(255, 255, 255, 0.67)),
                ),
                Text(
                  'Quantity: $quantity',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(255, 255, 255, 0.67),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Value: \$${totalValue.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: totalValue >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
