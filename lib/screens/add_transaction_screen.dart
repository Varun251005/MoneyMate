import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String type = "expense";
  String category = "Food";
  DateTime selectedDate = DateTime.now();

  Future pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<String>(
              value: type,
              items: const [
                DropdownMenuItem(value: "expense", child: Text("Expense")),
                DropdownMenuItem(value: "income", child: Text("Income")),
              ],
              onChanged: (value) {
                setState(() {
                  type = value!;
                });
              },
            ),

            DropdownButton<String>(
              value: category,
              items: const [
                DropdownMenuItem(value: "Food", child: Text("Food")),
                DropdownMenuItem(value: "Travel", child: Text("Travel")),
                DropdownMenuItem(value: "Shopping", child: Text("Shopping")),
                DropdownMenuItem(value: "Bills", child: Text("Bills")),
                DropdownMenuItem(value: "Salary", child: Text("Salary")),
                DropdownMenuItem(value: "Other", child: Text("Other")),
              ],
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: "Note"),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: pickDate,
                  child: const Text("Select Date"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final amount = double.parse(amountController.text);

                await DatabaseHelper.instance.insertTransaction({
                  'type': type,
                  'amount': amount,
                  'category': category,
                  'note': noteController.text,
                  'date': DateFormat('yyyy-MM-dd').format(selectedDate),
                });

                Navigator.pop(context);
              },
              child: const Text("Save Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}
