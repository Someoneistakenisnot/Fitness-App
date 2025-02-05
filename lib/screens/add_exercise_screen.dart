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
            // Activity Input
            _buildAutocompleteTextField(
              label: 'Activity',
              controller: activityController,
              options: activities,
              onSelected: (String selection) {
                setState(() => selectedActivity = selection);
              },
            ),
            const SizedBox(height: 16),

            // Duration Input
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
                  if (selectedActivity == null || selectedDuration == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Please select an activity and duration'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Exercise burnedCaloriesInfo = await ApiCalls()
                      .fetchBurnedCalories(
                          selectedActivity!, int.parse(selectedDuration!));

                  Exercise exercises = Exercise(
                    activity: selectedActivity!,
                    burnedCalories: burnedCaloriesInfo.burnedCalories,
                    duration: int.parse(selectedDuration!),
                  );

                  await FirebaseCalls().addExercise(exercises);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Exercise added successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );

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
    );
  }

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
          return options.where((String option) {
            return option
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
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
        style: const TextStyle(color: Colors.black), // Text color
        decoration: InputDecoration(
          filled: true, // Enable fill
          fillColor: Colors.white, // Background color
          labelText: label,
          labelStyle: TextStyle(color: Colors.teal[800]), // Label color
          suffixText: suffixText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.teal, width: 2.0),
          ),
          contentPadding: const EdgeInsets.all(16), // Add padding
        ),
        controller: controller,
      ),
    );
  }
}
