import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();
      setState(() {
        userDetails = doc.data();
      });
    } catch (e) {
      print('Failed to fetch user details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.purple.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo and Tagline
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/appLogo.png',
                        height: 100, // Larger logo
                        width: 100,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Stock Genius",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Your one-stop stock tracking app",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Greeting Section
                Text(
                  "Hello, ${userDetails?['username'] ?? user?.email ?? 'User'}!",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "What would you like to explore today?",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 30),
                // Navigation Cards Section
                Expanded(
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    children: [
                      _buildNavigationCard(
                        title: "Newsfeed",
                        icon: Icons.article_outlined,
                        color: Colors.blueAccent,
                        onTap: () => Navigator.pushNamed(context, '/newsfeed'),
                      ),
                      _buildNavigationCard(
                        title: "Watchlist",
                        icon: Icons.favorite_outline,
                        color: Colors.greenAccent,
                        onTap: () => Navigator.pushNamed(context, '/watchlist'),
                      ),
                      _buildNavigationCard(
                        title: "Stock Details",
                        icon: Icons.bar_chart_outlined,
                        color: Colors.orangeAccent,
                        onTap: () =>
                            Navigator.pushNamed(context, '/stock_details'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // View User Details Section
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: () => _showProfileDetails(context),
              child: const Row(
                children: [
                  Icon(Icons.person_outline, color: Colors.white, size: 40),
                  SizedBox(width: 10),
                  Text(
                    "View User Details",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, '/');
        },
      ),
    );
  }

  Widget _buildNavigationCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade300, Colors.teal.shade700],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Profile Details",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const Divider(color: Colors.white54),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.white),
                  title: const Text('Email',
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(userDetails?['email'] ?? "N/A",
                      style: const TextStyle(color: Colors.white70)),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text('Username',
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(userDetails?['username'] ?? "N/A",
                      style: const TextStyle(color: Colors.white70)),
                ),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.white),
                  title: const Text('Phone',
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(userDetails?['phone'] ?? "N/A",
                      style: const TextStyle(color: Colors.white70)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                      const Text("Close", style: TextStyle(color: Colors.teal)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
