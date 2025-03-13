import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:layout/api/ticket.dart';

class AdminTicketsPage extends StatefulWidget {
  const AdminTicketsPage({super.key});

  @override
  State<AdminTicketsPage> createState() => _AdminTicketsPageState();
}

class _AdminTicketsPageState extends State<AdminTicketsPage> {
  final TicketsApi _ticketsApi = TicketsApi();
  String _searchQuery = '';
  List<Map<String, dynamic>> _allTickets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("จัดการตั๋ว"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ticketsApi.getTicketsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('ไม่พบข้อมูลตั๋ว'));
          }

          // อัปเดตข้อมูลตั๋วทั้งหมด
          _allTickets = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>? ?? {};
            return {
              'ticket_id': data['ticket_id'] ?? 'Unknown',
              'ticket_title': data['ticket_title'] ?? 'Unknown Match',
              'ticket_zone': data['ticket_zone'] ?? 'Unknown',
              'ticket_date': data['ticket_date'] ?? 'No date',
              'ticket_stadium': data['ticket_stadium'] ?? 'No stadium',
              'ticket_useremail': data['ticket_useremail'] ?? 'No email',
              'ticket_status': data['ticket_status'] ?? 'Active',
              'doc_id': doc.id,
            };
          }).toList();

          // กรองข้อมูลตามการค้นหา
          final filteredTickets = _getFilteredTickets();

          return Column(
            children: [
              _buildSearchBar(),
              _buildTicketCount(_allTickets.length),
              Expanded(child: _buildTicketList(filteredTickets)),
            ],
          );
        },
      ),
    );
  }

  // กรองข้อมูลตั๋ว
  List<Map<String, dynamic>> _getFilteredTickets() {
    if (_searchQuery.isEmpty) return _allTickets;
    
    final searchLower = _searchQuery.toLowerCase();
    return _allTickets.where((ticket) {
      return ticket['ticket_id'].toString().toLowerCase().contains(searchLower) ||
             ticket['ticket_useremail'].toString().toLowerCase().contains(searchLower) ||
             ticket['ticket_title'].toString().toLowerCase().contains(searchLower);
    }).toList();
  }

  // แถบค้นหา
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ค้นหาตั๋วหรือผู้ใช้',
          prefixIcon: const Icon(Icons.search, size: 20),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  // จำนวนตั๋วทั้งหมด
  Widget _buildTicketCount(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.confirmation_number, 
                  color: Colors.blue, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$count ตั๋ว',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // รายการตั๋ว
  Widget _buildTicketList(List<Map<String, dynamic>> tickets) {
    if (tickets.isEmpty) {
      return const Center(child: Text('ไม่พบข้อมูลตั๋ว'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tickets.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return _buildTicketTile(ticket);
      },
    );
  }

  // รายการตั๋วแต่ละรายการ
  Widget _buildTicketTile(Map<String, dynamic> ticket) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // โซนที่นั่ง
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getStatusColor(ticket['ticket_status']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                ticket['ticket_zone'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(ticket['ticket_status']),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // รายละเอียดตั๋ว
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket['ticket_title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${ticket['ticket_id']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ticket['ticket_useremail'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // สถานะตั๋ว
            _buildStatusBadge(ticket['ticket_status']),
          ],
        ),
      ),
    );
  }

  // แบดจ์สถานะ
  Widget _buildStatusBadge(String status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // สีตามสถานะ
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active': return Colors.green;
      case 'Used': return Colors.orange;
      case 'Cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }
}
