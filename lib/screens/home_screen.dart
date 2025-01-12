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
<<<<<<< HEAD
  List<String> Bmidata = [];
  late Future<List<Bmi>> BmiFS;

  @override
  void initState() {
    super.initState();
    ApiCalls apiCalls = ApiCalls(); // Create an instance of ApiCalls
    BmiFS = apiCalls.fetchBmi(
        'https://fitness-api.p.rapidapi.com/fitness'); // Call fetchBmi
  }

=======
>>>>>>> 0a7a60136f2d78c788e6765098884e9d16dbfed2
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
        child: FutureBuilder<List<Bmi>>(
          future: BmiFS,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Bmi someBmiData = snapshot.data![index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                          'Welcome Adam'), //need to implement firebase authentication here to display user name
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Your BMI is ${someBmiData.bmi.toStringAsFixed(1)}'),
                          Text('You are ${someBmiData.bmiConclusion}'),
                          Text(
                              'Ideal body weight is ${someBmiData.idealBodyWt.toStringAsFixed(1)} kg'),
                          Text(
                              'Body Fat is ${someBmiData.bodyFatPercent.toStringAsFixed(1)}%'),
                          Text(
                              'Total Daily Energy Expenditure is ${someBmiData.totalDailyEE} kcals'),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return const CircularProgressIndicator();
          },
        ),
        //TODO widget to show show bmi, bmiConclusion, ideal body weight, body fat and daily energy expenditure
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
<<<<<<< HEAD
=======
      body: SafeArea(
        child: Column(
          children: [
            Text('Welcome ${auth.currentUser?.displayName}'),
            //TODO widget to show show bmi, bmiConclusion, ideal body weight, body fat and daily energy expenditure
          ],
        ),
      ),
>>>>>>> 0a7a60136f2d78c788e6765098884e9d16dbfed2
    );
  }
}
