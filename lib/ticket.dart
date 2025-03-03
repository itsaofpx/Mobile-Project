import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tools/dot.dart';
import 'package:layout/model/user_preferences.dart';
import 'package:intl/intl.dart';

class Ticket extends StatefulWidget {
  const Ticket({super.key});

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  String? userEmail;
  bool isLoading = true;
  Future<List<QueryDocumentSnapshot>>? ticketFuture;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    try {
      final email = await UserPreferences.getEmail();
      setState(() {
        userEmail = email;
        isLoading = false;
        if (userEmail != null) {
          ticketFuture = _fetchTickets(userEmail!);
        }
      });
    } catch (e) {
      print('Error fetching user email: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<QueryDocumentSnapshot>> _fetchTickets(String email) async {
    try {
      final now = DateTime.now();
      final formattedNow = DateFormat('yyyy-MM-dd').format(now);

      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('tickets')
              .where('ticket_useremail', isEqualTo: email)
              .where('ticket_date', isGreaterThan: formattedNow)
              .orderBy('ticket_date', descending: false)
              .get();

      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching tickets: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userEmail == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Unable to load user email.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("My Ticket", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),

      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: ticketFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading tickets.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No tickets available",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          final tickets = snapshot.data!;

          final filteredTickets =
              tickets.where((ticket) {
                final ticketDateString = ticket['ticket_date'] as String;
                try {
                  final ticketDate = DateFormat(
                    'yyyy-MM-dd',
                  ).parse(ticketDateString);

                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);

                  return (ticketDate.isAtSameMomentAs(today) ||
                      ticketDate.isAfter(today));
                } catch (e) {
                  return false;
                }
              }).toList();

          if (filteredTickets.isEmpty) {
            return const Center(
              child: Text(
                "No tickets available",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: filteredTickets.length,
            itemBuilder: (context, index) {
              final ticket = filteredTickets[index];
              return TicketCard(ticket: ticket);
            },
          );
        },
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final QueryDocumentSnapshot ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final ticketData = ticket.data() as Map<String, dynamic>;

    List<String> parts = ticketData['ticket_date'].split('-');

    String year = parts[0];
    String month = parts[1];
    String day = parts[2];

    String getMonthName(String month) {
      const List<String> months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ];

      int monthNumber = int.tryParse(month) ?? 0;

      if (monthNumber < 1 || monthNumber > 12) {
        throw RangeError("Month must be between 1 and 12.");
      }

      return months[monthNumber - 1];
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Row(
                  children: [
                    Icon(Icons.qr_code, color: Color.fromARGB(255, 18, 41, 80)),
                    SizedBox(width: 10),
                    Text(
                      "Scan QR Code",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image(
                          image: AssetImage('assets/images/qr2.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Please show this QR code at the entrance for verification.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF3562A6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text("Close", style: TextStyle(fontSize: 16)),
                  ),
                ],
              );
            },
          );
        },

        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3562A6), Color(0xFF6594C0)],
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
                      ticketData['ticket_title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Time: ${ticketData['ticket_time']}",
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    Text(
                      "Zone: ${ticketData['ticket_zone']}",
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    Text(
                      "Stadium: ${ticketData['ticket_stadium']}",
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Booking ID: ${ticketData['ticket_id']}",
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

            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getMonthName(month),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          day,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF091442),
                          ),
                        ),
                        Text(
                          year,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: -8,
                  top: -35,
                  child: Container(
                    width: 17,
                    height: 17,
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
                    width: 17,
                    height: 17,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: 1,
                  top: -18,
                  bottom: 0,
                  child: CustomPaint(
                    size: const Size(2, 100),
                    painter: DottedLinePainter(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
