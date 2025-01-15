import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/bmi.dart';
import '../utilities/api_calls.dart';
import '../widgets/navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiCalls _apiCalls = ApiCalls();
  final FirebaseAuth auth =
      FirebaseAuth.instance; // Define FirebaseAuth instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome ${auth.currentUser?.displayName ?? "User"}'),
            Expanded(
              child: FutureBuilder<Bmi>(
                future: _apiCalls.fetchBmi(),
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
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BMI: ${bmi.bmi.toStringAsFixed(1)}',
                              style: const TextStyle(fontSize: 18)),
                          Text('Conclusion: ${bmi.bmiConclusion}',
                              style: const TextStyle(fontSize: 18)),
                          Text(
                              'Ideal Body Weight: ${bmi.idealBodyWt.toStringAsFixed(1)} Kg',
                              style: const TextStyle(fontSize: 18)),
                          Text(
                              'Body Fat: ${bmi.bodyFatPercent.toStringAsFixed(1)}%',
                              style: const TextStyle(fontSize: 18)),
                          Text(
                              'Daily Energy Expenditure: ${bmi.totalDailyEE} Kcal',
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text('No data available.'));
                },
              ),
            ),
          ],
        ),
        //TODO widget to show show bmi, bmiConclusion, ideal body weight, body fat and daily energy expenditure
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
    );
  }
}
