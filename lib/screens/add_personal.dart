import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/firebase/activity_collection.dart';
import 'package:finance_tracker/firebase/personal_collection.dart';
import 'package:finance_tracker/models/activity_model.dart';
import 'package:finance_tracker/models/personal_model.dart';
import 'package:flutter/material.dart';

class AddTransaction extends StatefulWidget {
  final Function(PersonalModel) onNewTransactionAdded;
  const AddTransaction({Key? key, required this.onNewTransactionAdded})
      : super(key: key);

  @override
  AddTransactionState createState() => AddTransactionState();
}

class AddTransactionState extends State<AddTransaction> {
  CategoryItem? selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<CategoryItem> expensesCategories = [
    CategoryItem('Transport', Icons.directions_car, Colors.blue),
    CategoryItem('Food', Icons.restaurant, Colors.orange),
    CategoryItem('Shopping', Icons.shopping_bag, Colors.red),
    CategoryItem('Entertainment', Icons.movie, Colors.purple),
    CategoryItem('Travel', Icons.flight, Colors.yellow),
    CategoryItem('Health', Icons.favorite, Colors.pink),
    CategoryItem('Education', Icons.school, Colors.green),
    CategoryItem('Other', Icons.category, Colors.grey),
  ];

  final List<CategoryItem> incomeCategories = [
    CategoryItem('Salary', Icons.money, Colors.green),
    CategoryItem('Investment', Icons.trending_up, Colors.blue),
    CategoryItem('Gift', Icons.card_giftcard, Colors.orange),
    CategoryItem('Other income', Icons.category, Colors.grey),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Add Transaction',
            style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.96))),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategoryDropdown(),
            const SizedBox(height: 24),
            _buildInputBox('Amount', 'Enter amount',
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildInputBox('Description', 'Enter description', maxLines: 3),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                try {
                  final result = _saveTransaction();
                  if (result) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error saving transaction'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(
                    3, 169, 66, 0.6), // Set the primary color to green
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBox(String label, String hint,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller:
          label == 'Amount' ? _amountController : _descriptionController,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<CategoryItem>(
      value: selectedCategory,
      dropdownColor: const Color.fromRGBO(27, 27, 27, 1),
      decoration: InputDecoration(
        labelText: 'Category',
        hintText: 'Select category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      onChanged: (newValue) {
        setState(() {
          selectedCategory = newValue;
        });
      },
      items: [...expensesCategories, ...incomeCategories].map((category) {
        return DropdownMenuItem<CategoryItem>(
          value: category,
          child: Row(
            children: [
              Icon(category.icon, color: category.color),
              const SizedBox(width: 8),
              Text(category.name, style: const TextStyle(color: Colors.white)),
            ],
          ),
        );
      }).toList(),
    );
  }

  bool _saveTransaction() {
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
        ),
      );
      return false;
    }
    String amountText = _amountController.text;
    String description = _descriptionController.text;
    if (amountText.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return false;
    }
    double amount;
    try {
      amount = double.parse(amountText);
      if (expensesCategories.contains(selectedCategory)) {
        amount = -amount;
      }
    } catch (e) {
      // Handle case when the amount cannot be parsed to double
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid amount'),
        ),
      );
      return false;
    }
    ActivityModel newActivity = ActivityModel(
      title: description,
      type: "Personal",
      timestamp: Timestamp.fromDate(DateTime.now()),
    );
    PersonalModel newPersonal = PersonalModel(
      amount: amount,
      category: selectedCategory!.name,
      description: description,
      timestamp: Timestamp.fromDate(DateTime.now()),
    );
    try {
      ActivityCollection.instance.addActivity(newActivity);
      PersonalCollection.instance.addPersonal(newPersonal);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving transaction'),
        ),
      );
    }
    widget.onNewTransactionAdded(newPersonal);
    return true;
  }
}

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem(this.name, this.icon, this.color);
}
