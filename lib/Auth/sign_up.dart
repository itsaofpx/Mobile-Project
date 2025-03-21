import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:layout/api/user.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final UserApi _userApi = UserApi();
  String username = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  bool _isLoading = false;

  static const Color deeperBlue = Color(0xFF091442);
  static const Color mediumBlue = Color(0xFF3562A6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: deeperBlue, size: 25),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: deeperBlue, size: 30),
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
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
            colors: [Colors.white, Color.fromARGB(255, 242, 244, 255)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: deeperBlue),
                  ),
                  const SizedBox(height: 10),
                  const Text("Sign up to get started", style: TextStyle(fontSize: 16, color: mediumBlue)),
                  const SizedBox(height: 40),
                  _buildTextField(
                    hintText: "Username",
                    icon: Icons.person,
                    onChanged: (value) => setState(() => username = value),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    hintText: "Email",
                    icon: Icons.email,
                    onChanged: (value) => setState(() => email = value),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    hintText: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                    onChanged: (value) => setState(() => password = value),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    hintText: "Confirm Password",
                    icon: Icons.lock,
                    obscureText: true,
                    onChanged: (value) => setState(() => confirmPassword = value),
                  ),
                  const SizedBox(height: 40),
                  _isLoading
                      ? const CircularProgressIndicator(color: deeperBlue)
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            backgroundColor: deeperBlue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => _handleSignUp(context),
                          child: const Text("Sign Up", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? ", style: TextStyle(color: mediumBlue)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/login'),
                        child: const Text("Log In", style: TextStyle(color: deeperBlue, fontWeight: FontWeight.bold)),
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
    );
  }

  Future<void> _handleSignUp(BuildContext context) async {
    String? validationError = _validateInputs();
    if (validationError != null) {
      _showAlert(context, "Error", validationError);
      return;
    }

    setState(() => _isLoading = true);
    try {
      User? user = await _userApi.signUp(email, password, username, "user");
      if (user != null) {
        _showSuccessSnackBar(context, "Account created successfully!");
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      _showAlert(context, "Sign Up Failed", e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

  String? _validateInputs() {
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      return "All fields are required.";
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) {
      return "Please enter a valid email.";
    }
    if (password.length < 8) {
      return "Password must be at least 8 characters.";
    }
    if (password != confirmPassword) {
      return "Passwords do not match.";
    }
    return null;
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: mediumBlue, duration: const Duration(seconds: 3)),
    );
  }

  Future<void> _showAlert(BuildContext context, String title, String message) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title, style: const TextStyle(color: deeperBlue)),
        content: Text(message, style: const TextStyle(color: mediumBlue)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("OK", style: TextStyle(color: deeperBlue))),
        ],
      ),
    );
  }
}
