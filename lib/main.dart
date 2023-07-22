import 'package:finance_tracker/screens/investments.dart';
import 'package:finance_tracker/screens/personal.dart';
import 'package:finance_tracker/screens/activity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase/activity_collection.dart';
import 'firebase/personal_collection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(ActivityCollection());
  Get.put(PersonalCollection());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Investments(),
    const Personal(),
    const Activity(),
  ];

  final ThemeData customTheme = ThemeData(
    primaryColor: const Color.fromRGBO(16, 16, 16, 1),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.67)),
      hintStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.67)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: Color.fromRGBO(36, 36, 36, 1), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: Color.fromRGBO(36, 36, 36, 1), width: 2),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      theme: customTheme,
      home: SafeArea(
          child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedIconTheme: const IconThemeData(
            color: Color.fromRGBO(255, 255, 255, 0.45),
          ),
          unselectedItemColor: const Color.fromRGBO(255, 255, 255, 0.45),
          backgroundColor: const Color.fromRGBO(16, 16, 16, 0.98),
          selectedIconTheme:
              const IconThemeData(color: Color.fromRGBO(198, 81, 205, 1)),
          selectedItemColor: const Color.fromRGBO(198, 81, 205, 1),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
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
        ),
      )),
      debugShowCheckedModeBanner: false,
    );
  }
}
