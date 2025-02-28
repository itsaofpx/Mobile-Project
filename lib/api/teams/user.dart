import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserApi {
  final CollectionReference user = FirebaseFirestore.instance.collection(
    'users',
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }

  Stream<QuerySnapshot> getUsersStream() {
    return user.orderBy("user_id", descending: false).snapshots();
  }

  Future<String> getUserRoleByUserEmail(String email) async {
    try {
      QuerySnapshot querySnapshot =
          await user
              .where("user_email", isEqualTo: email.trim())
              .limit(1)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot document = querySnapshot.docs.first;
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return data['user_role'] ?? 'user';
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error getting user role: ${e.toString()}');
    }
  }

  Future<User?> signUp(
    String email,
    String password,
    String username,
    String role,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );
      await user.add({
        'user_id': userCredential.user?.uid,
        'user_email': email,
        'user_name': username,
        'user_role': role,
        'user_password': password,
        'user_status': 'Active',
        'user_image':
            'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg',
      });
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<bool> isUserBanned(String email) async {
    QuerySnapshot querySnapshot =
        await user
            .where("user_email", isEqualTo: email.trim())
            .where("user_status", isEqualTo: "Banned")
            .limit(1)
            .get();
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
