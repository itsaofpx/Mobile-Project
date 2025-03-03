import 'package:cloud_firestore/cloud_firestore.dart';

class MatchdayApi {
  final CollectionReference matches = FirebaseFirestore.instance.collection('matchday');

  // Stream สำหรับดึงข้อมูล Match ทั้งหมด
  Stream<QuerySnapshot> getMatchesStream() {
    return matches.orderBy('title', descending: false).snapshots();
  }

  // ฟังก์ชันสำหรับเพิ่มข้อมูล Match ใหม่
  Future<void> addMatch({
    required String matchId,
    required String title,
    required String leagueName,
    required String matchDate,
    required String matchTime,
    required String stadiumName,
    required String description,
    required String linkpic,
    required double zoneAPrice,
    required int zoneASeate,
    required double zoneBPrice,
    required int zoneBSeate,
    required double zoneCPrice,
    required int zoneCSeate,
    required double zoneDPrice,
    required int zoneDSeate,
  }) async {
    await matches.add({
      'matchId': matchId, // ID ของ Match
      'title': title, // ชื่อ Match
      'leagueName': leagueName, // ชื่อลีก
      'matchDate': matchDate, // วันที่ของการแข่งขัน
      'matchTime': matchTime, // เวลาของการแข่งขัน
      'stadiumName': stadiumName, // ชื่อสนาม
      'description': description, // คำอธิบาย
      'linkpic': linkpic, // ลิงก์รูปภาพ
      'zoneA_price': zoneAPrice, // ราคาตั๋วโซน A
      'zoneA_seate': zoneASeate, // จำนวนที่นั่งโซน A
      'zoneB_price': zoneBPrice, // ราคาตั๋วโซน B
      'zoneB_seate': zoneBSeate, // จำนวนที่นั่งโซน B
      'zoneC_price': zoneCPrice, // ราคาตั๋วโซน C
      'zoneC_seate': zoneCSeate, // จำนวนที่นั่งโซน C
      'zoneD_price': zoneDPrice, // ราคาตั๋วโซน D
      'zoneD_seate': zoneDSeate, // จำนวนที่นั่งโซน D
    });
  }

  // ฟังก์ชันสำหรับอัปเดตจำนวนที่นั่งในโซน
Future<void> updateZoneSeats({
  required String matchId,
  required String zone,
  required int ticketCount,
}) async {
  try {
    // ค้นหา Match ที่ต้องการด้วย matchId
    QuerySnapshot querySnapshot = await matches.where('matchId', isEqualTo: matchId).get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('Match not found');
    }

    // ดึง Document ID ของ Match ที่พบ
    DocumentSnapshot matchDoc = querySnapshot.docs.first;
    String documentId = matchDoc.id;

    // ตรวจสอบว่ามีโซนที่ต้องการหรือไม่
    String zoneKey = 'zone${zone}_seate'; // เช่น 'zoneA_seate', 'zoneB_seate'
    if (!matchDoc.data().toString().contains(zoneKey)) {
      throw Exception('Zone $zone not found');
    }

    // ดึงค่าที่นั่งปัจจุบันในโซน
    int currentSeats = matchDoc[zoneKey];

    // ตรวจสอบว่าที่นั่งเพียงพอหรือไม่
    if (currentSeats < ticketCount) {
      throw Exception('Not enough seats available in $zone');
    }

    // อัปเดตจำนวนที่นั่งในโซน
    await matches.doc(documentId).update({
      zoneKey: currentSeats - ticketCount,
    });

  } catch (e) {
    throw Exception('Error updating zone seats: $e');
  }
}

  
}
