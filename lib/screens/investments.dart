import 'package:finance_tracker/models/investment_model.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/screens/add_investment.dart';

class Investments extends StatelessWidget {
  const Investments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Investments',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.96),
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddInvestment(),
                  ),
                );
              },
            ),
          ]),
      backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
      body: const Center(child: Text('Investments')),
    );
  }
}
