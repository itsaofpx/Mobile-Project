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
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wish List"),
        BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "LUCKY COLOR"),
      ],
      currentIndex: currentIndex,
      selectedItemColor: const Color.fromARGB(255, 0, 36, 93),
      onTap: onTap,
    );
  }
}