import 'package:finance_tracker/models/investment_model.dart';
import 'package:finance_tracker/screens/sell_investment.dart';
import 'package:flutter/material.dart';

class InvestmentCard extends StatefulWidget {
  final String tickerSymbol;
  final double sharePrice;
  final int quantity;
  final Function(List<InvestmentModel>) onSell;

  const InvestmentCard(
      {Key? key,
      required this.tickerSymbol,
      required this.sharePrice,
      required this.quantity,
      required this.onSell})
      : super(key: key);

  @override
  _InvestmentCardState createState() => _InvestmentCardState();
}

class _InvestmentCardState extends State<InvestmentCard> {
  @override
  Widget build(BuildContext context) {
    double totalValue = widget.sharePrice * widget.quantity;

    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SellInvestment(
                ticker: widget.tickerSymbol,
                onSell: widget.onSell,
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
                Text(
                  widget.tickerSymbol,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(255, 255, 255, 0.96)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Share Price: \$${widget.sharePrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromRGBO(255, 255, 255, 0.67)),
                ),
                Text(
                  'Quantity: ${widget.quantity}',
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
