import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
  List<Color> gradientColors = [
    const Color.fromRGBO(198, 81, 205, 1),
    const Color.fromRGBO(135, 57, 249, 1)
  ];
  double maxY = 0;
  bool showAvg = false;

  @override
  void initState() {
    super.initState();
    maxY = widget.graphData
            .reduce((curr, next) =>
                curr['value'] > next['value'] ? curr : next)['value']
            .toDouble() /
        1000;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 20,
              left: 10,
              top: 24,
            ),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
        /* SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ), **/
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Color.fromRGBO(255, 255, 255, 0.67),
    );
    DateTime currentDate = DateTime.now();
    DateTime day = currentDate.subtract(Duration(days: 6 - value.toInt()));
    String text = '${day.day}/${day.month}';
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Color.fromRGBO(255, 255, 255, 0.67),
    );
    String text;
    if (value < 1000) {
      text = '${value.toInt()}k';
    } else if (value < 1000000) {
      text = '${(value / 1000).toStringAsFixed(2)}k';
    } else {
      text = '${(value / 1000000).toStringAsFixed(2)}M';
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    LineChartBarData lineChartBarData =
        convertToLineChartBarData(widget.graphData);
    return LineChartData(
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
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: maxY / 5,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
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
      maxY: 4,
      lineBarsData: [
        lineChartBarData,
      ],
    );
  }

  LineChartData avgData() {
    LineChartBarData lineChartBarData =
        convertToLineChartBarData(widget.graphData);
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: maxY / 5,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 4,
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
      gradient: LinearGradient(
        colors: gradientColors,
      ),
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    );
  }
}
