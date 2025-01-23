import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../utilities/api_calls.dart';
import '../utilities/constants.dart';
import '../utilities/firebase_calls.dart';

class AddExerciseScreen extends StatefulWidget {
  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

List<String> activities = [
  'Aerobics',
  'Baseball',
  'Basketball',
  'Billiards',
  'Bowling',
  'Boxing',
  'Cricket',
  'Cycling',
  'Dancing',
  'Football',
  'Frisbee',
  'Golf',
  'Gymnastics',
  'Handball',
  'Hockey',
  'Lacrosse',
  'Polo',
  'Racquetball',
  'Rock climbing',
  'Rugby',
  'Running',
  'Sailing',
  'Skateboarding',
  'Skating',
  'Skiing',
  'Softball',
  'Squash',
  'Swimming',
  'Table tennis',
  'Walking',
];
List<String> durations = [
  '15',
  '30',
  '45',
  '60',
  '75',
  '90',
  '105',
  '120',
  '135',
  '150',
  '165',
  '180',
];

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  TextEditingController activityController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO TextField widgets for user to enter activity and duration (in mins).

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: kActivityTextFieldInputDecoration,
              controller: activityController,
            ),
            Autocomplete<String>(
              optionsBuilder: (value) {
                // When the field is empty
                if (value.text.isEmpty) {
                  return [];
                }
                return activities.where(
                  (item) =>
                      item.toLowerCase().contains(value.text.toLowerCase()),
                );
              },
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: kDurationTextFieldInputDecoration,
              controller: durationController,
            ),
            Autocomplete<String>(
              optionsBuilder: (value) {
                // When the field is empty
                if (value.text.isEmpty) {
                  return [];
                }
                return durations.where(
                  (item) =>
                      item.toLowerCase().contains(value.text.toLowerCase()),
                );
              },
            ),
            // TODO ElevatedButton for ApiCalls().fetchBurnedCalories() and FirebaseCalls().addExercise()
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Get the selected activity and duration from the controllers
                  String Activity = activityController.text;
                  String Duration = durationController.text;

                  // Validate if activity and duration are not empty
                  if (Activity.isEmpty || Duration.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Please select an activity and duration')),
                    );
                    return;
                  }

                  try {
                    // Fetch burned calories from the API
                    Exercise exercise = await ApiCalls().fetchBurnedCalories();

                    // Update the exercise object with the selected activity and duration
                    exercise.activity = Activity;
                    exercise.duration = int.parse(Duration);

                    // Save the exercise to Firestore
                    await FirebaseCalls().addExercise(exercise);

                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Exercise added successfully!')),
                    );
                  } catch (e) {
                    // Handle any errors that occur during the process
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add exercise: $e')),
                    );
                  }
                },
                child: Text('Add Exercise'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
