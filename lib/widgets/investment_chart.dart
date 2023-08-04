import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class InvestmentChart extends StatefulWidget {
  final List<dynamic> graphData;
  final String timeFrame;
  const InvestmentChart({
    Key? key,
    required this.graphData,
    required this.timeFrame,
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
  late String selectedTimeFrame;
  FlSpot? touchedSpot;

  @override
  void initState() {
    super.initState();
    maxY = widget.graphData
            .reduce((curr, next) =>
                curr['value'] > next['value'] ? curr : next)['value']
            .toDouble() /
        1000;
    selectedTimeFrame = widget.timeFrame;
  }

  @override
  void didUpdateWidget(InvestmentChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timeFrame != oldWidget.timeFrame) {
      setState(() {
        selectedTimeFrame = widget.timeFrame;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 25,
              left: 25,
              top: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  getDateFromSpot(touchedSpot),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: LineChart(
                  showAvg ? avgData() : mainData(),
                ))
              ],
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

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Color.fromRGBO(255, 255, 255, 0.67),
    );
    String text;
    if (value < 1000) {
      text = '${(value * 1000).toInt()}';
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
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              if (flSpot.x == 0 || flSpot.x == 6) {
                return null;
              }

              return LineTooltipItem(
                '${(flSpot.y.toDouble() * 1000).toInt()}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          if (touchResponse?.lineBarSpots != null &&
              touchResponse!.lineBarSpots!.length == 1) {
            setState(() {
              touchedSpot = touchResponse.lineBarSpots![0];
            });
          } else {
            setState(() {
              touchedSpot = null;
            });
          }
        },
        handleBuiltInTouches: true,
      ),
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
        bottomTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
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
      maxX: (selectedTimeFrame == "1W"
          ? 7
          : selectedTimeFrame == "1M"
              ? 30
              : 180),
      minY: 0,
      maxY: maxY,
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
        bottomTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
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
      maxX: (selectedTimeFrame == "1W"
          ? 7
          : selectedTimeFrame == "1M"
              ? 30
              : 180),
      minY: 0,
      maxY: 4,
      lineBarsData: [
        lineChartBarData,
      ],
    );
  }

  LineChartBarData convertToLineChartBarData(List<dynamic> graphData) {
    List<FlSpot> spots = [];
    int dataCount = 0;
    int startIndex = 0;
    if (selectedTimeFrame == "1W") {
      // Get last 7 days of data
      startIndex =
          graphData.length > 7 ? graphData.length - 7 : graphData.length - 1;
      dataCount = 7;
    } else if (selectedTimeFrame == "1M") {
      // Get last 30 days of data
      startIndex =
          graphData.length > 30 ? graphData.length - 30 : graphData.length - 1;
      dataCount = 30;
    } else if (selectedTimeFrame == "6M") {
      // Get last 6 months of data
      startIndex = graphData.length > 180
          ? graphData.length - 180
          : graphData.length - 1;
      dataCount = 180;
    }
    for (int i = startIndex; i >= 0; i--) {
      double value = graphData[i]['value'].toDouble();
      FlSpot spot =
          FlSpot((dataCount - 1 + i - startIndex).toDouble(), value / 1000);
      spots.insert(0, spot);
    }

    while (spots.length < dataCount) {
      spots.insert(0, FlSpot((dataCount - 1 - spots.length).toDouble(), 0));
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

  String getDateFromSpot(FlSpot? spot) {
    if (spot == null) {
      return '';
    }
    int dataCount = (selectedTimeFrame == "1W"
        ? 7
        : selectedTimeFrame == "1M"
            ? 30
            : 180);
    int index = spot.x.toInt();
    DateTime currentDate = DateTime.now();
    DateTime day = currentDate.subtract(Duration(days: dataCount - 1 - index));
    String text = '${day.day}/${day.month}';
    return text;
  }
}
