import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key, 
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.sports_soccer_sharp), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.card_membership), label: "My Ticket"),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Account"),
      ],
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      selectedItemColor: const Color.fromARGB(255, 219, 12, 12),
      unselectedItemColor: const Color.fromARGB(255, 122, 122, 122),
      onTap: onTap,
    );
  }
}