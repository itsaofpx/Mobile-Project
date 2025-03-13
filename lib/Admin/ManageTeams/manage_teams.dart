import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:layout/api/teams.dart';

class AdminTeamsPage extends StatefulWidget {
  const AdminTeamsPage({super.key});

  @override
  State<AdminTeamsPage> createState() => _AdminTeamsPageState();
}

class _AdminTeamsPageState extends State<AdminTeamsPage> {
  final teamCollection = FirebaseFirestore.instance.collection('users');

  Map<String, dynamic> _convertDocToTeam(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return {
      'team_id': doc.id,
      'team_name': data['team_name'] ?? '',
      'team_image': data['team_image'] ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Teams"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddTeamDialog(context);
            },
          ),
        ],
      ),
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

          final teamCommunityList =
              snapshot.data!.docs.map(_convertDocToTeam).toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            itemCount: teamCommunityList.length,
            itemBuilder: (context, index) {
              var team = teamCommunityList[index];
              return AdminTeamCard(
                teamID: team['team_id'],
                teamName: team['team_name'],
                teamImage: team['team_image'],
                onTap: () {
                  _editTeam(context, team);
                },
                onRoute: () {
                  Navigator.pushNamed(
                    context,
                    '/postFeed',
                    arguments: {
                      'team_id': team['team_id'],
                      'team_name': team['team_name'],
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

void _editTeam(BuildContext context, Map<String, dynamic> team) {
  final teamDoc = FirebaseFirestore.instance
      .collection('teams')
      .doc(team['team_id']);
  final TextEditingController teamNameController = TextEditingController(
    text: team['team_name'],
  );
  final TextEditingController teamImageController = TextEditingController(
    text: team['team_image'],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Team'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: teamNameController,
              decoration: const InputDecoration(labelText: 'Team Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: teamImageController,
              decoration: const InputDecoration(labelText: 'Team Image URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final String newName = teamNameController.text.trim();
              final String newImage = teamImageController.text.trim();

              if (newName.isNotEmpty && newImage.isNotEmpty) {
                await teamDoc.update({
                  'team_name': newName,
                  'team_image': newImage,
                });
                Navigator.pop(context);

                // Show a SnackBar notification
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Team updated successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

class AdminTeamCard extends StatelessWidget {
  final String teamID;
  final String teamName;
  final String teamImage;
  final VoidCallback onTap;
  final VoidCallback onRoute;
  const AdminTeamCard({
    super.key,
    required this.teamID,
    required this.teamName,
    required this.teamImage,
    required this.onTap,
    required this.onRoute,
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
            IconButton(
              onPressed: () {
                onRoute();
              },
              icon: const Icon(Icons.comment),
            ),
            const SizedBox(width: 16),
            ElevatedButton(onPressed: onTap, child: const Icon(Icons.edit)),
          ],
        ),
      ),
    );
  }
}

void _showAddTeamDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Add New Team"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Team Name"),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: "Team Image URL"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Add team to Firestore
              await TeamsApi().addTeam(
                teamName: nameController.text,
                teamImage: imageController.text,
              );
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
}
