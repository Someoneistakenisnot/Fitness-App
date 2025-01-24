import 'package:cloud_firestore/cloud_firestore.dart';
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: exercisesCollection
                    .where('userid', isEqualTo: auth.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data?.docs.length} Exercises',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: exercisesCollection
                    .where('userid', isEqualTo: auth.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot doc = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(
                            doc['activity'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            doc['duration'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Text(
                            doc['burnedCalories'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            // Centered Add Exercise button with padding
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: AddExerciseScreen(),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('Add Exercise'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
