import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'report_screen.dart';
import 'emi_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List screens = [
    const HomeScreen(),
    const ReportScreen(income: 0, expense: 0),
    const EmiScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: "Reports",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "EMI"),
        ],
      ),
    );
  }
}
