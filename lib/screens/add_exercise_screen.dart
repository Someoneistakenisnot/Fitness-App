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
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () async {
                  // Get the selected activity and duration from the controllers
                  String activity = activityController.text;
                  String duration = durationController.text;

                  // Validate if activity and duration are not empty
                  if (activity.isEmpty || duration.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Please select an activity and duration')),
                    );
                    return;
                  }

                  // Fetch burned calories from the API
                  Exercise burnedCaloriesInfo =
                      await ApiCalls().fetchBurnedCalories();

                  // Update the exercise object with the selected activity and duration
                  Exercise exercises = Exercise(
                    activity: activityController.text,
                    burnedCalories: burnedCaloriesInfo.burnedCalories,
                    duration: int.parse(durationController.text),
                  );

                  // Save the exercise to Firestore
                  await FirebaseCalls().addExercise(exercises);

                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Exercise added successfully!')),
                  );
                },
                child: Text('ADD'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
