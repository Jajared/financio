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
  String _statisticsType = 'Income'; // Flag to track which chart to show

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
              // Center the ToggleButtons horizontally
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
          Expanded(
            child: _statisticsType == 'Income'
                ? PersonalCategoryChart(
                    transactionData: widget.transactionData,
                    type: 'Income',
                  )
                : PersonalCategoryChart(
                    transactionData: widget.transactionData,
                    type: 'Expenses',
                  ),
          ),
        ],
      ),
    );
  }
}
