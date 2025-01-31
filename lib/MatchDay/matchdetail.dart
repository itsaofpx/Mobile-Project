import 'package:flutter/material.dart';

class MatchDetail extends StatefulWidget {
  const MatchDetail({super.key});

  @override
  _MatchDetailState createState() => _MatchDetailState();
}

class _MatchDetailState extends State<MatchDetail> {
  // กำหนดตัวแปรเพื่อเก็บค่าจำนวนที่นั่ง
  int selectedSeats = 1;

  @override
  Widget build(BuildContext context) {
    // Mockup data
    String leagueName = "Premier League";
    String matchDate = "2025-02-15";
    String matchTime = "20:00";
    String stadiumName = "Old Trafford";
    String description = "This is a mockup description of the match. It includes important details like the event schedule, venue, and seating options. You can choose your preferred section and book tickets accordingly.";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Match Detail"),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // รูปภาพที่ไม่เลื่อน
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: 360,
            width: (MediaQuery.of(context).size.width) - 30,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/staduim/S2.png'),
                fit: BoxFit.scaleDown, // ทำให้รูปภาพครอบคลุมพื้นที่ทั้งหมด
              ),
            ),
          ),

          // คำอธิบายของแมตช์ (Description)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 226, 226, 226), width: 1), // เส้นขอบ
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 195, 195, 195),
                    blurRadius: 20,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leagueName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Date: $matchDate",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Time: $matchTime",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Stadium: $stadiumName",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Description: $description",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),

          // ListView สำหรับเลือกโซนตั๋ว
          _buildTicketContainer(context, "Section Zone A", 1000),
          _buildTicketContainer(context, "Section Zone B", 800),
          _buildTicketContainer(context, "Section Zone C", 600),
          _buildTicketContainer(context, "Section Zone D", 500),
        ],
      ),
    );
  }

  Widget _buildTicketContainer(BuildContext context, String zone, int price) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 211, 211, 211),
            blurRadius: 8,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ส่วนของข้อมูลโซนและราคา
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                zone,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Price: ฿$price",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          // ใช้ Row เพื่อจัดวาง Dropdown และปุ่ม Book Now
          Row(
            children: [
              // Dropdown สำหรับเลือกจำนวนที่นั่ง
              DropdownButton<int>(
                value: selectedSeats,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedSeats = newValue!;
                  });
                },
                items: List.generate(
                  10,
                  (index) => DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text((index + 1).toString()),
                  ),
                ),
                
                underline: const SizedBox(),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ticket for $zone with $selectedSeats seat(s) booked!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
