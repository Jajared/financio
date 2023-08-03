import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InvestmentSummary extends StatefulWidget {
  final double balance;
  final double profit;
  final List<dynamic> graphData;

  const InvestmentSummary({
    Key? key,
    required this.balance,
    required this.profit,
    required this.graphData,
  }) : super(key: key);

  @override
  _InvestmentSummaryState createState() => _InvestmentSummaryState();
}

class _InvestmentSummaryState extends State<InvestmentSummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(198, 81, 205, 1),
            Color.fromRGBO(135, 57, 249, 1),
            Color.fromARGB(255, 235, 126, 2)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(135, 57, 249, 0.9),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Portfolio Value',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${widget.balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Profit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    widget.profit >= 0
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: widget.profit >= 0
                        ? const Color.fromARGB(255, 24, 217, 30)
                        : const Color.fromARGB(255, 243, 101, 91),
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '\$${widget.profit.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.profit >= 0
                          ? const Color.fromARGB(255, 24, 217, 30)
                          : const Color.fromARGB(255, 243, 101, 91),
                    ),
                  ),
                ],
              ),
            ],
          ),
          InvestmentChart(graphData: widget.graphData)
        ],
      ),
    );
  }
}

class InvestmentChart extends StatefulWidget {
  final List<dynamic> graphData;
  const InvestmentChart({
    Key? key,
    required this.graphData,
  }) : super(key: key);

  @override
  State<InvestmentChart> createState() => InvestmentChartState();
}

class InvestmentChartState extends State<InvestmentChart> {
  List<Color> gradientColors = [Colors.white, Colors.white];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          width: 200,
          height: 100,
          child: AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: LineChart(mainData()),
            ),
          ),
        )
      ],
    );
  }

  LineChartData mainData() {
    LineChartBarData lineChartBarData =
        convertToLineChartBarData(widget.graphData);
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: const FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 5,
      lineBarsData: [
        lineChartBarData,
      ],
    );
  }

  LineChartBarData convertToLineChartBarData(List<dynamic> graphData) {
    List<FlSpot> spots = [];
    int startIndex =
        graphData.length > 7 ? graphData.length - 7 : graphData.length - 1;
    for (int i = startIndex; i >= 0; i--) {
      double value = graphData[i]['value'].toDouble();
      FlSpot spot = FlSpot((6 + i - startIndex).toDouble(), value / 1000);
      spots.insert(0, spot);
    }

    while (spots.length < 7) {
      spots.insert(0, FlSpot((6 - spots.length).toDouble(), 0));
    }

    return LineChartBarData(
        spots: spots,
        isCurved: false,
        color: Colors.white.withOpacity(0.5),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false));
  }
}
