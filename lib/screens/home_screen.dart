import 'package:flutter/material.dart';

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
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
      body: SafeArea(
        child: Column(
          children: [
            Text('Welcome ${auth.currentUser?.displayName}'),
            Expanded(
              child: FutureBuilder<Bmi>(
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
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your BMI is ${bmi.bmi.toStringAsFixed(1)}',
                            style: const TextStyle(
                                fontSize: 12
                            ),
                          ),
                          Text('You are in the ${bmi.bmiConclusion} BMI range',
                            style: const TextStyle(
                                fontSize: 12
                            ),
                          ),
                          Text('Your ideal Body Weight is ${bmi.idealBodyWt.toStringAsFixed(1)} Kg',
                            style: const TextStyle(
                                fontSize: 12
                            ),
                          ),
                          Text(
                            'You have ${bmi.bodyFatPercent.toStringAsFixed(1)}% Body Fat',
                            style: const TextStyle(
                                fontSize: 12
                            ),
                          ),
                          Text(
                            'Your Total Daily Energy Expenditure is ${bmi.totalDailyEE} Kcal',
                            style: const TextStyle(
                                fontSize: 12
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text('No data available.'));
                },
              ),
            ),
            //TODO widget to show show bmi, bmiConclusion, ideal body weight, body fat and daily energy expenditure
          ],
        ),
      ),
    );
  }
}
