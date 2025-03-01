import 'package:cloud_firestore/cloud_firestore.dart';

class TeamsApi {
  final CollectionReference team = FirebaseFirestore.instance.collection('teams');

  Stream<QuerySnapshot> getAllTeamsStream() {
    return team.orderBy('team_id', descending: false).snapshots();
  }

  Future<void> addTeam({required String teamName, required String teamImage}) async {
    // Automatically generate a unique ID for the team
    await team.add({
      'team_name': teamName,
      'team_image': teamImage,
      'team_id': team.doc().id, // Generate unique ID
    });
  }
}