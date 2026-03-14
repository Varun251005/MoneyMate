import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final String value;
  final bool up;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
    required this.value,
    required this.up,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFE7F4F5),
              child: Icon(icon, color: const Color(0xFF1FA7A8)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(amount, style: const TextStyle(fontSize: 16))),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: up ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  up ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: up ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
