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
  // List<Exercise> exercises = [];
  //
  // void _addExercise(
  //     String newActivity, int newDuration, int newBurnedCalories) {
  //   setState(() {
  //     exercises.add(Exercise(
  //       activity: newActivity,
  //       duration: newDuration,
  //       burnedCalories: newBurnedCalories,
  //     ));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Exercise Tracker',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.grey.shade100],
          ),
        ),
        child: SafeArea(
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
                    if (snapshot.hasError)
                      return const Center(
                          child: Text('Error fetching exercises'));
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Text(
                      '${snapshot.data?.docs.length ?? 0} Exercises',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: exercisesCollection
                      .where('userid', isEqualTo: auth.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return const Center(
                          child: Text('Error fetching exercises'));
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                doc['activity']?.toString() ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal,
                                ),
                              ),
                              subtitle: Text(
                                'Duration: ${doc['duration']?.toString() ?? '0'} min',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              // trailing: Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Text(
                              //       '${doc['burnedCalories']?.toString() ?? '0'}',
                              //       style: const TextStyle(
                              //         fontSize: 20,
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.red,
                              //       ),
                              //     ),
                              //     Text(
                              //       'kcal',
                              //       style: TextStyle(
                              //         fontSize: 12,
                              //         color: Colors.grey.shade600,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // In the ListTile builder of ExerciseScreen, modify the trailing widget:
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${doc['burnedCalories']?.toString() ?? '0'}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        'kcal',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.grey.shade600),
                                    onPressed: () async {
                                      try {
                                        await FirebaseCalls()
                                            .deleteExercise(doc.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Exercise deleted successfully')),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Delete failed: ${e.toString()}')),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // onPressed: () {
                    //   showModalBottomSheet(
                    //     isScrollControlled: true,
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return SingleChildScrollView(
                    //         child: Container(
                    //           padding: EdgeInsets.only(
                    //             bottom:
                    //                 MediaQuery.of(context).viewInsets.bottom,
                    //             left: 20,
                    //             right: 20,
                    //             top: 20,
                    //           ),
                    //           child: AddExerciseScreen(
                    //               addExerciseCallback: _addExercise),
                    //         ),
                    //       );
                    //     },
                    //   );
                    // },
                    // Modify the bottom sheet implementation:
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                                left: 20,
                                right: 20,
                                top: 20,
                              ),
                              child: AddExerciseScreen(
                                addExerciseCallback:
                                    (activity, duration, calories) async {
                                  try {
                                    await FirebaseCalls().addExercise(Exercise(
                                      activity: activity,
                                      duration: duration,
                                      burnedCalories: calories,
                                    ));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Exercise added successfully')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Error adding exercise: $e')),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Add Exercise',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
