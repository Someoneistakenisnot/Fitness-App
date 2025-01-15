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
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
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
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _apiCalls.debugLog.length,
                      itemBuilder: (context, index) {
                        return Text(_apiCalls.debugLog[index]);
                      },
                    );
                  }
                  return const Text('Unexpected error occurred.');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
