import 'package:flutter/material.dart';
import 'package:layout/Auth/login.dart';
import 'package:layout/Auth/sign_up.dart';
import 'screen.dart';

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
        '/signup': (context) => const SignUp(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
