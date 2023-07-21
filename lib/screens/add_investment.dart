import 'package:flutter/material.dart';

class AddInvestment extends StatelessWidget {
  const AddInvestment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:
            const Text('Add Investment', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _inputBox('Ticker', 'Enter ticker'),
            const SizedBox(height: 16),
            _inputBox('Quantity', 'Enter amount',
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _inputBox('Share Price', 'Enter price',
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement your logic to handle the form submission here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(
                    3, 169, 66, 0.6), // Set the primary color to green
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save Investment'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputBox(String label, String hint,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextField(
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
}
