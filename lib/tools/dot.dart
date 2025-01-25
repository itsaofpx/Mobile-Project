import 'package:flutter/material.dart';
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white // สีของเส้น
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double dashWidth = 4; // ความยาวของแต่ละเส้น
    double dashSpace = 10; // ระยะห่างระหว่างเส้นปะ
    double startX = 0;

    // วาดเส้นปะในแนวตั้ง โดยให้เส้นยาวตามที่ต้องการ
    // ปรับ size.height ให้ยาวขึ้นสำหรับเส้นทั้งหมด
    double lineHeight = size.height + 20;  // เพิ่มความยาวของเส้น

    while (startX < lineHeight) {
      canvas.drawLine(Offset(0, startX), Offset(0, startX + dashWidth), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
