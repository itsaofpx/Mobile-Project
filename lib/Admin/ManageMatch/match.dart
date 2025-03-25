import 'package:flutter/material.dart';
import 'package:layout/api/matchday.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMatchScreen extends StatefulWidget {
  const AddMatchScreen({Key? key}) : super(key: key);

  @override
  State<AddMatchScreen> createState() => _AddMatchScreenState();
}

class _AddMatchScreenState extends State<AddMatchScreen> {
  final MatchdayApi api = MatchdayApi();
  final _formKey = GlobalKey<FormState>();

  // สีหลักของแอป
  final Color primaryColor = const Color(0xFF0A2463);
  final Color backgroundColor = Colors.white;
  final Color textColor = const Color(0xFF0A2463);

  // Controllers สำหรับฟิลด์ต่างๆ
  final TextEditingController matchIdController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController leagueNameController = TextEditingController();
  final TextEditingController matchDateController = TextEditingController();
  final TextEditingController matchTimeController = TextEditingController();
  final TextEditingController stadiumNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkpicController = TextEditingController();

  // ราคาและที่นั่งของแต่ละโซน
  double zoneAPrice = 500;
  int zoneASeats = 100;
  double zoneBPrice = 300;
  int zoneBSeats = 200;
  double zoneCPrice = 200;
  int zoneCSeats = 300;
  double zoneDPrice = 100;
  int zoneDSeats = 400;

  // ข้อมูลสำหรับ Dropdown
  String? selectedLeague;
  String? selectedStadium;
  List<String> leagues = ['Thai League', 'Premier League', 'La Liga', 'Serie A', 'Bundesliga'];
  List<String> stadiums = []; // เปลี่ยนเป็นรายการว่าง เพราะจะดึงข้อมูลจาก Firestore

  // ราคาที่สามารถเลือกได้
  List<double> availablePrices = [
    100, 200, 300, 400, 500, 600, 700, 800, 900, 1000,
    1200, 1500, 1800, 2000, 2500, 3000, 4000, 5000
  ];

  // จำนวนที่นั่งที่สามารถเลือกได้
  List<int> availableSeats = [
    50, 100, 150, 200, 250, 300, 400, 500, 600, 700, 800, 900, 1000,
    1200, 1500, 2000, 2500, 3000, 4000, 5000
  ];

  @override
  void initState() {
    super.initState();
    // เรียกฟังก์ชันเพื่อดึงข้อมูลสนามเมื่อหน้าจอถูกสร้าง
    _fetchStadiums();
  }

  // ฟังก์ชันสำหรับดึงข้อมูลสนามจาก Firestore
  Future<void> _fetchStadiums() async {
    try {
      // ดึงข้อมูลสนามจาก Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('stadiums')
          .get();
      
      // แปลงข้อมูลที่ได้เป็นรายการชื่อสนาม
      final List<String> fetchedStadiums = snapshot.docs
          .map((doc) => doc['stadium_name'] as String)
          .toList();
      
      // อัปเดตรายการสนามใน state
      setState(() {
        stadiums = fetchedStadiums;
      });
    } catch (e) {
      print('Error fetching stadiums: $e');
      // แสดง SnackBar เมื่อเกิดข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่สามารถดึงข้อมูลสนามได้: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        matchDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        matchTimeController.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> addMatch() async {
    if (_formKey.currentState!.validate()) {
      try {
        await api.addMatch(
          title: titleController.text,
          leagueName: selectedLeague ?? leagueNameController.text,
          matchDate: matchDateController.text,
          matchTime: matchTimeController.text,
          stadiumName: selectedStadium ?? stadiumNameController.text,
          description: descriptionController.text,
          linkpic: linkpicController.text,
          zoneAPrice: zoneAPrice,
          zoneASeate: zoneASeats,
          zoneBPrice: zoneBPrice,
          zoneBSeate: zoneBSeats,
          zoneCPrice: zoneCPrice,
          zoneCSeate: zoneCSeats,
          zoneDPrice: zoneDPrice,
          zoneDSeate: zoneDSeats,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('เพิ่มการแข่งขันสำเร็จ'),
            backgroundColor: primaryColor,
          ),
        );
        Navigator.pop(context); // กลับไปหน้าก่อนหน้า
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ข้อผิดพลาด: $e'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    }
  }

  // สร้าง InputDecoration แบบมินิมอล
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      fillColor: Colors.white,
      filled: true,
    );
  }

