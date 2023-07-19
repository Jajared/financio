import 'package:flutter/material.dart';
import 'package:finance_tracker/screens/investments.dart';
import 'package:finance_tracker/screens/personal.dart';
import 'package:finance_tracker/screens/activity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final screens = [
    const Investments(),
    const Personal(),
    Activity(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedIconTheme:
              IconThemeData(color: const Color.fromRGBO(3, 169, 66, 0.6)),
          selectedItemColor: const Color.fromRGBO(3, 169, 66, 0.6),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: 'Investments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings),
              label: 'Personal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights),
              label: 'Activity',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onTabSelected,
        ));
  }

  void _onTabSelected(int index) {
    if (_selectedIndex == index) {
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }
}
