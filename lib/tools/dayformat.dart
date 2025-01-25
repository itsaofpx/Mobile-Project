import 'package:intl/intl.dart';

List<String> splitDate(String date) {
  DateTime parsedDate = DateTime.parse(date);
  String month = DateFormat('MMMM').format(parsedDate); // ชื่อเดือน
  String day = DateFormat('d').format(parsedDate); // วันที่
  String year = DateFormat('yyyy').format(parsedDate); // ปี

  return [month, day, year];
}
