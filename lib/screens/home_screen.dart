import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_transaction_screen.dart';
import 'report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List transactions = [];

  double totalIncome = 0;
  double totalExpense = 0;
  double balance = 0;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future loadTransactions() async {
    final data = await DatabaseHelper.instance.getTransactions();

    double income = 0;
    double expense = 0;

    for (var t in data) {
      if (t['type'] == 'income') {
        income += t['amount'];
      } else {
        expense += t['amount'];
      }
    }

    setState(() {
      transactions = data;
      totalIncome = income;
      totalExpense = expense;
      balance = income - expense;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Finance Tracker")),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.teal,
            child: Column(
              children: [
                const Text(
                  "Balance",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),

                Text(
                  "₹ $balance",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Income",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "₹ $totalIncome",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        const Text(
                          "Expense",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "₹ $totalExpense",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportScreen(
                          income: totalIncome,
                          expense: totalExpense,
                        ),
                      ),
                    );
                  },
                  child: const Text("View Reports"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Transactions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final t = transactions[index];

                return Dismissible(
                  key: Key(t['id'].toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) async {
                    await DatabaseHelper.instance.deleteTransaction(t['id']);
                    loadTransactions();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Transaction deleted")),
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      t['type'] == 'income'
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: t['type'] == 'income' ? Colors.green : Colors.red,
                    ),
                    title: Text("₹${t['amount']}"),
                    subtitle: Text("${t['category']} • ${t['note']}"),
                    trailing: Text(t['date']),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );

          loadTransactions();
        },
      ),
    );
  }
}
