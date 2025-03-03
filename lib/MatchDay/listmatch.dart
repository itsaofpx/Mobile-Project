import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:layout/MatchDay/matchdetail.dart';

class MatchListScreen extends StatefulWidget {
  MatchListScreen({Key? key}) : super(key: key);

  @override
  State<MatchListScreen> createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = ""; // เก็บข้อความค้นหา

  // ฟังก์ชันสำหรับกรองข้อมูล
  void searchMatches(String query) {
    setState(() {
      searchQuery = query.toLowerCase(); // อัปเดตข้อความค้นหา
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Schedule'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Box
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
          // แสดงข้อมูลจาก Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('matchday')
                      .orderBy('title', descending: false)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No matches found.'));
                }

                // กรองข้อมูลตามข้อความค้นหา
                final filteredMatches =
                    snapshot.data!.docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final title =
                          data['title']?.toString().toLowerCase() ?? '';
                      final leagueName =
                          data['leagueName']?.toString().toLowerCase() ?? '';
                      final stadiumName =
                          data['stadiumName']?.toString().toLowerCase() ?? '';
                      return title.contains(searchQuery) ||
                          leagueName.contains(searchQuery) ||
                          stadiumName.contains(searchQuery);
                    }).toList();

                return ListView.builder(
                  itemCount: filteredMatches.length,
                  itemBuilder: (context, index) {
                    final match = filteredMatches[index];
                    final data = match.data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MatchDetail(
                                      matchId: data['matchId'] ?? '',
                                      title: data['title'] ?? '',
                                      leagueName: data['leagueName'] ?? '',
                                      matchDate: data['matchDate'] ?? '',
                                      matchTime: data['matchTime'] ?? '',
                                      stadiumName: data['stadiumName'] ?? '',
                                      description: data['description'] ?? '',
                                      zoneAprice:
                                          data['zoneA_price'] != null
                                              ? int.tryParse(
                                                    data['zoneA_price']
                                                        .toString(),
                                                  ) ??
                                                  0
                                              : 0,
                                      zoneBprice:
                                          data['zoneB_price'] != null
                                              ? int.tryParse(
                                                    data['zoneB_price']
                                                        .toString(),
                                                  ) ??
                                                  0
                                              : 0,
                                      zoneCprice:
                                          data['zoneC_price'] != null
                                              ? int.tryParse(
                                                    data['zoneC_price']
                                                        .toString(),
                                                  ) ??
                                                  0
                                              : 0,
                                      zoneDprice:
                                          data['zoneD_price'] != null
                                              ? int.tryParse(
                                                    data['zoneD_price']
                                                        .toString(),
                                                  ) ??
                                                  0
                                              : 0,
                                      zoneAseate:
                                          data['zoneA_seate'] != null
                                              ? int.tryParse(
                                                    data['zoneA_seate']
                                                        .toString(),
                                                  ) ??
                                                  0
                                              : 0,
                                      zoneBseate:
                                          data['zoneB_seate'] != null
                                              ? int.tryParse(
                                                    data['zoneB_seate']
                                                        .toString(),
                                                  ) ??
                                                  0
                                              : 0,
                                      zoneCseate:
                                          data['zoneC_seate'] != null
                                              ? int.tryParse(
                                                    data['zoneC_seate']
                                                        .toString(),
                                                  ) ??
                                                  0
                                              : 0,
                                      zoneDseate:
                                          data['zoneD_seate'] != null
                                              ? int.tryParse(
                                                    data['zoneD_seate']
                                                        .toString(),
                                                  ) ??
                                                  0
                                              : 0,
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
                                  data['linkpic'] ?? '',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data['leagueName'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          27,
                                          41,
                                          97,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Match ID: ${data['matchId'] ?? ''}',
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
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
                                      data['title'] ?? '',
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
                                          data['matchDate'],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
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
                                          data['matchTime'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
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
                                          data['stadiumName'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
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
