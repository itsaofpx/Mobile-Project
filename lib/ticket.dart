import 'package:flutter/material.dart';
import 'model/ticket_model.dart';
import 'tools/dot.dart';
import 'tools/dayformat.dart';


class Ticket extends StatelessWidget {
  const Ticket({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("My Ticket"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return TicketCard(ticket: tickets[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final TicketInfo ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
      List<String> dateList = splitDate(ticket.date);  // เรียกใช้ฟังก์ชัน splitDate
      String month = dateList[0];  // "January"
      String day = dateList[1];    // "25"
      String year = dateList[2];   // "2025"

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Row(
        children: [
          // Left Section
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4285F4), Color.fromARGB(255, 28, 70, 160)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${ticket.city} - ${ticket.country}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Time: ${ticket.time}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Seat: ${ticket.seat}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Stadium: ${ticket.stadium}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Booking ID: ${ticket.ticketId}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stack to position the Circle and QR Code
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Right Section - QR Code Container
              Container(
                width: 100, // Size of the QR Code Container
                height: 100, // Size of the QR Code Container
                decoration: const BoxDecoration(
                  // image: DecorationImage(
                  //   image: AssetImage('assets/images/1.png'),
                  //   fit: BoxFit.cover,
                  // ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(month,style: const TextStyle(fontWeight: FontWeight.bold,)),
                      Text(day,style: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 0, 68, 204))),
                      Text(year,style: const TextStyle(fontWeight: FontWeight.bold,)),
                    ],
                  ),
                ),
              ),
              // White Circle in the middle
              Positioned(
                left: -8,
                top: -35,
                child: Container(
                  width: 17, // Size of the circle
                  height: 17, // Size of the circle
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: -8,
                top: 120,
                child: Container(
                  width: 17, // Size of the circle
                  height: 17, // Size of the circle
                  decoration: const BoxDecoration(
                    color:Color.fromARGB(255, 255, 255, 255),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Dotted Vertical Line
              Positioned(
                left: 1, // Center position horizontally in the container
                top: -18,
                bottom: 0,
                child: CustomPaint(
                  size: const Size(2, 100), // Width of line, height as the container's height
                  painter: DottedLinePainter(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

