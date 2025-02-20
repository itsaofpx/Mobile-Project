import 'package:flutter/material.dart';
import 'package:layout/data/team_list.dart';

class Team extends StatelessWidget {
  const Team({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Community"),
        elevation: 0, // ลบเงาของ AppBar
      ),
      body: ListView(
        // เปลี่ยนจาก Column เป็น ListView เพื่อให้สามารถเลื่อนได้
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children:
            teamCommunityList.map((team) {
              return TeamCard(
                id: team['team_id']!,
                name: team['name']!,
                image: team['image']!,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/teamcommunity',
                    arguments: {
                      'team_id': team['team_id']!,
                      'team_name': team['name']!,
                      'team_image': team['image']!,
                    },
                  );
                },
              );
            }).toList(),
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final VoidCallback onTap;

  const TeamCard({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3142),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF091442),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 2,
              ),
              child: const Text(
                "Join",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
