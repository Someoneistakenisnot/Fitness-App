import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for database access
import 'package:flutter/material.dart'; // Import Flutter material design package

import '../models/fitness_user.dart'; // Import FitnessUser  model
import '../utilities/firebase_calls.dart'; // Import Firebase utility functions
import '../widgets/navigation_bar.dart'; // Import custom navigation bar widget

/// Screen for updating fitness user information
class UpdateFitnessUserScreen extends StatefulWidget {
  const UpdateFitnessUserScreen({Key? key}) : super(key: key);

  @override
  State<UpdateFitnessUserScreen> createState() =>
      _UpdateFitnessUserScreenState();
}

/// State class for managing the UpdateFitnessUser Screen's state
class _UpdateFitnessUserScreenState extends State<UpdateFitnessUserScreen> {
// Controllers for text fields
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

// Focus nodes for managing focus on text fields
  final FocusNode weightFocusNode = FocusNode();
  final FocusNode heightFocusNode = FocusNode();
  final FocusNode ageFocusNode = FocusNode();

// Variables for selected gender and exercise level
  String? selectedGender;
  String? selectedExerciseLevel;

// Options for gender and exercise level dropdowns
  final List<String> genderOptions = ['male', 'female'];
  final List<String> exerciseOptions = [
    'little',
    'light',
    'moderate',
    'heavy',
    'very heavy'
  ];

  bool _isInitialized = false; // Flag to check if data is initialized
  late DocumentSnapshot _initialData; // To hold initial data from Firestore

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Load initial data when the screen is initialized
  }

  /// Dispose of controllers and focus nodes to free up resources
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    weightFocusNode.dispose();
    heightFocusNode.dispose();
    ageFocusNode.dispose();
    super.dispose();
  }

  /// Load initial data from Firestore for the current user
  Future<void> _loadInitialData() async {
    final snapshot = await fitnessUsersCollection
        .where('userid',
            isEqualTo: auth.currentUser?.uid) // Filter by current user ID
        .get();

    if (snapshot.docs.isNotEmpty) {
      _initialData = snapshot.docs.first; // Get the first document
      _initializeControllers(); // Initialize text controllers with data
    }
  }

  /// Initialize text controllers with data from Firestore
  void _initializeControllers() {
    if (_isInitialized) return; // Prevent re-initialization

// Set text field values from Firestore data
    weightController.text = _initialData.get('weight').toString();
    heightController.text = _initialData.get('height').toString();
    ageController.text = _initialData.get('age').toString();
    selectedGender = _initialData.get('gender');

// Handle exercise level formatting
    final exercise = _initialData.get('exercise');
    selectedExerciseLevel = exercise == 'veryheavy' ? 'very heavy' : exercise;

    _isInitialized = true; // Mark as initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(
          selectedIndexNavBar: 2), // Custom navigation bar
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _loadInitialData(), // Load initial data
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // Show loading indicator while fetching data
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Padding for the form
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch, // Stretch children to fill the width
                  children: <Widget>[
                    const Text(
                      'Update Fitness User', // Title of the screen
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16), // Spacer
                    // Weight input field
                    _buildTextField(
                      label: 'Weight (kg)',
                      controller: weightController,
                      focusNode: weightFocusNode,
                      inputType: TextInputType.number,
                      suffixText: 'kg',
                      validator: (value) =>
                          _validatePositiveNumber(value, 'Weight'),
                    ),
                    // Height input field
                    _buildTextField(
                      label: 'Height (cm)',
                      controller: heightController,
                      focusNode: heightFocusNode,
                      inputType: TextInputType.number,
                      suffixText: 'cm',
                      validator: (value) =>
                          _validatePositiveNumber(value, 'Height'),
                    ),
                    // Gender dropdown field
                    _buildDropdownField(
                      label: 'Gender',
                      value: selectedGender,
                      options: genderOptions,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value; // Update selected gender
                        });
                      },
                    ),
                    // Age input field
                    _buildTextField(
                      label: 'Age',
                      controller: ageController,
                      focusNode: ageFocusNode,
                      inputType: TextInputType.number,
                      validator: (value) =>
                          _validatePositiveNumber(value, 'Age'),
                    ),
                    // Exercise level dropdown field
                    _buildDropdownField(
                      label: 'Exercise Level',
                      value: selectedExerciseLevel,
                      options: exerciseOptions,
                      onChanged: (value) {
                        setState(() {
                          selectedExerciseLevel =
                              value; // Update selected exercise level
                        });
                      },
                    ),
                    // Save button
                    ElevatedButton(
                      child: const Text('Save'),
                      onPressed: () async {
                        if (!_validateAllFields()) {
                          return; // Validate fields before saving
                        }

                        // Create FitnessUser  object with input data
                        FitnessUser fitnessUser = FitnessUser(
                          weight: int.parse(weightController.text),
                          height: int.parse(heightController.text),
                          gender: selectedGender!,
                          age: int.parse(ageController.text),
                          exercise: selectedExerciseLevel == 'very heavy'
                              ? 'veryheavy'
                              : selectedExerciseLevel!,
                        );

                        await FirebaseCalls().updateFitnessUser(
                            fitnessUser); // Update user data in Firestore
                        setState(() {}); // Refresh the UI
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build a text field with specified parameters
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
          vertical: 8.0), // Vertical padding for text fields
      child: TextField(
        focusNode: focusNode,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffixText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0)), // Rounded border
        ),
        controller: controller,
      ),
    );
  }

  /// Build a dropdown field with specified parameters
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Vertical padding for dropdowns
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0)), // Rounded border
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true, // Expand dropdown to fill width
            items: options
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Text(option), // Display option text
                  ),
                )
                .toList(),
            onChanged: (newValue) {
              onChanged(newValue); // Handle dropdown value change
            },
          ),
        ),
      ),
    );
  }

  /// Validate all input fields before saving
  bool _validateAllFields() {
    String? weightError =
        _validatePositiveNumber(weightController.text, 'Weight');
    String? heightError =
        _validatePositiveNumber(heightController.text, 'Height');
    String? ageError = _validatePositiveNumber(ageController.text, 'Age');

// Check for any validation errors
    if (weightError != null ||
        heightError != null ||
        ageError != null ||
        selectedGender == null ||
        selectedExerciseLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please fill in all fields correctly')), // Show error message
      );
      return false; // Validation failed
    }
    return true; // All fields are valid
  }

  /// Validate if a number is positive
  String? _validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty'; // // Return error if the field is empty
    }
    final numValue =
        int.tryParse(value); // Try to parse the value as an integer
    if (numValue == null || numValue <= 0) {
      return '$fieldName must be a positive number greater than zero'; // Return error if not a positive number
    }
    return null; // Return null if validation passes
  }
}
