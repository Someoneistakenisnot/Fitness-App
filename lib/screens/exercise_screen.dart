import 'package:fitness/models/exercise.dart';
import 'package:fitness/utilities/firebase_calls.dart';
import 'package:flutter/material.dart';

import '../screens/add_exercise_screen.dart';
import '../widgets/navigation_bar.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  List<Exercise> exercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TODO StreamBuilder to show documents in exercises collection
            // StreamBuilder<QuerySnapshot>(
            //   stream: exercisesCollection
            //       .where('userid', isEqualTo: auth.currentUser?.uid)
            //       .snapshots(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return Text(
            //         '${snapshot.data?.docs.length} Tasks',
            //         style: const TextStyle(color: Colors.white, fontSize: 18),
            //       );
            //     } else {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //   },
            // ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: AddExerciseScreen(),
                      ),
                    );
                  },
                );
              },
              child: Text('Add Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
