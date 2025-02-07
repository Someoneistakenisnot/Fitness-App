import 'package:flutter/material.dart'; // Flutter material design package
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package for database operations
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication package
import '../models/bmi.dart'; // BMI data model
import '../utilities/api_calls.dart'; // API calls utility
import '../utilities/firebase_calls.dart'; // Firebase operations utility
import '../widgets/navigation_bar.dart'; // Custom navigation bar widget

/// Home screen displaying fitness dashboard
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiCalls apiCalls = ApiCalls(); // Instance for API operations
  String? _activityLevel; // Stores user's activity level

  @override
  void initState() {
    super.initState();
    _loadActivityLevel(); // Load activity level when screen initializes
  }

  /// Fetches user's activity level from Firestore
  Future<void> _loadActivityLevel() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('fitnessUsers')
        .where('userid', isEqualTo: user.uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var data = snapshot.docs.first.data() as Map<String, dynamic>;
      String exercise = data['exercise'];
      setState(() {
        // Format exercise level for display
        _activityLevel = exercise == 'veryheavy' ? 'very heavy' : exercise;
      });
    }
  }

  /// Returns BMI category based on BMI value
  String _getBMIRange(double bmi) {
    if (bmi < 18.5) return 'Underweight: <18.5';
    if (bmi < 25) return 'Normal: 18.5 - 24.9';
    if (bmi < 30) return 'Overweight: 25 - 29.9';
    return 'Obese: ≥30';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background color for the screen
      appBar: AppBar(
        title: const Text(
          'Fitness Dashboard', // Screen title
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0, // No shadow
        backgroundColor: Colors.teal, // App bar color
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              auth.signOut(); // Sign out user
              Navigator.pushReplacementNamed(context, '/'); // Navigate to root
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(), // Header section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildHealthMetrics(), // Main content area
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/chatbot'), // Open chatbot
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Circular button
        ),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0), // Navigation
    );
  }

  /// Builds the header section with user greeting
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${auth.currentUser?.displayName ?? 'Fitness Enthusiast'}!', // Personalized greeting
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your Daily Health Summary', // Subtitle
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the main health metrics section
  Widget _buildHealthMetrics() {
    return FutureBuilder<Bmi>(
      future: apiCalls.fetchBmi(), // Fetch BMI data from API
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Loading state
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Error state
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No health data available')); // Empty state
        }

        final bmi = snapshot.data!; // BMI data object
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildBMICard(bmi), // BMI display card
              const SizedBox(height: 16),
              _buildMetricGrid(bmi), // Metrics grid
            ],
          ),
        );
      },
    );
  }

  /// Builds the BMI display card with progress circle
  Widget _buildBMICard(Bmi bmi) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Body Mass Index', // Card title
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: bmi.bmi / 40, // BMI progress value
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getBMIColor(bmi.bmi), // Color based on BMI
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      bmi.bmi.toStringAsFixed(1), // BMI value
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      bmi.bmiConclusion, // BMI conclusion text
                      style: TextStyle(
                        color: _getBMIColor(bmi.bmi),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              _getBMIRange(bmi.bmi), // BMI range text
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the grid of health metric tiles
  Widget _buildMetricGrid(Bmi bmi) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
      crossAxisCount: 2, // 2 columns
      childAspectRatio: 1.2, // Tile aspect ratio
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMetricTile(
          title: 'Ideal Weight',
          value: '${bmi.idealBodyWt.toStringAsFixed(1)} kg',
          icon: Icons.monitor_weight,
          color: Colors.purple,
        ),
        _buildMetricTile(
          title: 'Body Fat',
          value: '${bmi.bodyFatPercent.toStringAsFixed(1)}%',
          icon: Icons.pie_chart,
          color: Colors.orange,
        ),
        _buildMetricTile(
          title: 'Daily Energy',
          value: '${bmi.totalDailyEE} kcal',
          icon: Icons.local_fire_department,
          color: Colors.red,
        ),
        _buildMetricTile(
          title: 'Activity Level',
          value: _activityLevel?.toUpperCase() ?? 'Loading...',
          icon: Icons.directions_run,
          color: Colors.green,
        ),
      ],
    );
  }

  /// Builds individual metric tile component
  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 29, color: color), // Metric icon
            const SizedBox(height: 10),
            Text(
              title, // Metric title
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value, // Metric value
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns color based on BMI value
  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue; // Underweight
    if (bmi < 25) return Colors.green; // Normal
    if (bmi < 30) return Colors.orange; // Overweight
    return Colors.red; // Obese
  }
}