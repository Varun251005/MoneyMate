import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../widgets/transaction_card.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> transactions = [];
  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
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
      totalBalance = income - expense;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Money Mate',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: const Color(0xFF1FA7A8),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Balance Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1FA7A8), Color(0xFF15858A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1FA7A8).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '₹${totalBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Income & Expense Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Income',
                      '₹${totalIncome.toStringAsFixed(0)}',
                      Colors.green,
                      Icons.add_circle_outline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Expense',
                      '₹${totalExpense.toStringAsFixed(0)}',
                      Colors.red,
                      Icons.remove_circle_outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Recent Transactions Header
              Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Transactions List
              if (transactions.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: const [
                        Icon(Icons.receipt_long, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'No transactions yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return InkWell(
                      onTap: () {
                        _showTransactionDetails(context, transaction);
                      },
                      child: TransactionCard(
                        transaction: transaction,
                        onDelete: () async {
                          await DatabaseHelper.instance.deleteTransaction(
                            transaction['id'],
                          );
                          _loadData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Transaction deleted'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
          _loadData();
        },
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String amount,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Builder(
        builder: (context) {
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          final textColor = isDarkMode ? Colors.white70 : Colors.grey[600];
          final amountColor = isDarkMode ? Colors.white : Colors.black;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showTransactionDetails(
    BuildContext context,
    Map<String, dynamic> transaction,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Transaction Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title/Category
                _buildDetailRow(
                  'Title',
                  transaction['category']?.toString() ?? 'Other',
                ),
                const SizedBox(height: 12),

                // Amount
                _buildDetailRow(
                  'Amount',
                  '₹${transaction['amount'].toStringAsFixed(2)}',
                  isAmount: true,
                  isIncome: transaction['type'] == 'income',
                ),
                const SizedBox(height: 12),

                // Category
                _buildDetailRow(
                  'Category',
                  transaction['category']?.toString() ?? 'Other',
                ),
                const SizedBox(height: 12),

                // Date
                _buildDetailRow(
                  'Date',
                  transaction['date']?.toString() ?? 'No date',
                ),
                const SizedBox(height: 12),

                // Type
                _buildDetailRow(
                  'Type',
                  transaction['type'] == 'income' ? 'Income' : 'Expense',
                  isType: true,
                  isIncome: transaction['type'] == 'income',
                ),
                const SizedBox(height: 12),

                // Description/Note
                _buildDetailRow(
                  'Description',
                  transaction['note']?.toString().isNotEmpty == true
                      ? transaction['note']
                      : 'No description provided',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isAmount = false,
    bool isType = false,
    bool isIncome = false,
  }) {
    Color valueColor = Colors.grey[700] ?? Colors.grey;

    if (isAmount) {
      valueColor = isIncome ? Colors.green : Colors.red;
    } else if (isType) {
      valueColor = isIncome ? Colors.green : Colors.red;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
