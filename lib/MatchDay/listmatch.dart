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
  String filterLeague = "All"; // ตัวกรองลีก

  // ฟังก์ชันสำหรับกรองข้อมูล
  void searchMatches(String query) {
    setState(() {
      searchQuery = query.toLowerCase(); // อัปเดตข้อความค้นหา
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        // ส่วนหัวที่จะเลื่อนขึ้นไปเมื่อเลื่อนลง
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text('Match Schedule'),
              backgroundColor: Colors.white,
              pinned: true, // ทำให้ AppBar ติดอยู่ด้านบนเสมอ
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        // เนื้อหาหลักที่สามารถเลื่อนได้
        body: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              // Search Box
              SliverToBoxAdapter(
                child: Padding(
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
              ),

              // Filter Row - เหลือเฉพาะ League filter
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildFilterDropdown(
                    label: 'League',
                    value: filterLeague,
                    items: ['All', 'Thai League', 'FA Cup', 'Premier League', 'UEFA Champions league'],
                    onChanged: (value) {
                      setState(() {
                        filterLeague = value!;
                      });
                    },
                  ),
                ),
              ),

              // Match Stats
              SliverToBoxAdapter(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('matchday').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final totalMatches = snapshot.data!.docs.length;
                    
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E1E5B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF0E1E5B).withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.sports_soccer, color: Color(0xFF0E1E5B)),
                            const SizedBox(width: 8),
                            Text(
                              'Total Matches: $totalMatches',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0E1E5B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // แสดงข้อมูลจาก Firestore
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('matchday')
                    .orderBy('title', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('No matches found.')),
                    );
                  }

                  // กรองข้อมูลตามข้อความค้นหาและตัวกรอง
                  final filteredMatches = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final title = data['title']?.toString().toLowerCase() ?? '';
                    final leagueName = data['leagueName']?.toString().toLowerCase() ?? '';
                    final stadiumName = data['stadiumName']?.toString().toLowerCase() ?? '';
                    
                    // กรองตามข้อความค้นหา
                    final matchesSearchQuery = 
                        title.contains(searchQuery) ||
                        leagueName.contains(searchQuery) ||
                        stadiumName.contains(searchQuery);
                    
                    // กรองตามลีก
                    final matchesLeagueFilter = 
                        filterLeague == 'All' || 
                        data['leagueName'] == filterLeague;
                    
                    return matchesSearchQuery && matchesLeagueFilter;
                  }).toList();

                  if (filteredMatches.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('No matches found with current filters.')),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
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
                                    builder: (context) => MatchDetail(
                                      matchId: data['matchId'] ?? '',
                                      title: data['title'] ?? '',
                                      leagueName: data['leagueName'] ?? '',
                                      matchDate: data['matchDate'] ?? '',
                                      matchTime: data['matchTime'] ?? '',
                                      stadiumName: data['stadiumName'] ?? '',
                                      description: data['description'] ?? '',
                                      zoneAprice: data['zoneA_price'] != null
                                          ? int.tryParse(data['zoneA_price'].toString(),) ?? 0
                                          : 0,
                                      zoneBprice: data['zoneB_price'] != null
                                          ? int.tryParse(data['zoneB_price'].toString(),) ?? 0
                                          : 0,
                                      zoneCprice: data['zoneC_price'] != null
                                          ? int.tryParse(data['zoneC_price'].toString(),) ?? 0
                                          : 0,
                                      zoneDprice: data['zoneD_price'] != null
                                          ? int.tryParse(data['zoneD_price'].toString(),) ?? 0
                                          : 0,
                                      zoneAseate: data['zoneA_seate'] != null
                                          ? int.tryParse(data['zoneA_seate'].toString(),) ?? 0
                                          : 0,
                                      zoneBseate: data['zoneB_seate'] != null
                                          ? int.tryParse(data['zoneB_seate'].toString(),) ?? 0
                                          : 0,
                                      zoneCseate: data['zoneC_seate'] != null
                                          ? int.tryParse(data['zoneC_seate'].toString(),) ?? 0
                                          : 0,
                                      zoneDseate: data['zoneD_seate'] != null
                                          ? int.tryParse(data['zoneD_seate'].toString(),) ?? 0
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data['leagueName'] ?? '',
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
                                            'Match ID: ${data['matchId'] ?? ''}',
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
                                              data['matchDate'] ?? '',
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
                      childCount: filteredMatches.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget สำหรับสร้าง Dropdown Filter
  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(label),
          icon: const Icon(Icons.arrow_drop_down),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
