import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_emi_screen.dart';
import '../services/notification_service.dart';

class EmiScreen extends StatefulWidget {
  const EmiScreen({super.key});

  @override
  State<EmiScreen> createState() => _EmiScreenState();
}

class _EmiScreenState extends State<EmiScreen> {
  List emiList = [];

  @override
  void initState() {
    super.initState();
    loadEmi();
  }

  Future loadEmi() async {
    final data = await DatabaseHelper.instance.getEmi();

    for (var e in data) {
      DateTime emiDate = DateTime.parse(e['date']);

      DateTime today = DateTime.now();

      if (emiDate.difference(today).inDays == 1) {
        NotificationService.showNotification(
          "EMI Reminder",
          "${e['title']} payment due tomorrow",
        );
      }
    }

    setState(() {
      emiList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EMI / Bills")),
      body: ListView.builder(
        itemCount: emiList.length,
        itemBuilder: (context, index) {
          final e = emiList[index];

          return ListTile(
            leading: const Icon(Icons.payment),
            title: Text(e['title']),
            subtitle: Text("₹${e['amount']}"),
            trailing: Text(e['date']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEmiScreen()),
          );

          loadEmi();
        },
      ),
    );
  }
}
