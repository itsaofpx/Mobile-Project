import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String?;

    if (email != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF091442), // deeperBlue
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'My Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0E1E5B), // darkBlue
                        Color(0xFF091442), // deeperBlue
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF6594C0), // lightBlue
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 60,
                            backgroundColor: Color(0xFF3562A6), // mediumBlue
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildAccountSection(context),
              ]),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0E1E5B), // darkBlue
                Color(0xFF6594C0), // lightBlue
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3562A6).withOpacity(0.2), // mediumBlue
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Welcome Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Choose your access path",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 50),
                _buildAuthButton(
                  context,
                  text: 'Create Account',
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  isPrimary: true,
                ),
                const SizedBox(height: 20),
                _buildAuthButton(
                  context,
                  text: 'Login',
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  isPrimary: false,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildAuthButton(
    BuildContext context, {
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.white : Colors.transparent,
          foregroundColor: isPrimary ? const Color(0xFF0E1E5B) : Colors.white, // darkBlue
          side: BorderSide(color: Colors.white.withOpacity(0.7), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          elevation: isPrimary ? 8 : 0,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: isPrimary ? const Color(0xFF0E1E5B) : Colors.white, // darkBlue
          ),
        ),
      ),
    );
  }
}

Widget _buildAccountSection(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF3562A6).withOpacity(0.1), // mediumBlue
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    child: Column(
      children: [
        const SizedBox(height: 20),
        _buildAccountCard(
          icon: Icons.person_outline,
          title: 'Profile',
          onTap: () {},
        ),
        _buildAccountCard(
          icon: Icons.history,
          title: 'Booking History',
          onTap: () {},
        ),
        _buildAccountCard(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          isLogout: true,
        ),
      ],
    ),
  );
}

Widget _buildAccountCard({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  bool isLogout = false,
}) {
  return ListTile(
    leading: Icon(
      icon,
      color: isLogout ? const Color(0xFF6594C0) : Colors.white, // lightBlue for logout
      size: 28,
    ),
    title: Text(
      title,
      style: TextStyle(
        color: isLogout ? const Color(0xFF6594C0) : Colors.white, // lightBlue for logout
        fontSize: 18,
        fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
      ),
    ),
    trailing: Icon(
      Icons.chevron_right,
      color: isLogout ? const Color(0xFF6594C0) : Colors.white, // lightBlue for logout
    ),
    onTap: onTap,
  );
}
