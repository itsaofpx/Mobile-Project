import 'package:flutter/material.dart';


class BottomAdminNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomAdminNavbar({
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
      selectedItemColor: const Color(0xFF091442),
      unselectedItemColor: const Color.fromARGB(255, 122, 122, 122),
      onTap: onTap,
    );
  }
}