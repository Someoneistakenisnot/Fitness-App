import 'package:flutter/material.dart'; // Flutter material design package

import '../models/exercise.dart'; // Importing Exercise model
import '../utilities/api_calls.dart'; // Importing API calls utility
import '../utilities/firebase_calls.dart'; // Importing Firebase calls utility

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
  Future? _fetchBurnedCaloriesFuture; // Track ongoing request

  final TextEditingController activityController =
      TextEditingController(); // Controller for activity input
  final TextEditingController durationController =
      TextEditingController(); // Controller for duration input

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Padding for the screen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity Input Field
            _buildAutocompleteTextField(
              label: 'Activity',
              controller: activityController,
              options: activities,
              onSelected: (String selection) {
                setState(() =>
                    selectedActivity = selection); // Update selected activity
              },
            ),
            const SizedBox(height: 16), // Space between fields

            // Duration Input Field
            _buildAutocompleteTextField(
              label: 'Duration (minutes)',
              controller: durationController,
              options: durations,
              onSelected: (String selection) {
                setState(() =>
                    selectedDuration = selection); // Update selected duration
              },
            ),
            const SizedBox(height: 24), // Space before the button

            // Add Button
            Center(
              child: ElevatedButton(
                child: const Text('ADD'), // Button text
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Button background color
                  foregroundColor: Colors.white, // Button text color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Rounded button corners
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 16), // Button padding
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                        if (selectedActivity == null ||
                            selectedDuration == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please select an activity and duration'),
                                backgroundColor: Colors.red),
                          );
                          return;
                        }

                        if (_fetchBurnedCaloriesFuture != null) {
                          return; // ✅ Prevent re-triggering the API call
                        }

                        try {
                          setState(() {
                            isLoading = true;
                            _fetchBurnedCaloriesFuture =
                                ApiCalls().fetchBurnedCalories(
                              selectedActivity!,
                              int.parse(selectedDuration!),
                            );
                          });

                          Exercise burnedCaloriesInfo =
                              await _fetchBurnedCaloriesFuture!;

                          Exercise exercise = Exercise(
                            activity: selectedActivity!,
                            burnedCalories: burnedCaloriesInfo.burnedCalories,
                            duration: int.parse(selectedDuration!),
                          );

                          await FirebaseCalls().addExercise(exercise);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Exercise added successfully!'),
                                backgroundColor: Colors.green),
                          );

                          Navigator.pop(context);

                          widget.addExerciseCallback(
                              selectedActivity!,
                              int.parse(selectedDuration!),
                              burnedCaloriesInfo.burnedCalories);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red),
                          );
                        } finally {
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                              _fetchBurnedCaloriesFuture =
                                  null; // ✅ Reset Future
                            });
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

  /// Builds an autocomplete text field for selecting activities or durations
  Widget _buildAutocompleteTextField({
    required String label,
    required TextEditingController controller,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Padding for the text field
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty(); // Return empty if no input
          }
          // Filter options based on user input
          return options.where((String option) {
            return option
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: onSelected, // Callback when an option is selected
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return _buildTextField(
            label: label,
            controller: textEditingController,
            focusNode: focusNode,
            inputType: TextInputType.text, // Text input type
          );
        },
      ),
    );
  }

  /// Builds a standard text field with specified properties
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required TextInputType inputType,
    String? suffixText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Padding for the text field
      child: TextField(
        focusNode: focusNode, // Focus node for the text field
        keyboardType: inputType, // Keyboard type for the text field
        style: const TextStyle(color: Colors.black), // Text color
        decoration: InputDecoration(
          filled: true, // Enable fill for the text field
          fillColor: Colors.white, // Background color of the text field
          labelText: label, // Label for the text field
          labelStyle: TextStyle(color: Colors.teal[800]), // Label color
          suffixText: suffixText, // Optional suffix text
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
            borderSide: const BorderSide(color: Colors.teal), // Border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(8.0), // Rounded corners when focused
            borderSide: const BorderSide(
                color: Colors.teal, width: 2.0), // Border color when focused
          ),
          contentPadding:
              const EdgeInsets.all(16), // Padding inside the text field
        ),
        controller: controller, // Controller for the text field
      ),
    );
  }
}
