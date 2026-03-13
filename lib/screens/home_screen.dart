import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_transaction_screen.dart';
import 'report_screen.dart';
import 'emi_screen.dart';
import '../services/pdf_service.dart';

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
  String selectedMonth = DateTime.now().toString().substring(0, 7);

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future loadTransactions() async {
    final data = await DatabaseHelper.instance.getTransactions();

    double income = 0;
    double expense = 0;

    List filtered = [];

    for (var t in data) {
      if (t['date'].toString().startsWith(selectedMonth)) {
        filtered.add(t);

        if (t['type'] == 'income') {
          income += t['amount'];
        } else {
          expense += t['amount'];
        }
      }
    }

    setState(() {
      transactions = filtered;
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
          DropdownButton<String>(
            value: selectedMonth,
            items: List.generate(12, (index) {
              DateTime date = DateTime(DateTime.now().year, index + 1);
              String month =
                  "${date.year}-${date.month.toString().padLeft(2, '0')}";
              return DropdownMenuItem(value: month, child: Text(month));
            }),
            onChanged: (value) {
              setState(() {
                selectedMonth = value!;
              });
              loadTransactions();
            },
          ),
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
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmiScreen(),
                      ),
                    );
                  },
                  child: const Text("EMI / Bills"),
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Monthly Summary",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text("Income"),
                          Text(
                            "₹$totalIncome",
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Expense"),
                          Text(
                            "₹$totalExpense",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Savings"),
                          Text(
                            "₹$balance",
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              PdfService.generateReport(transactions);
            },
            child: const Text("Export PDF Report"),
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
