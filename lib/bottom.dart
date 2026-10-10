import 'package:flutter/material.dart';

import 'home.dart';
import 'Catogories.dart';
import 'Reports.dart';
import 'Settings.dart';
import 'add.dart';

class BottomNavScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const BottomNavScreen({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;

  List<Widget> get screens => [
    const Home(),
    Reports(),
    const CategoriesPage(),
    Settings(
      onThemeChanged: widget.onThemeChanged,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color navBgColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color.fromARGB(255, 240, 241, 241);

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        color: navBgColor,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, "Home", 0),
            _buildNavItem(Icons.person_2_outlined, "Reports", 1),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddExpensePage()),
                );
              },
              child: Container(
                width: 55,
                height: 55,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),

            _buildNavItem(Icons.account_balance_outlined, "Categories", 2),
            _buildNavItem(Icons.settings, "Settings", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = currentIndex == index;
    final Color selectedColor = Colors.pink;
    final Color unselectedColor = isDark ? Colors.grey[400]! : Colors.grey;

    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? selectedColor : unselectedColor),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? selectedColor : unselectedColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
