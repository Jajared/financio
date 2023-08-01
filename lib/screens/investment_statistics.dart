import 'package:financio/widgets/investment_chart.dart';
import 'package:flutter/material.dart';

class InvestmentStatistics extends StatefulWidget {
  final List<dynamic> graphData;
  const InvestmentStatistics({required this.graphData, Key? key})
      : super(key: key);

  @override
  _InvestmentStatisticsState createState() => _InvestmentStatisticsState();
}

class _InvestmentStatisticsState extends State<InvestmentStatistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Investment Statistics',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.96),
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InvestmentChart(graphData: widget.graphData),
        ],
      ),
    );
  }
}
