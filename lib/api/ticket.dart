import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math'; // สำหรับการสุ่มเลข
import 'package:layout/model/user_preferences.dart';

class TicketsApi {
  final CollectionReference tickets = FirebaseFirestore.instance.collection('tickets');

  // ฟังก์ชันสำหรับสร้าง Ticket ID แบบสุ่ม
  String _generateTicketId() {
    final Random random = Random();
    return (100000 + random.nextInt(900000)).toString(); // สุ่มเลขระหว่าง 100000 ถึง 999999
  }

  // Stream สำหรับดึงข้อมูลตั๋วทั้งหมด
  Stream<QuerySnapshot> getTicketsStream() {
    return tickets.orderBy('ticket_date', descending: false).snapshots();
  }

  // ฟังก์ชันสำหรับดึงข้อมูลตั๋วตามอีเมลของผู้ใช้
  Future<Stream<QuerySnapshot>> getTicketsStreambyEmail() async {
    final userEmail = await getUserEmail(); // รอให้ getUserEmail() เสร็จสมบูรณ์
    if (userEmail == null) {
      throw Exception('User email is null'); // จัดการกรณีที่ email เป็น null
    }
    return tickets.where('ticket_useremail', isEqualTo: userEmail).snapshots();
  }

  // ฟังก์ชันสำหรับดึงอีเมลของผู้ใช้จาก UserPreferences
  Future<String?> getUserEmail() async {
    try {
      return await UserPreferences.getEmail(); // ดึง email จาก UserPreferences
    } catch (e) {
      print('Error fetching user email: $e');
      return null; // ส่งกลับ null หากเกิดข้อผิดพลาด
    }
  }

  // ฟังก์ชันสำหรับเพิ่มข้อมูลตั๋วใหม่
  Future<void> addTicket({
    required String title,
    required String zone,
    required String date,
    required String stadium,
    required String time,
  }) async {
    try {
      final userEmail = await getUserEmail(); // ดึง email ของผู้ใช้

      if (userEmail == null) {
        throw Exception('User email is null');
      }

      await tickets.add({
        'ticket_id': _generateTicketId(),
        'ticket_title': title,
        'ticket_zone': zone,
        'ticket_date': date,
        'ticket_stadium': stadium,
        'ticket_time': time,
        'ticket_useremail': userEmail, // เพิ่ม email ของผู้ใช้
      });
    } catch (e) {
      print('Error adding ticket: $e');
      rethrow; // ส่งข้อผิดพลาดกลับไปให้ผู้เรียกใช้งานจัดการ
    }
  }
}