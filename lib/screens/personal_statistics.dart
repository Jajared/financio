import 'package:financio/models/personal_model.dart';
import 'package:financio/widgets/personal_category_chart.dart';
import 'package:flutter/material.dart';

class PersonalStatistics extends StatefulWidget {
  final List<PersonalModel> transactionData;
  const PersonalStatistics({required this.transactionData, Key? key})
      : super(key: key);

  @override
  PersonalStatisticsState createState() => PersonalStatisticsState();
}

class PersonalStatisticsState extends State<PersonalStatistics> {
  String _statisticsType = 'Income';
  List<PersonalModel> _filteredTransactionData = [];
  List<MapEntry<String, double>> _categorisedTransactionData = [];
  String selectedTimeFrame = '1W';

  @override
  void initState() {
    super.initState();
    var filteredByType =
        filterTransactionByType(_statisticsType, widget.transactionData);
    _filteredTransactionData =
        filterTransactionByDate(selectedTimeFrame, filteredByType);
    _categorisedTransactionData =
        categoriseTransaction(_filteredTransactionData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Personal Statistics',
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
          SizedBox(
            height: 48,
            child: Center(
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(8),
                borderColor: Colors.white,
                selectedBorderColor: Colors.white,
                color: Colors.white,
                selectedColor: Colors.black,
                fillColor: Colors.white,
                isSelected: [
                  _statisticsType == "Income",
                  _statisticsType == "Expenses"
                ],
                onPressed: (index) {
                  setState(() {
                    _statisticsType = index == 0 ? "Income" : "Expenses";
                    var temp = filterTransactionByType(
                        _statisticsType, widget.transactionData);
                    _filteredTransactionData =
                        filterTransactionByDate(selectedTimeFrame, temp);
                    _categorisedTransactionData =
                        categoriseTransaction(_filteredTransactionData);
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Income'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Expenses'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: PersonalCategoryChart(
                  transactionData: _filteredTransactionData)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeFrameButton('1W'),
              _buildTimeFrameButton('1M'),
              _buildTimeFrameButton('6M'),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              selectedTimeFrame == '1W'
                  ? 'Past week'
                  : selectedTimeFrame == '1M'
                      ? 'Past month'
                      : 'Past 6 months',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white.withOpacity(0.96),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _categorisedTransactionData.length,
              itemBuilder: (context, index) {
                return _buildListItem(_categorisedTransactionData[index].key,
                    _categorisedTransactionData[index].value);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Filter transactions by type (income or expenses)
  filterTransactionByType(String type, List<PersonalModel> transactionData) {
    return transactionData
        .where((item) => type == "Income" ? item.amount > 0 : item.amount < 0)
        .toList();
  }

  // Filter transactions by date
  filterTransactionByDate(
      String timeFrame, List<PersonalModel> transactionData) {
    var now = DateTime.now();
    var pastDate = DateTime.now();
    switch (timeFrame) {
      case '1W':
        pastDate = now.subtract(const Duration(days: 7));
        break;
      case '1M':
        pastDate = now.subtract(const Duration(days: 30));
        break;
      case '6M':
        pastDate = now.subtract(const Duration(days: 180));
        break;
      default:
        pastDate = now.subtract(const Duration(days: 7));
    }
    return transactionData
        .where((item) => item.timestamp.toDate().isAfter(pastDate))
        .toList();
  }

  // Group transactions of the same category
  List<MapEntry<String, double>> categoriseTransaction(
      List<PersonalModel> transactionData) {
    var temp = <String, double>{};
    for (var element in transactionData) {
      if (temp.containsKey(element.category)) {
        temp[element.category] = temp[element.category]! + element.amount;
      } else {
        temp[element.category] = element.amount;
      }
    }

    var sortedEntries = temp.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return sortedEntries;
  }

  Widget _buildListItem(String category, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildIcon(category),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            amount < 0
                ? '-\$${(amount * -1).toStringAsFixed(2)}'
                : '+\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String category) {
    switch (category) {
      case 'Transport':
        return const Icon(Icons.directions_car, size: 26, color: Colors.blue);
      case 'Food':
        return const Icon(Icons.restaurant, size: 26, color: Colors.red);
      case 'Shopping':
        return const Icon(Icons.shopping_bag, size: 26, color: Colors.orange);
      case 'Entertainment':
        return const Icon(Icons.movie, size: 26, color: Colors.purple);
      case 'Travel':
        return const Icon(Icons.flight, size: 26, color: Colors.yellow);
      case 'Health':
        return const Icon(Icons.favorite, size: 26, color: Colors.pink);
      case 'Education':
        return const Icon(Icons.school, size: 26, color: Colors.green);
      case 'Other':
        return const Icon(Icons.category, size: 26, color: Colors.grey);
      case 'Salary':
        return const Icon(Icons.money, size: 26, color: Colors.green);
      case 'Investment':
        return const Icon(Icons.attach_money, size: 26, color: Colors.blue);
      case 'Gift':
        return const Icon(Icons.card_giftcard, size: 26, color: Colors.green);
      case 'Other Income':
        return const Icon(Icons.category, size: 26, color: Colors.grey);
      default:
        return const Icon(Icons.category, size: 26, color: Colors.grey);
    }
  }

  ElevatedButton _buildTimeFrameButton(String timeFrame) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedTimeFrame = timeFrame;
          var temp =
              filterTransactionByType(_statisticsType, widget.transactionData);
          _filteredTransactionData =
              filterTransactionByDate(selectedTimeFrame, temp);
          _categorisedTransactionData =
              categoriseTransaction(_filteredTransactionData);
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedTimeFrame == timeFrame
            ? const Color.fromRGBO(198, 81, 205, 1)
            : const Color.fromRGBO(56, 56, 56, 1),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        side: BorderSide.none,
      ),
      child: Text(timeFrame),
    );
  }
}
