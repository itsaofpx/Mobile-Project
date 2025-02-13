import 'package:flutter/material.dart';
import 'package:layout/data/team_list.dart';

class Team extends StatelessWidget {
  const Team({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Team Community")),
      body: Column(
        children: teamCommunityList.map((team) {
          return TeamCard(
              id: team['team_id']!,
              name: team['name']!,
              image: team['image']!,
              onTap: () {
                Navigator.pushNamed(context, '/teamcommunity', arguments: {
                  'team_id': team['team_id']!,
                  'team_name': team['name']!,
                  'team_image': team['image']!,
                });
              });
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

  const TeamCard(
      {super.key,
      required this.id,
      required this.name,
      required this.image,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                image,
                height: 50.0,
                width: 50.0,
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 2,
            ),
            child: const Text("Join"),
          )
        ],
      ),
    );
  }
}
