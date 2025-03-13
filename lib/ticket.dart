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
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  
  // เพิ่มตัวแปรสำหรับการกรอง
  String filterBy = 'all'; // 'all', 'title', 'date'
  List<String> uniqueTitles = [];
  String selectedTitle = '';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
      // ignore: avoid_print
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
              .where('ticket_date', isGreaterThanOrEqualTo: formattedNow)
              .orderBy('ticket_date', descending: false)
              .get();
      
      // ดึงรายการ title ที่ไม่ซ้ำกันเพื่อใช้ในตัวกรอง
      final docs = querySnapshot.docs;
      final titles = docs.map((doc) {
      final data = doc.data();
      return data['ticket_title'] as String;
      }).toSet().toList();
      
      setState(() {
        uniqueTitles = titles;
      });

      return docs;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching tickets: $e');
      return [];
    }
  }

  // แสดงตัวเลือกสำหรับกรองตาม title
  void _showTitleFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Your Match Title' ,),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: uniqueTitles.length + 1, // +1 สำหรับตัวเลือก "ทั้งหมด"
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: const Text('Show All'),
                    onTap: () {
                      setState(() {
                        selectedTitle = '';
                        filterBy = 'all';
                      });
                      Navigator.pop(context);
                    },
                  );
                }
                
                final title = uniqueTitles[index - 1];
                return ListTile(
                  title: Text(title),
                  onTap: () {
                    setState(() {
                      selectedTitle = title;
                      filterBy = 'title';
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // แสดงตัวเลือกสำหรับกรองตามวันที่
  void _showDateFilterDialog() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3562A6),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        filterBy = 'date';
      });
    }
  }

  // ล้างตัวกรองทั้งหมด
  void _clearFilters() {
    setState(() {
      filterBy = 'all';
      selectedTitle = '';
      selectedDate = null;
      searchController.clear();
      searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userEmail == null) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 70,),
                    const Text(
                      "Please Login to Book",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF091442),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "You need to be logged in to make a booking",
                      style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/account');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF091442),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("My Ticket", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              icon: const Icon(Icons.history, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // ช่องค้นหาและปุ่มฟิลเตอร์
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                // ช่องค้นหา
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Ticket...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  searchController.clear();
                                  searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                
                // ปุ่มฟิลเตอร์
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(20),                          
                          color: Colors.white,
                          child: Column(                            
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Fillter',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              
                              // กรองตามชื่อการแข่งขัน
                              ListTile(
                                leading: const Icon(Icons.sports_soccer),
                                title: const Text('By Match Title'),
                                subtitle: selectedTitle.isNotEmpty 
                                    ? Text(selectedTitle) 
                                    : null,
                                onTap: () {
                                  Navigator.pop(context);
                                  _showTitleFilterDialog();
                                },
                              ),
                              
                              // กรองตามวันที่
                              ListTile(
                                leading: const Icon(Icons.calendar_today),
                                title: const Text('By Date time'),
                                subtitle: selectedDate != null 
                                    ? Text(DateFormat('dd/MM/yyyy').format(selectedDate!)) 
                                    : null,
                                onTap: () {
                                  Navigator.pop(context);
                                  _showDateFilterDialog();
                                },
                              ),
                              
                              const SizedBox(height: 10),
                              
                              // ปุ่มล้างตัวกรอง
                              if (filterBy != 'all' || searchQuery.isNotEmpty)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _clearFilters();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[400],
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('ล้างตัวกรอง'),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          
          // แสดงตัวกรองที่ใช้อยู่
          if (filterBy != 'all' || searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (searchQuery.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          backgroundColor: Colors.white,
                          label: Text('Search: $searchQuery'),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setState(() {
                              searchController.clear();
                              searchQuery = '';
                            });
                          },
                        ),
                      ),
                    if (filterBy == 'title' && selectedTitle.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          backgroundColor: Colors.white,
                          label: Text('Match: $selectedTitle'),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setState(() {
                              selectedTitle = '';
                              filterBy = 'all';
                            });
                          },
                        ),
                      ),
                    if (filterBy == 'date' && selectedDate != null)
                      Chip(                      
                        backgroundColor: Colors.white, // หรือใช้ Colors.red.withOpacity(0
                        label: Text('Date Before: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            selectedDate = null;
                            filterBy = 'all';
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),

          // แสดงรายการตั๋ว
          Expanded(
            child: FutureBuilder<List<QueryDocumentSnapshot>>(
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
                  return Center(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),              
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "No Tickets Found",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF091442),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "You need to booking first",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF757575),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/matchlist',
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF091442),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    "Booking now",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // กรองและเรียงลำดับตั๋วตามวันที่
                final tickets = snapshot.data!;
                
                // กรองตั๋วที่มีวันที่ตั้งแต่วันนี้เป็นต้นไป และตามเงื่อนไขการกรอง
                final filteredTickets = tickets.where((ticket) {
                  final ticketData = ticket.data() as Map<String, dynamic>;
                  final ticketDateString = ticketData['ticket_date'] as String;
                  final title = ticketData['ticket_title'].toString();
                  
                  // ตรวจสอบว่าเป็นวันที่ปัจจุบันหรืออนาคต
                  if (!_isUpcomingOrToday(ticketDateString)) {
                    return false;
                  }
                  
                  // กรองตามคำค้นหา
                  if (searchQuery.isNotEmpty) {
                    final titleLower = title.toLowerCase();
                    final stadium = ticketData['ticket_stadium'].toString().toLowerCase();
                    final ticketId = ticketData['ticket_id'].toString().toLowerCase();
                    
                    if (!(titleLower.contains(searchQuery) || 
                         stadium.contains(searchQuery) || 
                         ticketId.contains(searchQuery))) {
                      return false;
                    }
                  }
                  
                  // กรองตาม title
                  if (filterBy == 'title' && selectedTitle.isNotEmpty) {
                    if (title != selectedTitle) {
                      return false;
                    }
                  }
                  
                  // กรองตามวันที่
                if (filterBy == 'date' && selectedDate != null) {
                  final ticketDate = DateFormat('yyyy-MM-dd').parse(ticketDateString);
                  final filterDate = DateTime(
                    selectedDate!.year, 
                    selectedDate!.month, 
                    selectedDate!.day
                  );
                  
                  // แก้ไขจากเดิมที่เช็คว่าเป็นวันเดียวกัน เป็นเช็คว่าวันที่ของตั๋วมาก่อนหรือเท่ากับวันที่เลือก
                  if (ticketDate.isAfter(filterDate)) {
                    return false;
                  }
                }

                  
                  return true;
                }).toList();
                
                // เรียงลำดับตั๋วตามวันที่ (ใกล้สุดอยู่บนสุด)
                filteredTickets.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;
                  
                  final aDate = DateFormat('yyyy-MM-dd').parse(aData['ticket_date']);
                  final bDate = DateFormat('yyyy-MM-dd').parse(bData['ticket_date']);
                  
                  return aDate.compareTo(bDate);
                });

                if (filteredTickets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.filter_alt_off,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          filterBy != 'all' || searchQuery.isNotEmpty
                              ? "ไม่พบตั๋วที่ตรงกับเงื่อนไขการกรอง"
                              : "ไม่มีตั๋วที่กำลังจะมาถึง",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (filterBy != 'all' || searchQuery.isNotEmpty)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text("ล้างตัวกรอง"),
                            onPressed: _clearFilters,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              foregroundColor: Colors.white,
                            ),
                          ),
                      ],
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
          ),
        ],
      ),
    );
  }
  
  // ฟังก์ชันตรวจสอบว่าวันที่เป็นวันนี้หรือวันในอนาคตหรือไม่
  bool _isUpcomingOrToday(String dateString) {
    try {
      final ticketDate = DateFormat('yyyy-MM-dd').parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      return ticketDate.isAtSameMomentAs(today) || ticketDate.isAfter(today);
    } catch (e) {
      return false;
    }
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
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
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
