import 'package:flutter/material.dart';

class PlayeroftheWeek extends StatelessWidget {
  const PlayeroftheWeek({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(bottom: 1), // เพิ่ม margin ด้านล่าง
          child: const Text(
            'Player of the Week',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          // แก้ไข margin ตรงนี้ จากเดิมที่เป็น fromLTRB(0, 30, 0, 0)
          margin: const EdgeInsets.only(top: 10), // ลดระยะห่างด้านบนลง
          height: 150,
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 210, 210, 210),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // ส่วนรูปภาพด้านซ้าย
              Container(
                width: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/ronaldo.png',
                    ), // ใส่path รูปของคุณ
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // ส่วนข้อมูลด้านขวา
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Cristiano Ronaldo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.sports_soccer, size: 13),
                          const SizedBox(width: 5),
                          Text(
                            'Real Madrid', // ชื่อทีม
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.cake, size: 13),
                          const SizedBox(width: 5),
                          Text(
                            'Age: 34', // อายุ
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF091442),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sports_soccer,
                              size: 13,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Goals: 52', // จำนวนประตู
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
          ),
        ),
        const Footer(),
      ],
    );
  }
}


class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
      child: Text(
          '© 2024 Aofuro inc. All rights reserved.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
      ),
    );
  }
}

