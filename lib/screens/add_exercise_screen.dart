import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../utilities/api_calls.dart';
import '../utilities/firebase_calls.dart';

/// Screen for adding exercise data
class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key, required this.addExerciseCallback});
  final Function
      addExerciseCallback; // Callback function to update exercise list

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

// List of available activities for the user to select
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

// List of available durations for the user to select
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
  String? selectedActivity; // Variable to store selected activity
  String? selectedDuration; // Variable to store selected duration
  bool isLoading = false; // Prevents multiple submissions

  final TextEditingController activityController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity Input Field
            _buildAutocompleteTextField(
              label: 'Activity',
              controller: activityController,
              options: activities,
              onSelected: (String selection) {
                setState(() => selectedActivity = selection);
              },
            ),
            const SizedBox(height: 16),
            // Duration Input Field
            _buildAutocompleteTextField(
              label: 'Duration (minutes)',
              controller: durationController,
              options: durations,
              onSelected: (String selection) {
                setState(() => selectedDuration = selection);
              },
            ),
            const SizedBox(height: 24),
            // Add Button
            Center(
              child: ElevatedButton(
                child: const Text('ADD'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                onPressed: () async {
                  // Immediately prevent duplicate taps.
                  if (isLoading) return;
                  isLoading = true;
                  setState(() {});

                  if (selectedActivity == null || selectedDuration == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select an activity and duration'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    isLoading = false;
                    setState(() {});
                    return;
                  }

                  try {
                    // Fetch the burned calories from your API.
                    final burnedCaloriesInfo =
                        await ApiCalls().fetchBurnedCalories(
                      selectedActivity!,
                      int.parse(selectedDuration!),
                    );

                    // Optionally, create a unique ID for your exercise.
                    // (Make sure your Exercise model and FirebaseCalls.addExercise support it.)
                    final String exerciseId =
                        '${selectedActivity!}_${selectedDuration!}_${DateTime.now().millisecondsSinceEpoch}';

                    final exercise = Exercise(
                      activity: selectedActivity!,
                      burnedCalories: burnedCaloriesInfo.burnedCalories,
                      duration: int.parse(selectedDuration!),
                    );

                    // Write to Firebase.
                    await FirebaseCalls().addExercise(exercise);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Exercise added successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pop(context);
                    // Remove the manual callback so the Firebase stream isn’t duplicated.
                    // widget.addExerciseCallback(...);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    if (mounted) {
                      isLoading = false;
                      setState(() {});
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an autocomplete text field for selecting activities or durations.
  Widget _buildAutocompleteTextField({
    required String label,
    required TextEditingController controller,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return options.where((String option) => option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase()));
        },
        onSelected: onSelected,
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return _buildTextField(
            label: label,
            controller: textEditingController,
            focusNode: focusNode,
            inputType: TextInputType.text,
          );
        },
      ),
    );
  }

  /// Builds a standard text field.
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required TextInputType inputType,
    String? suffixText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        focusNode: focusNode,
        keyboardType: inputType,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          labelStyle: TextStyle(color: Colors.teal[800]),
          suffixText: suffixText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.teal, width: 2.0),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
        controller: controller,
      ),
    );
  }
}
