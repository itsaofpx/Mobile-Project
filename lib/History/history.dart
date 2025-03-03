import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:layout/api/teams/ticket.dart'; // นำเข้าคลาส TicketsApi

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  final TicketsApi ticketsApi = TicketsApi(); // สร้าง instance ของ TicketsApi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF091442),
                Color(0xFF3562A6),
              ],
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'HISTORY',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        
      ),
      body: FutureBuilder<Stream<QuerySnapshot>>(
        future: ticketsApi.getTicketsStreambyEmail(),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // แสดง Loading ขณะรอข้อมูล
            );
          }

          if (futureSnapshot.hasError) {
            return const Center(
              child: Text('Error loading tickets stream.'),
            );
          }

          if (!futureSnapshot.hasData) {
            return const Center(
              child: Text('No booking history available.'),
            );
          }

          final stream = futureSnapshot.data!; // ดึง Stream จาก FutureBuilder

          return StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(), // แสดง Loading ขณะรอข้อมูล
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error loading tickets.'),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No booking history available.'),
                );
              }

              final tickets = snapshot.data!.docs; // ดึงข้อมูลตั๋วจาก Firestore

              return ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ticket['ticket_title'] ?? 'Unknown Title',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Zone: ${ticket['ticket_zone'] ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                'Date: ${ticket['ticket_date'] ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Stadium: ${ticket['ticket_stadium'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Time: ${ticket['ticket_time'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ticket ID: ${ticket['ticket_id'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'User Email: ${ticket['ticket_useremail'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}