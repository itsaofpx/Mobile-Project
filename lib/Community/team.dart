import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:layout/api/teams.dart';
import 'package:layout/api/user.dart';
import 'package:layout/model/user_preferences.dart';

class Team extends StatefulWidget {
  const Team({super.key});
  
  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  String? userID;
  String? username;
  String? userImage;
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  Future<void> _loadUserData() async {
    try {
      final userId = await UserPreferences.getUserId();
      if (userId == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      final userApi = UserApi();
      final userName = await userApi.getNameByUserID(userId);
      const defaultImage = 'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg';
      
      setState(() {
        userID = userId;
        username = userName ?? 'User';
        userImage = defaultImage;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: const Text("Team Community"), elevation: 0),
      body: StreamBuilder<QuerySnapshot>(
        stream: TeamsApi().getAllTeamsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading teams"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No teams available"));
          }

          final teamCommunityList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            itemCount: teamCommunityList.length,
            itemBuilder: (context, index) {
              var team = teamCommunityList[index];
              return TeamCard(
                teamID: team['team_id'],
                teamName: team['team_name'],
                teamImage: team['team_image'],
                userID: userID ?? '',
                username: username ?? 'User',
                userImage: userImage ?? '',
              );
            },
          );
        },
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final String teamID;
  final String teamName;
  final String teamImage;
  final String userID;
  final String username;
  final String userImage;

  const TeamCard({
    super.key,
    required this.teamID,
    required this.teamName,
    required this.teamImage,
    required this.userID,
    required this.username,
    required this.userImage,
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
                    child: ClipOval(
                      child: Image.network(
                        teamImage,
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, size: 60);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      teamName,
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
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/postFeed',
                  arguments: {
                    'team_id': teamID,
                    'team_name': teamName,
                    'team_image': teamImage,
                    'user_id': userID,
                    'user_name': username,
                    'user_image': userImage,
                  },
                );
              },
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
