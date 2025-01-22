import 'package:flutter/material.dart';
import 'model/category.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override    
  Widget build(BuildContext context) {
    
  
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 36, 93),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context ,'/home');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
            //  Navigator.pushNamed(context ,'/list');
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: PageView.builder(
          scrollDirection: Axis.horizontal, // เลื่อนในแนวนอน
          itemCount: pages.length, // จำนวนหน้าที่จะแสดง
          itemBuilder: (context, index) {
            final page = pages[index];
            return InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                '/details',
                arguments: {
                  'image': page['image'],
                  'category': page['category'],
                  'des': page['des'],
                },
              ),
              child: Image.asset(
                page['image'],
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