  // สร้าง DropdownButtonFormField แบบมินิมอล
  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: _buildInputDecoration(label),
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      icon: Icon(Icons.arrow_drop_down, color: primaryColor),
      dropdownColor: Colors.white,
      style: TextStyle(color: textColor),
      isExpanded: true, // ป้องกัน overflow
    );
  }

  // สร้าง Widget สำหรับ Dropdown ที่ดึงข้อมูลจาก Firestore
  Widget _buildStadiumDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('stadiums')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return DropdownButtonFormField<String>(
            decoration: _buildInputDecoration('กำลังโหลดข้อมูลสนาม...'),
            items: [],
            onChanged: null,
          );
        }

        // สร้างรายการสนามจากข้อมูลที่ได้จาก Firestore
        final List<String> stadiumList = snapshot.data!.docs
            .map((doc) => doc['stadium_name'] as String)
            .toList();

        return DropdownButtonFormField<String>(
          decoration: _buildInputDecoration('สนาม'),
          value: selectedStadium,
          items: stadiumList.map((String stadium) {
            return DropdownMenuItem<String>(
              value: stadium,
              child: Text(stadium),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedStadium = newValue;
              stadiumNameController.text = newValue ?? '';
            });
          },
          icon: Icon(Icons.arrow_drop_down, color: primaryColor),
          dropdownColor: Colors.white,
          style: TextStyle(color: textColor),
          isExpanded: true,
        );
      },
    );
  }

  // สร้าง TextFormField แบบมินิมอล
  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false, Widget? suffixIcon, bool readOnly = false, int maxLines = 1, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: _buildInputDecoration(label).copyWith(
        suffixIcon: suffixIcon,
      ),
      style: TextStyle(color: textColor),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      readOnly: readOnly,
      maxLines: maxLines,
      validator: validator ?? (value) => value!.isEmpty ? 'กรุณากรอกข้อมูล' : null,
    );
  }

  // สร้าง Section Header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            color: primaryColor,
            margin: const EdgeInsets.only(right: 8),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  // สร้าง Widget สำหรับเลือกราคาและจำนวนที่นั่ง
  Widget _buildPriceAndSeatsSelector(String zoneLabel, double price, int seats, Function(double) onPriceChanged, Function(int) onSeatsChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'โซน $zoneLabel',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ราคา: ${price.toStringAsFixed(0)} บาท'),
                  Slider(
                    value: price,
                    min: 100,
                    max: 5000,
                    divisions: availablePrices.length - 1,
                    activeColor: primaryColor,
                    inactiveColor: primaryColor.withOpacity(0.2),
                    label: price.toStringAsFixed(0),
                    onChanged: (value) {
                      // หาราคาที่ใกล้เคียงที่สุดในรายการราคาที่มี
                      double closestPrice = availablePrices.reduce((a, b) => 
                        (a - value).abs() < (b - value).abs() ? a : b);
                      onPriceChanged(closestPrice);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('จำนวนที่นั่ง: $seats ที่'),
                  Slider(
                    value: seats.toDouble(),
                    min: 50,
                    max: 5000,
                    divisions: availableSeats.length - 1,
                    activeColor: primaryColor,
                    inactiveColor: primaryColor.withOpacity(0.2),
                    label: seats.toString(),
                    onChanged: (value) {
                      // หาจำนวนที่นั่งที่ใกล้เคียงที่สุดในรายการที่มี
                      int closestSeats = availableSeats.reduce((a, b) => 
                        (a - value.toInt()).abs() < (b - value.toInt()).abs() ? a : b);
                      onSeatsChanged(closestSeats);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('เพิ่มการแข่งขัน'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('ข้อมูลการแข่งขัน'),
                  
                  // Row 1: Title
                  _buildTextField(
                    titleController, 
                    'ชื่อการแข่งขัน',
                    validator: (value) => value!.isEmpty ? 'กรุณาใส่ชื่อการแข่งขัน' : null,
                  ),
                  const SizedBox(height: 12),
                  
                  // Row 2: League and Stadium with Dropdown
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        // หน้าจอกว้าง - แสดง 2 คอลัมน์
                        return Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                'ลีก', 
                                leagues, 
                                selectedLeague, 
                                (String? newValue) {
                                  setState(() {
                                    selectedLeague = newValue;
                                    leagueNameController.text = newValue ?? '';
                                  });
                                }
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              // เปลี่ยนจาก _buildDropdown เป็น _buildStadiumDropdown
                              child: _buildStadiumDropdown(),
                            ),
                          ],
                        );
                      } else {
                        // หน้าจอแคบ - แสดง 1 คอลัมน์
                        return Column(
                          children: [
                            _buildDropdown(
                              'ลีก', 
                              leagues, 
                              selectedLeague, 
                              (String? newValue) {
                                setState(() {
                                  selectedLeague = newValue;
                                  leagueNameController.text = newValue ?? '';
                                });
                              }
                            ),
                            const SizedBox(height: 12),
                            // เปลี่ยนจาก _buildDropdown เป็น _buildStadiumDropdown
                            _buildStadiumDropdown(),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // Row 3: Other League and Stadium (if not in dropdown)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        // หน้าจอกว้าง - แสดง 2 คอลัมน์
                        return Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                leagueNameController, 
                                'ลีกอื่นๆ (ถ้าไม่มีในรายการ)',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                stadiumNameController, 
                                'สนามอื่นๆ (ถ้าไม่มีในรายการ)',
                              ),
                            ),
                          ],
                        );
                      } else {
                        // หน้าจอแคบ - แสดง 1 คอลัมน์
                        return Column(
                          children: [
                            _buildTextField(
                              leagueNameController, 
                              'ลีกอื่นๆ (ถ้าไม่มีในรายการ)',
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              stadiumNameController, 
                              'สนามอื่นๆ (ถ้าไม่มีในรายการ)',
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // Row 4: Date and Time
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        // หน้าจอกว้าง - แสดง 2 คอลัมน์
                        return Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                matchDateController, 
                                'วันที่แข่งขัน',
                                readOnly: true,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.calendar_today, color: primaryColor),
                                  onPressed: () => _selectDate(context),
                                ),
                                validator: (value) => value!.isEmpty ? 'กรุณาเลือกวันที่แข่งขัน' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                matchTimeController, 
                                'เวลาแข่งขัน',
                                readOnly: true,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.access_time, color: primaryColor),
                                  onPressed: () => _selectTime(context),
                                ),
                                validator: (value) => value!.isEmpty ? 'กรุณาเลือกเวลาแข่งขัน' : null,
                              ),
                            ),
                          ],
                        );
                      } else {
                        // หน้าจอแคบ - แสดง 1 คอลัมน์
                        return Column(
                          children: [
                            _buildTextField(
                              matchDateController, 
                              'วันที่แข่งขัน',
                              readOnly: true,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.calendar_today, color: primaryColor),
                                onPressed: () => _selectDate(context),
                              ),
                              validator: (value) => value!.isEmpty ? 'กรุณาเลือกวันที่แข่งขัน' : null,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              matchTimeController, 
                              'เวลาแข่งขัน',
                              readOnly: true,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time, color: primaryColor),
                                onPressed: () => _selectTime(context),
                              ),
                              validator: (value) => value!.isEmpty ? 'กรุณาเลือกเวลาแข่งขัน' : null,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // Row 5: Description
                  _buildTextField(
                    descriptionController, 
                    'รายละเอียด',
                    maxLines: 3,
                    validator: (value) => value!.isEmpty ? 'กรุณาใส่รายละเอียด' : null,
                  ),
                  const SizedBox(height: 12),
                  
                  // Row 6: Link Picture
                  _buildTextField(
                    linkpicController, 
                    'ลิงก์รูปภาพ',
                    validator: (value) => value!.isEmpty ? 'กรุณาใส่ลิงก์รูปภาพ' : null,
                  ),
                  
                  _buildSectionHeader('ข้อมูลโซนที่นั่ง'),
                  
                  // Zone A
                  _buildPriceAndSeatsSelector(
                    'A', 
                    zoneAPrice, 
                    zoneASeats, 
                    (price) => setState(() => zoneAPrice = price), 
                    (seats) => setState(() => zoneASeats = seats)
                  ),
                  
                  // Zone B
                  _buildPriceAndSeatsSelector(
                    'B', 
                    zoneBPrice, 
                    zoneBSeats, 
                    (price) => setState(() => zoneBPrice = price), 
                    (seats) => setState(() => zoneBSeats = seats)
                  ),
                  
                  // Zone C
                  _buildPriceAndSeatsSelector(
                    'C', 
                    zoneCPrice, 
                    zoneCSeats, 
                    (price) => setState(() => zoneCPrice = price), 
                    (seats) => setState(() => zoneCSeats = seats)
                  ),
                  
                  // Zone D
                  _buildPriceAndSeatsSelector(
                    'D', 
                    zoneDPrice, 
                    zoneDSeats, 
                    (price) => setState(() => zoneDPrice = price), 
                    (seats) => setState(() => zoneDSeats = seats)
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: addMatch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'เพิ่มการแข่งขัน',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    matchIdController.dispose();
    titleController.dispose();
    leagueNameController.dispose();
    matchDateController.dispose();
    matchTimeController.dispose();
    stadiumNameController.dispose();
    descriptionController.dispose();
    linkpicController.dispose();
    super.dispose();
  }
}
