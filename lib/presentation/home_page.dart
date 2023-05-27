import 'package:flutter/material.dart';
import 'package:foodie_hub/presentation/setting_page.dart';

import 'list_restaurant_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  final List<Widget> _listWidget = [const ListRestaurantPage(), const SettingPage()];

  final List<BottomNavigationBarItem> _bottomNavBarItems = const [
    BottomNavigationBarItem(
        icon: Icon(Icons.home), label: 'Home', backgroundColor: Colors.black),
    BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
        backgroundColor: Colors.black),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
