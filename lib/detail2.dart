import 'package:flutter/material.dart';

class Detail2 extends StatelessWidget {
  const Detail2({super.key});

  @override
  Widget build(BuildContext context) {
    // รับ arguments และแปลงเป็น Map
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // ดึงค่าจาก Map
    final String image = arguments?['image'] ?? '';
    final String category = arguments?['name'] ?? 'No Category';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail2 - $category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/$image'), // แสดงภาพ
            const SizedBox(height: 20),
            Text(
              'Category: $category',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            AddCategory()
          ],
        ),
      ),
    );
  }
}

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      // color: Colors.red,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor:  MaterialStateProperty.all(const Color.fromARGB(255, 0, 36, 93),)),
              child: const Text('-',style: TextStyle(fontSize: 30,color: Colors.white),),
              onPressed: () {
                setState(() {
                  if (count > 0) {
                    count--;
                  }
                  else {
                    count = 0;
                  }
                });
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 70,
            height: 70,
            child: Text('$count',style: TextStyle(fontSize: 50,color: Colors.black),),
          ),
          Container(
            width: 70,
            height: 70,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor:  MaterialStateProperty.all(const Color.fromARGB(255, 0, 36, 93),)),
              child: const Text('+',style: TextStyle(fontSize: 25,color: Colors.white),),
              onPressed: () {
                setState(() {
                  count++;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
