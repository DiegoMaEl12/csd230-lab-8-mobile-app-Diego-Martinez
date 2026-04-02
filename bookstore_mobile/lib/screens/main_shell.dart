import 'package:flutter/material.dart';
import 'book_list_screen.dart';
import 'magazine_list_screen.dart';
import 'laptop_list_screen.dart';
import 'phone_list_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Replace placeholders with real screens
  final List<Widget> _pages = [
    BookListScreen(),
    MagazineListScreen(),
    LaptopListScreen(),
    PhoneListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // Necessary for more than 3 items
        selectedItemColor: Colors.deepPurple,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Books"),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: "Mags"),
          BottomNavigationBarItem(icon: Icon(Icons.laptop), label: "Laptops"),
          BottomNavigationBarItem(icon: Icon(Icons.phone_android), label: "Phones"),
        ],
      ),
    );
  }
}