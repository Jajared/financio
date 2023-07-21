import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/firebase/activity_collection.dart';
import 'package:finance_tracker/models/activity_model.dart';
import 'package:flutter/material.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  AddTransactionState createState() => AddTransactionState();
}

class AddTransactionState extends State<AddTransaction> {
  CategoryItem? selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<CategoryItem> categories = [
    CategoryItem('Transport', Icons.directions_car),
    CategoryItem('Food', Icons.restaurant),
    CategoryItem('Shopping', Icons.shopping_bag),
    CategoryItem('Entertainment', Icons.movie),
    CategoryItem('Travel', Icons.flight),
    CategoryItem('Health', Icons.favorite),
    CategoryItem('Education', Icons.school),
    CategoryItem('Other', Icons.category),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Add Transaction',
            style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
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
                  _saveTransaction();
                  Navigator.pop(context);
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
      decoration: InputDecoration(
        labelText: 'Category',
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
      items: categories.map((category) {
        return DropdownMenuItem<CategoryItem>(
          value: category,
          child: Row(
            children: [
              Icon(category.icon),
              const SizedBox(width: 8),
              Text(category.name),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _saveTransaction() {
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
        ),
      );
      return;
    }
    String amountText = _amountController.text;
    String description = _descriptionController.text;
    if (amountText.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }
    double amount;
    try {
      amount = double.parse(amountText);
    } catch (e) {
      // Handle case when the amount cannot be parsed to double
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid amount'),
        ),
      );
      return;
    }
    ActivityModel newActivity = ActivityModel(
      title: description,
      type: "Personal",
      timestamp: Timestamp.fromDate(DateTime.now()),
    );
    try {
      ActivityCollection.instance.addActivity(newActivity);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving transaction'),
        ),
      );
    }
  }
}

class CategoryItem {
  final String name;
  final IconData icon;

  CategoryItem(this.name, this.icon);
}
