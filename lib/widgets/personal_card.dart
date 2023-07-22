import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalCard extends StatelessWidget {
  const PersonalCard(
      {Key? key,
      required this.category,
      required this.amount,
      required this.description,
      required this.timestamp})
      : super(key: key);

  final String category;
  final double amount;
  final String description;
  final Timestamp timestamp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        color: const Color.fromRGBO(27, 27, 27, 1),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIcon(category),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(255, 255, 255, 0.96),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(255, 255, 255, 0.67),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                amount < 0
                    ? "-\$${(-amount).toStringAsFixed(2)}"
                    : "\$${amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: amount < 0 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
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
      default:
        return const Icon(Icons.category, size: 26, color: Colors.grey);
    }
  }
}
