import 'package:flutter/material.dart';
import 'package:layout/Admin/ManageUsers/manage_users.dart';
import 'package:layout/Admin/ManageUsers/match.dart';
import 'package:layout/Admin/admin.dart';
import 'package:layout/Auth/login.dart';
import 'package:layout/Auth/sign_up.dart';
import 'package:layout/Community/team.dart';
import 'package:layout/Community/team_community.dart';
import 'package:layout/MatchDay/listmatch.dart';
import 'package:layout/News/newslist.dart';
import 'package:layout/News/addNews.dart';
import 'package:layout/History/history.dart';
import 'package:layout/account.dart';
import 'screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  // ต้องเรียก ensureInitialized ก่อนเริ่ม Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // รอให้ Firebase initialize เสร็จก่อน
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
        '/account': (context) => const Account(),
        '/matchlist': (context) => MatchListScreen(),
        '/community' : (context) => const Team(),
        '/teamcommunity': (context) => const TeamCommunity(),
        '/newslist': (context) => const NewsListPage(),
        '/admin': (context) => const AdminHomePage(),
        '/admin/users': (context) => const AdminUsersPage(),
        '/admin/match': (context) => const AddMatchScreen(),
        '/history': (context) =>  HistoryPage(),
        '/admin/addnews': (context) => const AddNewsPage(),
      },
    );
  }
}
