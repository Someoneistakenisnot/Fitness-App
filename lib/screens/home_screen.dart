import 'package:flutter/material.dart';

import '../utilities/firebase_calls.dart';
// import '../utilities/api_calls.dart';
import '../widgets/navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> Bmidata = [];

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
            Text('Welcome back, ${auth.currentUser?.displayName}.'),
            Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            ListView.builder(
              itemCount: Bmidata.length,
              itemBuilder: (context, index) {
                // FutureBuilder<Bmi>(
                //   future: fetchBmi(Bmidata),
                //   builder: (context, snapshot) {
                //
                //   }
                // ),
              },
            ),
            //TODO widget to show show bmi, bmiConclusion, ideal body weight, body fat and daily energy expenditure
          ],
        ),
      ),
    );
  }
}
