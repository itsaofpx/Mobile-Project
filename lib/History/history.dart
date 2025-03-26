import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:layout/api/ticket.dart';
import 'package:intl/intl.dart'; // เพิ่มไลบรารีสำหรับจัดรูปแบบวันที่

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  final TicketsApi ticketsApi = TicketsApi();

  // ฟังก์ชันสำหรับจัดรูปแบบวันที่
  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final date = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        return DateFormat('dd MMM yyyy').format(date);
      }
    } catch (e) {
      // ถ้าแปลงไม่ได้ ส่งค่าเดิมกลับไป
    }
    return dateStr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Booking History", 
          style: TextStyle(
            
            
            fontSize: 22,
          )
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Stream<QuerySnapshot>>(
        future: ticketsApi.getTicketsStreambyEmail(),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF091442),
              ),
            );
          }

          if (futureSnapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'Error loading tickets',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please try again later',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          if (!futureSnapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'No booking history available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your booking history will appear here',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final stream = futureSnapshot.data!;

          return StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF091442),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      const Text(
                        'Error loading tickets',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/empty_tickets.png', // เพิ่มรูปภาพว่างเปล่า (ต้องมีไฟล์นี้)
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => 
                          Icon(Icons.confirmation_number_outlined, size: 80, color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'No Tickets Yet',
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF091442),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your booking history will appear here',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/matches'); // นำทางไปยังหน้าแมตช์ (ต้องกำหนด route)
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF091442),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text(
                          'Book Tickets Now',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final tickets = snapshot.data!.docs;

              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Color(0xFFF2F4FF),
                    ],
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    
                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // ส่วนบนของตั๋ว - ชื่อการแข่งขัน
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFF091442),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.sports_soccer,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    ticket['ticket_title'] ?? 'Unknown Match',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // เส้นประคั่นระหว่างตั๋ว
                          Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Flex(
                                  direction: Axis.horizontal,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    (constraints.constrainWidth() / 10).floor(),
                                    (index) => Container(
                                      height: 1,
                                      width: 5,
                                      color: const Color.fromARGB(255, 74, 74, 74).withOpacity(0.3),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          
                          // ข้อมูลตั๋ว
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // แถวแรก - วันที่และเวลา
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoItem(
                                        Icons.calendar_today,
                                        'Date',
                                        _formatDate(ticket['ticket_date'] ?? 'N/A'),
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildInfoItem(
                                        Icons.access_time,
                                        'Time',
                                        ticket['ticket_time'] ?? 'N/A',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // แถวที่สอง - สนามและโซน
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoItem(
                                        Icons.stadium,
                                        'Stadium',
                                        ticket['ticket_stadium'] ?? 'N/A',
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildInfoItem(
                                        Icons.chair,
                                        'Zone',
                                        ticket['ticket_zone'] ?? 'N/A',
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 8),
                                
                                // ข้อมูลตั๋ว
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Ticket ID',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          ticket['ticket_id'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  // Widget สำหรับแสดงข้อมูลแต่ละรายการ
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF091442),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
