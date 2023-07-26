import 'package:finance_tracker/models/personal_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PersonalChart extends StatefulWidget {
  final List<PersonalModel> transactionData;
  const PersonalChart({
    Key? key,
    required this.transactionData,
  }) : super(key: key);
  final Color leftBarColor = Colors.green;
  final Color rightBarColor = Colors.red;
  @override
  PersonalChartState createState() => PersonalChartState();
}

class PersonalChartState extends State<PersonalChart> {
  final double width = 7;
  double maxY = 50;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BarChartGroupData>>(
      future: _prepareChartData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the futures to complete, show a loading indicator.
          return const Center(
              child: CircularProgressIndicator(
                  color: Color.fromRGBO(135, 57, 249, 1)));
        } else if (snapshot.hasError) {
          // If an error occurred while fetching data, display an error message.
          return const Center(child: Text('Error loading data'));
        } else {
          // The futures have completed successfully, and the chart data is available in snapshot.data.
          final List<BarChartGroupData> barGroups = snapshot.data ?? [];
          maxY = getMaxTransactionValue(barGroups);
          showingBarGroups = barGroups;
          rawBarGroups = showingBarGroups;
          return AspectRatio(
            aspectRatio: 1.7,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        maxY: maxY,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItem: (a, b, c, d) => null,
                          ),
                          touchCallback: (FlTouchEvent event, response) {
                            if (response == null || response.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex =
                                response.spot!.touchedBarGroupIndex;

                            setState(() {
                              if (!event.isInterestedForInteractions) {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                                return;
                              }
                              showingBarGroups = List.of(rawBarGroups);
                              if (touchedGroupIndex != -1) {
                                var sum = 0.0;
                                final barData =
                                    showingBarGroups[touchedGroupIndex].barRods;
                                for (final rod in barData) {
                                  sum += rod.toY;
                                }
                                var avg = 0.0;
                                if (barData[0].toY == 0 ||
                                    barData[1].toY == 0) {
                                  avg = barData[0].toY == 0
                                      ? barData[1].toY
                                      : barData[0].toY;
                                } else {
                                  avg = sum / barData.length;
                                }
                                final nettColor =
                                    barData[0].toY > barData[1].toY
                                        ? Colors.green
                                        : Colors.red;
                                showingBarGroups[touchedGroupIndex] =
                                    showingBarGroups[touchedGroupIndex]
                                        .copyWith(
                                  barRods: barData.map((rod) {
                                    return rod.copyWith(
                                        toY: avg, color: nettColor);
                                  }).toList(),
                                );
                              }
                            });
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
                              getTitlesWidget: bottomTitles,
                              reservedSize: 42,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: maxY / 5,
                              getTitlesWidget: leftTitles,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: showingBarGroups,
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: maxY / 5,
                          checkToShowVerticalLine: (value) => false,
                          checkToShowHorizontalLine: (value) => true,
                          getDrawingHorizontalLine: (value) {
                            return const FlLine(
                                strokeWidth: 0.8,
                                color: Color(0xffe7e8ec),
                                dashArray: [5, 10]);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Future<List<BarChartGroupData>> _prepareChartData() async {
    final List<PersonalModel> transactionData = widget.transactionData;
    final List<BarChartGroupData> barGroups =
        convertTransactionToChartData(transactionData);
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulating async operations.
    return barGroups;
  }

  convertTransactionToChartData(List<PersonalModel> transactionData) {
    final List<BarChartGroupData> barGroups = [];
    // Sort transactions by timestamp in descending order (most recent first)
    transactionData.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Limit the transactions to the latest 7 days
    final int numberOfDaysToShow = 7;
    final DateTime today = DateTime.now();
    final DateTime sevenDaysAgo =
        today.subtract(Duration(days: numberOfDaysToShow));
    final DateTime startDate = DateTime(
        sevenDaysAgo.year, sevenDaysAgo.month, sevenDaysAgo.day, 0, 0, 0, 0, 0);
    final List<PersonalModel> latestTransactions = transactionData
        .where(
            (transaction) => transaction.timestamp.toDate().isAfter(startDate))
        .toList();
    // Group the latest transactions by date
    final Map<String, List<double>> groupedData = {};
    for (final transaction in latestTransactions) {
      final date = transaction.timestamp
          .toDate()
          .toString()
          .split(' ')[0]; // Ext32ract date in 'yyyy-MM-dd' format
      if (groupedData.containsKey(date)) {
        groupedData[date]!.add(transaction.amount);
      } else {
        groupedData[date] = [transaction.amount];
      }
    }

    final List<MapEntry<String, List<double>>> sortedEntries =
        groupedData.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    int startIndex = sortedEntries.length > 7
        ? sortedEntries.length - 7
        : sortedEntries.length - 1;

    // Create BarChartGroupData from the grouped data
    for (int i = startIndex; i >= 0; i--) {
      final amounts = sortedEntries[i].value;
      double expenseAmount = 0;
      double incomeAmount = 0;
      for (final amount in amounts) {
        if (amount < 0) {
          expenseAmount += amount;
        } else {
          incomeAmount += amount;
        }
      }
      final barGroup =
          makeGroupData(6 + i - startIndex, incomeAmount, -expenseAmount);
      barGroups.insert(0, barGroup);
    }
    while (barGroups.length < 7) {
      barGroups.insert(0, makeGroupData(6 - barGroups.length, 0, 0));
    }

    return barGroups;
  }

  double getMaxTransactionValue(List<BarChartGroupData> barGroups) {
    double max = 0;
    for (final barGroup in barGroups) {
      final barData = barGroup.barRods;
      for (final rod in barData) {
        if (rod.toY > max) {
          max = rod.toY;
        }
      }
    }
    return max;
  }
}
