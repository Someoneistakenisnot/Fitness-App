import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../utilities/api_calls.dart';
import '../utilities/firebase_calls.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key, required this.addExerciseCallback});
  final Function addExerciseCallback;

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
  String? selectedActivity;
  String? selectedDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          // Add a container to constrain the height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown for Activity
              buildDropdownField(
                label: 'Activity',
                value: selectedActivity,
                options: activities,
                onChanged: (value) {
                  setState(() {
                    selectedActivity = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Dropdown for Duration
              buildDropdownField(
                label: 'Duration (minutes)',
                value: selectedDuration,
                options: durations,
                onChanged: (value) {
                  setState(() {
                    selectedDuration = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              Center(
                child: ElevatedButton(
                  child: Text('ADD'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () async {
                    // Validate if activity and duration are selected
                    if (selectedActivity == null || selectedDuration == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Please select an activity and duration')),
                      );
                      return;
                    }

                    // Fetch burned calories from the API
                    Exercise burnedCaloriesInfo = await ApiCalls()
                        .fetchBurnedCalories(
                            selectedActivity!, int.parse(selectedDuration!));

                    // Update the exercise object with the selected activity and duration
                    Exercise exercises = Exercise(
                      activity: selectedActivity!,
                      burnedCalories: burnedCaloriesInfo.burnedCalories,
                      duration: int.parse(selectedDuration!),
                    );

                    // Save the exercise to Firestore
                    await FirebaseCalls().addExercise(exercises);

                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Exercise added successfully!')),
                    );

                    // Call the callback with the correct parameters
                    widget.addExerciseCallback(
                        selectedActivity!,
                        int.parse(selectedDuration!),
                        burnedCaloriesInfo.burnedCalories);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required TextInputType inputType,
    String? suffixText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        focusNode: focusNode,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffixText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        controller: controller,
      ),
    );
  }

  Widget buildDropdownField({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            items: options
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ),
                )
                .toList(),
            onChanged: (newValue) {
              onChanged(newValue);
            },
          ),
        ),
      ),
    );
  }
}
