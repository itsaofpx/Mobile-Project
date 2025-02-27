import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:layout/MatchDay/matchdetail.dart';
import 'package:layout/model/match.dart';

class MatchListScreen extends StatefulWidget {  // เปลี่ยนเป็น StatefulWidget
  MatchListScreen({Key? key}) : super(key: key);

  @override
  State<MatchListScreen> createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  
  final List<Match> matches = [
    Match(
      matchId: "M2025021501",
      title: "Manchester United vs Liverpool",
      leagueName: "Premier League",
      matchDate: "2025-02-15",
      matchTime: "20:00",
      stadiumName: "Old Trafford",
      description:
          "This is a mockup description of the match. It includes important details like the event schedule, venue, and seating options. You can choose your preferred section and book tickets accordingly.",
      linkpic: "https://i2-prod.liverpoolecho.co.uk/sport/football/football-news/article26393382.ece/ALTERNATES/s1200/2_LFCMU.jpg",
    ),
    Match(
      matchId: "M2025021502",
      title: "Arsenal vs Chelsea",
      leagueName: "Premier League",
      matchDate: "2025-02-15",
      matchTime: "22:30",
      stadiumName: "Emirates Stadium",
      description:
          "London derby between Arsenal and Chelsea. An exciting match between two of London's biggest clubs competing for supremacy in the Premier League.",
      linkpic: "https://c.files.bbci.co.uk/3F24/production/_120146161_arsenalvschelseahowtowatchpredictionsforpremierleaguelondonderbymatch.png",
    ),
    Match(
      matchId: "M2025021601",
      title: "Manchester City vs Tottenham",
      leagueName: "Premier League",
      matchDate: "2025-02-16",
      matchTime: "19:30",
      stadiumName: "Etihad Stadium",
      description:
          "Manchester City hosts Tottenham in what promises to be an action-packed Premier League encounter. Both teams known for their attacking style of play.",
      linkpic: "https://assets.khelnow.com/news/uploads/2024/01/24.01.24.10.png"
    ),
  ];

  List<Match> filteredMatches = [];  // เพิ่มตัวแปรสำหรับเก็บรายการที่กรองแล้ว
  final TextEditingController searchController = TextEditingController();  // Controller สำหรับ TextField

  @override
  void initState() {
    super.initState();
    filteredMatches = matches;  // เริ่มต้นให้แสดงทุกรายการ
  }

  // เพิ่มฟังก์ชันสำหรับค้นหา
  void searchMatches(String query) {
    setState(() {
      filteredMatches = matches.where((match) {
        final titleLower = match.title.toLowerCase();
        final leagueLower = match.leagueName.toLowerCase();
        final stadiumLower = match.stadiumName.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            leagueLower.contains(searchLower) ||
            stadiumLower.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Schedule'),
        backgroundColor: Colors.white,
      ),
      body: Column(  // เปลี่ยนจาก ListView.builder เป็น Column
        children: [
          // เพิ่ม Search Box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search matches...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: searchMatches,
            ),
          ),
          // แสดงรายการแมตช์
          Expanded(
            child: ListView.builder(
              itemCount: filteredMatches.length,
              itemBuilder: (context, index) {
                final match = filteredMatches[index];  // ใช้ filteredMatches แทน matches
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    // ... คงส่วน Card Widget เดิมไว้
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MatchDetail(
                              matchId: match.matchId,
                              title: match.title,
                              leagueName: match.leagueName,
                              matchDate: match.matchDate,
                              matchTime: match.matchTime,
                              stadiumName: match.stadiumName,
                              description: match.description,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              match.linkpic,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.error_outline),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF0E1E5B),
                                  Color(0xFF091442),
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  match.leagueName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 27, 41, 97),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Match ID: ${match.matchId}',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  match.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('EEEE, MMMM d, y')
                                          .format(DateTime.parse(match.matchDate)),
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      match.matchTime,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.stadium,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      match.stadiumName,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
