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
  String selectedTimeFrame = '1W';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeFrameButton('1W'),
              _buildTimeFrameButton('1M'),
              _buildTimeFrameButton('6M'),
            ],
          ),
          const SizedBox(height: 20),
          InvestmentChart(graphData: widget.graphData),
        ],
      ),
    );
  }

  ElevatedButton _buildTimeFrameButton(String timeFrame) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedTimeFrame = timeFrame;
        });
        // Add your logic to handle changing the time frame in the chart
        // You can use the selectedTimeFrame variable here to determine the selected option.
        // For example, you can pass this value to your InvestmentChart widget to update the data accordingly.
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedTimeFrame == timeFrame
            ? const Color.fromRGBO(198, 81, 205, 1)
            : const Color.fromRGBO(56, 56, 56, 1),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        side: BorderSide.none,
      ),
      child: Text(timeFrame),
    );
  }
}
