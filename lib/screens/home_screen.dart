import 'package:flutter/material.dart';
import '../utilities/firebase_calls.dart';
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
      // body: SafeArea(
      //   child: FutureBuilder<List<Bmi>>(future: fetchBmi(), builder: (context)),
      //   //TO DO widget to show show bmi, bmiConclusion, ideal body weight, body fat and daily energy expenditure
      // ),
    );
  }
}
