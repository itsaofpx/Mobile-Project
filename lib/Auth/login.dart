import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:layout/api/teams/user.dart';
import 'package:layout/model/user_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  bool _isLoading = false;

  static const Color deeperBlue = Color(0xFF091442);
  static const Color mediumBlue = Color(0xFF3562A6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF0E1E5B),
              size: 25,
            ),
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.home, color: Color(0xFF0E1E5B), size: 30),
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 242, 244, 255),
            ],
          ),
        ),
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    const Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: deeperBlue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Sign in to continue",
                      style: TextStyle(fontSize: 16, color: mediumBlue),
                    ),
                    const SizedBox(height: 40),
                    _buildTextField(
                      hintText: "Email",
                      icon: Icons.email,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      hintText: "Password",
                      icon: Icons.lock,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    _isLoading
                        ? const CircularProgressIndicator(color: deeperBlue)
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: deeperBlue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => _handleLogin(context),
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: mediumBlue),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: deeperBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
  if (email.isEmpty || password.isEmpty) {
    _showAlert(context, "Error", "Please fill in all required fields!");
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.trim(), password: password);

    final UserApi userApi = UserApi();
    final String userRole = await userApi.getUserRoleByUserEmail(
      email.trim(),
    );

    // Check user status
    final bool isBanned = await userApi.isUserBanned(email.trim());
    if (isBanned) {
      _showAlert(context, "Access Denied", "You have been banned.");
      return; // Exit the function if the user is banned
    }

    await UserPreferences.saveUserLogin(
      email: email.trim(),
      userId: userCredential.user?.uid ?? '',
    );

    if (mounted) {
      _showSuccessSnackBar(context, "Login successful!");

      if (userRole == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  } on FirebaseAuthException catch (e) {
    String message;
    if (e.code == 'user-not-found') {
      message = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      message = 'Wrong password provided.';
    } else if (e.code == 'invalid-email') {
      message = 'The email address is not valid.';
    } else {
      message = e.message ?? 'An error occurred during login.';
    }
    _showAlert(context, "Error", message);
  } catch (e) {
    _showAlert(context, "Error", "An unexpected error occurred.");
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required ValueChanged<String> onChanged,
    bool obscureText = false,
  }) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      style: const TextStyle(color: deeperBlue),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(color: mediumBlue.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: mediumBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: mediumBlue.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: mediumBlue.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: deeperBlue, width: 2),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: mediumBlue,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _showAlert(
    BuildContext context,
    String title,
    String message,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title, style: const TextStyle(color: deeperBlue)),
          content: Text(message, style: const TextStyle(color: mediumBlue)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: deeperBlue),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
