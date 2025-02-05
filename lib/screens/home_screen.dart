import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bmi.dart';
import '../utilities/api_calls.dart';
import '../utilities/firebase_calls.dart';
import '../widgets/navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiCalls apiCalls = ApiCalls();
  String? _activityLevel;

  @override
  void initState() {
    super.initState();
    _loadActivityLevel();
  }

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
        _activityLevel = exercise == 'veryheavy' ? 'very heavy' : exercise;
      });
    }
  }

  String _getBMIRange(double bmi) {
    if (bmi < 18.5) return 'Underweight: <18.5';
    if (bmi < 25) return 'Normal: 18.5 - 24.9';
    if (bmi < 30) return 'Overweight: 25 - 29.9';
    return 'Obese: ≥30';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Fitness Dashboard',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildHealthMetrics(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/chatbot'),
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Ensures circular shape
        ),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
    );
  }

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
            'Hello, ${auth.currentUser?.displayName ?? 'Fitness Enthusiast'}!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your Daily Health Summary',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetrics() {
    return FutureBuilder<Bmi>(
      future: apiCalls.fetchBmi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No health data available'));
        }

        final bmi = snapshot.data!;
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildBMICard(bmi),
              const SizedBox(height: 16),
              _buildMetricGrid(bmi),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBMICard(Bmi bmi) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Body Mass Index',
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
                    value: bmi.bmi / 40,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getBMIColor(bmi.bmi),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      bmi.bmi.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      bmi.bmiConclusion,
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
              _getBMIRange(bmi.bmi),
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

  Widget _buildMetricGrid(Bmi bmi) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.2,
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
            Icon(icon, size: 29, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
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

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }
}
