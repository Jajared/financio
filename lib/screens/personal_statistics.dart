import 'package:financio/models/personal_model.dart';
import 'package:financio/widgets/personal_category_chart.dart';
import 'package:flutter/material.dart';

class PersonalStatistics extends StatefulWidget {
  final List<PersonalModel> transactionData;
  const PersonalStatistics({required this.transactionData, Key? key})
      : super(key: key);

  @override
  _PersonalStatisticsState createState() => _PersonalStatisticsState();
}

class _PersonalStatisticsState extends State<PersonalStatistics> {
  String _statisticsType = 'Income';
  List<PersonalModel> _filteredTransactionData = [];
  String selectedTimeFrame = '1W';

  @override
  void initState() {
    super.initState();
    _filteredTransactionData =
        filterTransactionByType(_statisticsType, widget.transactionData);
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
                    _filteredTransactionData = filterTransactionByType(
                        _statisticsType, widget.transactionData);
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
          const SizedBox(height: 10),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _filteredTransactionData.length,
              itemBuilder: (context, index) {
                return _buildListItem(
                  _filteredTransactionData[index].category,
                  _filteredTransactionData[index].amount,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  filterTransactionByType(String type, List<PersonalModel> transactionData) {
    return transactionData
        .where((item) => type == "Income" ? item.amount < 0 : item.amount > 0)
        .toList();
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
