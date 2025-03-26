import 'package:flutter/material.dart';
import 'model/category.dart';
import 'component/playercard.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Luxury background with pattern
              Container(
                width: MediaQuery.of(context).size.width,
                height: 500,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0A1128), // Deep navy blue
                      Color(0xFF1E3A8A), // Royal blue
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: 0.15,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/luxury_pattern.jpg',
                            ),
                            repeat: ImageRepeat.repeat,
                          ),
                        ),
                      ),
                    ),
                    // Gold accent line
                    Positioned(
                      top: 120,
                      left: 20,
                      child: Container(
                        height: 3,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // App bar with date
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat("MMMM d, yyyy").format(DateTime.now()),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Curved white overlay
              Positioned(
                top: 450,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(10, 0, 0, 0),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                ),
              ),

              // Main heading
              const Positioned(
                top: 160,
                left: 25,
                child: Text(
                  'PREMIUM EXPERIENCE',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: Color(0xFFFFD700), 
                    shadows: [
                      Shadow(
                        color: Color.fromARGB(100, 0, 0, 0),
                        offset: Offset(1.0, 1.0),
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                ),
              ),

              // Subheading
              const Positioned(
                top: 200,
                left: 25,
                child: Text(
                  'Elevate Your Match Day Experience',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.8,
                    color: Colors.white,
                  ),
                ),
              ),

              // Horizontal card list
              Positioned(
                top: 300,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return MyCard(item: items[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),

            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/matchlist');
                          },
                          icon: const Icon(Icons.stadium_rounded, size: 30),
                        ),
                        const Text('Match Day', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/community');
                          },
                          icon: const Icon(Icons.people_alt, size: 30),
                        ),
                        const Text('Community', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/stadium');
                          },
                          icon: const Icon(Icons.stadium, size: 30),
                        ),
                        const Text('Stadium', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/history');
                          },
                          icon: const Icon(Icons.history, size: 30),
                        ),
                        const Text('History', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const PlayeroftheWeek(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  const MyCard({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/newslist');
          },
          child: Container(
            width: 350,
            height: 210,
            margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(item.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(255, 59, 59, 59),
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                      ),

                      Text(
                        '${item.date} ${item.time}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(255, 59, 59, 59),
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
