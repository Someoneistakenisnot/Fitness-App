import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for database access
import 'package:fitness/models/exercise.dart'; // Import Exercise model
import 'package:fitness/utilities/firebase_calls.dart'; // Import Firebase utility functions
import 'package:flutter/material.dart'; // Import Flutter material design package

import '../screens/add_exercise_screen.dart'; // Import screen for adding exercises
import '../widgets/navigation_bar.dart'; // Import custom navigation bar widget

/// ExerciseScreen widget for displaying and managing exercises
class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

/// State class for managing the ExerciseScreen's state
class _ExerciseScreenState extends State<ExerciseScreen> {
  List<Exercise> exercises = []; // List to store exercises

  /// Adds a new exercise to the list
  void _addExercise(
      String newActivity, int newDuration, int newBurnedCalories) {
    setState(() {
      exercises.add(Exercise(
        activity: newActivity, // Activity name
        duration: newDuration, // Duration of the activity
        burnedCalories:
            newBurnedCalories, // Calories burned during the activity
      ));
    });
  }

  void _addExercise(
      String newActivity, int newDuration, int newBurnedCalories) {
    setState(() {
      exercises.add(Exercise(
        activity: newActivity,
        duration: newDuration,
        burnedCalories: newBurnedCalories,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(
          selectedIndexNavBar: 1), // Custom navigation bar
      body: SafeArea(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align children to the start
          children: [
            // Header displaying the number of exercises
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: exercisesCollection
                    .where('userid',
                        isEqualTo: auth.currentUser
                            ?.uid) // Filter exercises by current user ID
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data?.docs.length} Exercises', // Display count of exercises
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    );
                  } else {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Show loading indicator while fetching data
                  }
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: exercisesCollection
                    .snapshots(), // Stream to listen for exercise updates
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot
                          .data!.docs.length, // Number of exercises to display
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot doc = snapshot.data!
                            .docs[index]; // Get document for each exercise
                        return ListTile(
                          title: Text(
                            doc['activity'], // Display activity name
                            style: const TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            doc['duration']
                                .toString(), // Display duration of the activity
                            style: const TextStyle(color: Colors.black),
                          ),
                          trailing: Text(
                            doc['burnedCalories']
                                .toString(), // Display calories burned
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Show loading indicator while fetching data
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
                    // Show modal bottom sheet for adding a new exercise
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context)
                                    .viewInsets
                                    .bottom), // Adjust padding for keyboard
                            child: AddExerciseScreen(
                              addExerciseCallback:
                                  _addExercise, // Callback to add exercise
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('Add Exercise'), // Button text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
