import 'package:flutter/material.dart';

import '../models/bmi.dart';
import '../utilities/api_calls.dart';
import '../utilities/firebase_calls.dart';
import '../widgets/navigation_bar.dart';
import '../utilities/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiCalls apiCalls = ApiCalls();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[800], // Set a light grey background for the Scaffold
      appBar: AppBar(
        title: const Text('Fitness'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildWelcomeMessage(),
            Expanded(child: _buildBmiDetails()),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
    );
  }

  Widget _buildWelcomeMessage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Welcome ${auth.currentUser?.displayName ?? 'User'}',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBmiDetails() {
    return FutureBuilder<Bmi>(
      future: apiCalls.fetchBmi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final bmi = snapshot.data!;
          return _buildBmiSummary(bmi);
        }
        return const Center(child: Text('No data available.'));
      },
    );
  }

  Widget _buildBmiSummary(Bmi bmi) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBmiInfo('Your BMI is', bmi.bmi.toStringAsFixed(1)),
          _buildBmiInfo('You are in the', '${bmi.bmiConclusion} BMI range'),
          _buildBmiInfo('Your ideal Body Weight is',
              '${bmi.idealBodyWt.toStringAsFixed(1)} Kg'),
          _buildBmiInfo(
              'You have', '${bmi.bodyFatPercent.toStringAsFixed(1)}% Body Fat'),
          _buildBmiInfo('Your Total Daily Energy Expenditure is',
              '${bmi.totalDailyEE} Kcal'),
        ],
      ),
    );
  }

  Widget _buildBmiInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$label $value',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
