import 'package:flutter/material.dart';
import '/model/category.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

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

      body: const ListCategory(),
    );
  }
}

class ListCategory extends StatelessWidget {
  const ListCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(items: items[index]);
            },
          ),
        ),
      ],
    );
  }
}

class Card extends StatelessWidget {
  const Card({super.key, required this.items});

  final Category items;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/details2', arguments: {
          'image': items.image,
          'name': items.name,
        });
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: Colors.red
        ),
        height: 310,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              height: 250,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('assets/images/${items.image}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 45,
              // color: Colors.amber,
              child: Text("${items.name}", style: const TextStyle(fontSize: 25, color: Colors.black),),
            )
            
          ],
        ),
      ),
    );
  }
}

