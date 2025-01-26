import 'package:flutter/material.dart';
import 'model/category.dart';
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
            clipBehavior: Clip.none, // อนุญาตให้วัตถุยื่นออกนอก Stack
            children: [
              // Container สำหรับภาพพื้นหลัง
              Container(
                width: MediaQuery.of(context).size.width,
                height: 500, // ความสูงของ container
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 0, 0, 1),
                      Color.fromRGBO(50, 0, 0, 0.8)
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
                    // color: Colors.green,
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
                top: 70, // ระยะห่างจากด้านบน
                right: 30, // ระยะห่างจากด้านขวา
                child: Container(
                  width: 40, // ขนาดของวงกลม
                  height: 40, // ขนาดของวงกลม
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // ทำให้ container เป็นวงกลม
                    image: DecorationImage(
                        image: AssetImage(isLogin 
                            ? 'assets/images/user.png'
                            : 'assets/images/profile.png'),
                    fit: BoxFit.cover, // ทำให้รูปภาพครอบคลุมพื้นที่วงกลม
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
              // Positioned สำหรับข้อความ "Hi, Goodmorning"
              const Positioned(
                top: 160, // ระยะห่างจากด้านบน
                left: 20, // ระยะห่างจากด้านซ้าย
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

              // Positioned สำหรับข้อความเพิ่มเติม
              const Positioned(
                top: 210, // ระยะห่างจากด้านบน
                left: 20, // ระยะห่างจากด้านซ้าย
                child: Text(
                  'Welcome to your day!',
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

              // Positioned สำหรับ ListView ที่ยื่นออกมา
              Positioned(
                top: 300, // ระยะห่างจากด้านบน
                left: 0, // ระยะห่างจากด้านซ้าย
                right: 0, // ระยะห่างจากด้านขวา
                child: SizedBox(
                  height: 230, // กำหนดความสูงของ ListView
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return MyCard(
                          item: items[index]); // ส่งข้อมูล Item ไปที่ MyCard
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
              height: 100,
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              // color: Colors.amber,
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.stadium_rounded,
                              size: 30,
                            )),
                        Text(
                          'Match Day',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.people_alt,
                              size: 30,
                            )),
                        Text(
                          'Community',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.newspaper,
                              size: 30,
                            )),
                        Text(
                          'News',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    Column(
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
                  ]))
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
          height: 210, // กำหนดความสูงให้ชัดเจน
          margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(item.imagePath),
              fit: BoxFit.cover, // ทำให้รูปภาพครอบคลุมพื้นที่ทั้งหมด
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
                    // ชื่อสินค้า
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Color.fromARGB(255, 59, 59, 59), // สีขอบ
                            offset: Offset(1.0, 1.0), // กำหนดทิศทางของเงา (ขอบ)
                            blurRadius: 3.0, // ขนาดของขอบ
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
                            color: Color.fromARGB(255, 59, 59, 59), // สีขอบ
                            offset: Offset(1.0, 1.0), // กำหนดทิศทางของเงา (ขอบ)
                            blurRadius: 3.0, // ขนาดของขอบ
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
