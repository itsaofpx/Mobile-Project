import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  const Detail({super.key});

  @override
  Widget build(BuildContext context) {
    // รับ arguments และแปลงเป็น Map
    final Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // ดึงค่าจาก Map
    final String image = arguments?['image'] ?? '';
    final String category = arguments?['category'] ?? 'No Category';
    final String des = arguments?['des'] ?? 'No Description';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail - $category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(image), // แสดงภาพ
            const SizedBox(height: 20),
            Text(
              'Category: $category',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Description : $des',
              style: const TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
