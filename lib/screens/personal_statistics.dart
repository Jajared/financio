import 'package:finance_tracker/models/personal_model.dart';
import 'package:finance_tracker/widgets/personal_category_chart.dart';
import 'package:flutter/material.dart';

class PersonalStatistics extends StatelessWidget {
  final List<PersonalModel> transactionData;
  const PersonalStatistics({required this.transactionData, Key? key})
      : super(key: key);

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
      body: SizedBox(
          child: PersonalCategoryChart(transactionData: transactionData)),
    );
  }
}
