import 'package:flutter/material.dart';
import 'model/category.dart';
import 'component/playercard.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String?;
    bool isLogin = email != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none, 
            children: [
              
              Container(
                width: MediaQuery.of(context).size.width,
                height: 500, 
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF091442),
                      Color.fromARGB(255, 40, 78, 107),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
      
              Positioned(
                  top: 70,
                  left: 30,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: 450,
                    height: 50,
                    
                    child: Text(
                      'Today is ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Color.fromARGB(255, 118, 118, 118),
                            offset: Offset(1.0, 1.0),
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                    ),
                  )),
      
              Positioned(
                top: 70, 
                right: 30, 
                child: Container(
                  width: 40, 
                  height: 40, 
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, 
                    image: DecorationImage(
                        image: AssetImage(isLogin 
                            ? 'assets/images/user.png'
                            : 'assets/images/profile.png'),
                    fit: BoxFit.cover, 
                  ),
                ),
              ),
              ),
      
              Positioned(
                  top: 450,
                  left: 0,
                  child: Container(
                    width: 450,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  )),
              
              const Positioned(
                top: 160, 
                left: 20, 
                child: Text(
                  'Hi, Goodmorning!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Color.fromARGB(255, 118, 118, 118),
                        offset: Offset(1.0, 1.0),
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                ),
              ),
      
              
              const Positioned(
                top: 210, 
                left: 20, 
                child: Text(
                  'Welcome to GoalTix!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Color.fromARGB(255, 118, 118, 118),
                        offset: Offset(1.0, 1.0),
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                ),
              ),
      
              // const Positioned(
              //   top: 240, 
              //   left: 37, 
              //   child: Text(
              //     '1st Ticket App in the World',
              //     style: TextStyle(
              //       fontSize: 12,
              //       fontStyle: FontStyle.italic,
              //       color: Color.fromARGB(255, 255, 255, 255),
                    
              //     ),
              //   ),
              // ),
      
              
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
                      return MyCard(
                          item: items[index]); 
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
      
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              
              child:  Column(
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
                                icon: const Icon(
                                  Icons.stadium_rounded,
                                  size: 30,
                                )),
                            const Text(
                              'Match Day',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/community');
                                },
                                icon: const Icon(
                                  Icons.people_alt,
                                  size: 30,
                                )),
                            const Text(
                              'Community',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                         Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/newslist');
                                },
                                icon:const Icon(
                                  Icons.newspaper,
                                  size: 30,
                                )),
                            const Text(
                              'News',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.history,
                                  size: 30,
                                )),
                            Text(
                              'History',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ]),
      
                  const PlayeroftheWeek(),
                ],
              ))
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
        Container(
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
      ],
    );
  }
}
