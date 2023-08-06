import 'package:financio/firebase/personal_collection.dart';
import 'package:financio/models/personal_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalChart extends StatefulWidget {
  final String timeFrame;
  const PersonalChart({
    Key? key,
    required this.timeFrame,
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
  String timeFrame = 'Week';
  int touchedGroupIndex = -1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _prepareChartData();
  }

  @override
  void didUpdateWidget(PersonalChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timeFrame != widget.timeFrame) {
      setState(() {
        timeFrame = widget.timeFrame;
        _prepareChartData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || showingBarGroups.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return AspectRatio(
      aspectRatio: 2,
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

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }

                        showingBarGroups = List.of(rawBarGroups);

                        if (touchedGroupIndex != -1) {
                          final barData =
                              showingBarGroups[touchedGroupIndex].barRods;
                          if (barData.length >= 2) {
                            final double income = barData[0].toY;
                            final double expense = barData[1].toY;
                            final double average = (income + expense) / 2;
                            final Color averageColor =
                                income > expense ? Colors.green : Colors.red;
                            showingBarGroups[touchedGroupIndex] =
                                showingBarGroups[touchedGroupIndex].copyWith(
                                    barRods: barData.map((rod) {
                              return rod.copyWith(
                                  toY: average, color: averageColor);
                            }).toList());
                          }
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
                        reservedSize: 50,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
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

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    List<String> getDataTitles(String selectedTimeFrame) {
      final currentDate = DateTime.now();
      final titles = <String>[];

      if (selectedTimeFrame == 'Week') {
        final startofWeek = getStartOfWeek(currentDate);
        // Get last 7 weeks
        for (int i = 4; i >= 0; i--) {
          final weekDate = startofWeek.subtract(Duration(days: i * 7));
          final formattedStartDate = DateFormat('MMM dd').format(weekDate);
          final formattedEndDate = DateFormat('MMM dd')
              .format(weekDate.add(const Duration(days: 6)));
          titles.add('$formattedStartDate\n$formattedEndDate');
        }
      } else if (selectedTimeFrame == 'Day') {
        // Get last 7 days
        for (int i = 6; i >= 0; i--) {
          final dayDate = currentDate.subtract(Duration(days: i));
          final formattedDate = DateFormat('dd').format(dayDate);
          final formattedMonth = DateFormat('MMM').format(dayDate);
          titles.add("$formattedDate\n$formattedMonth");
        }
      } else if (selectedTimeFrame == 'Month') {
        // Get last 7 months
        for (int i = 6; i >= 0; i--) {
          final monthDate = currentDate.subtract(Duration(days: i * 30));
          final formattedMonth = DateFormat('MMM').format(monthDate);
          titles.add(formattedMonth);
        }
      }

      return titles;
    }

    final titles = getDataTitles(timeFrame);

    final Widget text = Center(
      child: Text(
        titles[value.toInt()],
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 15,
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

  Future<void> _prepareChartData() async {
    setState(() {
      isLoading = true;
    });
    final List<PersonalModel> transactionData =
        await PersonalCollection.instance.getAllPersonal();
    final List<BarChartGroupData> barGroups =
        await convertTransactionToChartData(transactionData, timeFrame);
    setState(() {
      maxY = getMaxTransactionValue(barGroups);
      rawBarGroups = barGroups;
      showingBarGroups = rawBarGroups;
      isLoading = false;
    });
  }

  Future<List<BarChartGroupData>> convertTransactionToChartData(
      List<PersonalModel> transactionData, String selectedTimeFrame) async {
    // Sort transactions by timestamp in descending order (most recent first)
    transactionData.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    // Determine the number of days to show based on the selected timeframe
    late int numberOfDaysToShow;
    if (selectedTimeFrame == 'Week') {
      numberOfDaysToShow = 5 * 7; // Show data for the past 7 weeks
    } else if (selectedTimeFrame == 'Day') {
      numberOfDaysToShow = 7; // Show data for the past 7 days
    } else if (selectedTimeFrame == 'Month') {
      numberOfDaysToShow = 7 * 30; // Show data for the past 7 months
    }

    // Limit the transactions to the selected timeframe
    final DateTime today = DateTime.now();
    final DateTime timeFrameStartDate =
        today.subtract(Duration(days: numberOfDaysToShow));
    final DateTime startDate = DateTime(timeFrameStartDate.year,
        timeFrameStartDate.month, timeFrameStartDate.day, 0, 0, 0, 0, 0);
    final List<PersonalModel> selectedTimeFrameTransactions = transactionData
        .where(
            (transaction) => transaction.timestamp.toDate().isAfter(startDate))
        .toList();

    // Group the selected transactions by date
    final Map<DateTime, List<double>> groupedData = {};
    for (final transaction in selectedTimeFrameTransactions) {
      final date = transaction.timestamp.toDate();
      final dateKey = DateTime(date.year, date.month, date.day);
      if (groupedData.containsKey(dateKey)) {
        groupedData[dateKey]!.add(transaction.amount);
      } else {
        groupedData[dateKey] = [transaction.amount];
      }
    }

    // Map to store aggregated data (income and expense must be seperated)
    late Map<DateTime, Map<String, double>> aggregatedData;
    if (selectedTimeFrame == "Day") {
      aggregatedData = {};
      for (int i = 0; i < 7; i++) {
        final DateTime selectedDate = today.subtract(Duration(days: i));
        final DateTime dateKey =
            DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
        // Filter data that lies within the day
        double dayIncomeTotal = 0;
        double dayExpenseTotal = 0;
        for (final entry in groupedData.entries) {
          final DateTime date = entry.key;
          if (date.isAtSameMomentAs(dateKey)) {
            for (final transaction in entry.value) {
              if (transaction > 0) {
                dayIncomeTotal += transaction;
              } else {
                dayExpenseTotal += -transaction;
              }
            }
          }
        }
        aggregatedData[dateKey] = {
          "income": dayIncomeTotal,
          "expense": dayExpenseTotal
        };
      }
    } else if (selectedTimeFrame == "Week") {
      aggregatedData = {};
      final startOfWeek = getStartOfWeek(today);
      for (int i = 0; i < 5; i++) {
        final DateTime weekStartDate =
            startOfWeek.subtract(Duration(days: i * 7));
        final DateTime weekEndDate = weekStartDate.add(const Duration(days: 6));
        // Filter data that lies within the week
        double weekIncomeTotal = 0;
        double weekExpenseTotal = 0;
        for (final entry in groupedData.entries) {
          final DateTime dateKey = entry.key;
          if (dateKey.isAfter(weekStartDate) && dateKey.isBefore(weekEndDate)) {
            for (final transaction in entry.value) {
              if (transaction > 0) {
                weekIncomeTotal += transaction;
              } else {
                weekExpenseTotal += -transaction;
              }
            }
          }
        }
        aggregatedData[weekStartDate] = {
          "income": weekIncomeTotal,
          "expense": weekExpenseTotal
        };
      }
    } else if (selectedTimeFrame == "Month") {
      aggregatedData = {};
      for (int i = 0; i < 7; i++) {
        final DateTime currentDate = today.subtract(Duration(days: i * 30));
        final DateTime monthStartDate =
            DateTime(currentDate.year, currentDate.month, 1);
        final DateTime monthEndDate =
            DateTime(currentDate.year, currentDate.month + 1, 1)
                .subtract(const Duration(days: 1));

        // Filter data that lies within the month
        double monthIncomeTotal = 0;
        double monthExpenseTotal = 0;
        for (final entry in groupedData.entries) {
          final DateTime dateKey = entry.key;
          if (dateKey.isAfter(monthStartDate) &&
              dateKey.isBefore(monthEndDate)) {
            for (final transaction in entry.value) {
              if (transaction > 0) {
                monthIncomeTotal += transaction;
              } else {
                monthExpenseTotal += -transaction;
              }
            }
          }
        }
        aggregatedData[monthStartDate] = {
          "income": monthIncomeTotal,
          "expense": monthExpenseTotal
        };
      }
    }

    // Create BarChartGroupData from the aggregated data and fill with empty data for missing dates
    List<MapEntry<DateTime, Map<String, double>>> dataList =
        aggregatedData.entries.toList();
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < dataList.length; i++) {
      final double incomeAmount = dataList[i].value["income"] ?? 0;
      final double expenseAmount = dataList[i].value["expense"] ?? 0;
      barGroups.insert(0,
          makeGroupData(dataList.length - 1 - i, incomeAmount, expenseAmount));
    }

    return barGroups;
  }

  double getMaxTransactionValue(List<BarChartGroupData> barGroups) {
    double max = 0;
    for (final barGroup in barGroups) {
      for (final barRod in barGroup.barRods) {
        if (barRod.toY > max) {
          max = barRod.toY;
        }
      }
    }
    return max;
  }

  DateTime getStartOfWeek(DateTime date) {
    int daysSinceMonday = date.weekday - DateTime.monday;
    if (daysSinceMonday >= 0) {
      return date.subtract(Duration(days: daysSinceMonday));
    } else {
      return date.subtract(Duration(days: date.weekday + 1));
    }
  }
}
