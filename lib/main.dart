import 'package:flutter/material.dart';
import 'screen.dart';
import 'detail.dart';
import 'detail2.dart';
import 'list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(fontFamily: "poppins"),
      home: const MainScreen(),
      initialRoute: '/',
      routes: {
        '/home': (context) => const MainScreen(),
        '/list': (context) => const ListScreen(),
        '/details': (context) => const Detail(),
        '/details2': (context) => const Detail2()
      },
    );
  }
}
