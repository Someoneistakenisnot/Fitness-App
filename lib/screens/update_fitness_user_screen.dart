import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package for database operations
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication package
import 'package:flutter/material.dart'; // Flutter material design package

import '../models/fitness_user.dart'; // Importing FitnessUser  model
import '../utilities/firebase_calls.dart'; // Importing Firebase calls utility
import '../widgets/navigation_bar.dart'; // Importing custom navigation bar widget

/// Screen for updating the fitness user profile
class UpdateFitnessUserScreen extends StatefulWidget {
  const UpdateFitnessUserScreen({Key? key}) : super(key: key);

  @override
  State<UpdateFitnessUserScreen> createState() =>
      _UpdateFitnessUserScreenState();
}

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
  late DocumentSnapshot
      _initialData; // Variable to hold initial data from Firestore

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Load initial data when the screen is initialized
  }

  @override
  void dispose() {
// Dispose of controllers and focus nodes to free up resources
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    weightFocusNode.dispose();
    heightFocusNode.dispose();
    ageFocusNode.dispose();
    super.dispose();
  }

  /// Loads initial data from Firestore for the current user
  Future<void> _loadInitialData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('fitnessUsers')
        .where('userid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      _initialData = snapshot.docs.first; // Get the first document
      _initializeControllers(); // Initialize text controllers with data
    }
  }

  /// Initializes the text controllers with data from Firestore
  void _initializeControllers() {
    if (_isInitialized) return; // Prevent re-initialization

// Set the text fields with initial data
    weightController.text = _initialData.get('weight').toString();
    heightController.text = _initialData.get('height').toString();
    ageController.text = _initialData.get('age').toString();
    selectedGender = _initialData.get('gender');
    final exercise = _initialData.get('exercise');
    selectedExerciseLevel = exercise == 'veryheavy' ? 'very heavy' : exercise;

    _isInitialized = true; // Mark as initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background color for the screen
      appBar: AppBar(
        title: const Text(
          'Update Profile', // Title of the app bar
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal, // App bar background color
        elevation: 0, // No shadow
      ),
      bottomNavigationBar: MyBottomNavigationBar(
          selectedIndexNavBar: 2), // Custom navigation bar
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _loadInitialData(), // Load initial data asynchronously
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // Show loading indicator while waiting
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Padding for the content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
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
                    const SizedBox(height: 16), // Spacing between fields
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
                    const SizedBox(height: 16), // Spacing between fields
// Gender dropdown field
                    _buildDropdownField(
                      label: 'Gender',
                      value: selectedGender,
                      options: genderOptions,
                      onChanged: (value) =>
                          setState(() => selectedGender = value),
                    ),
                    const SizedBox(height: 16), // Spacing between fields
// Age input field
                    _buildTextField(
                        label: 'Age',
                        controller: ageController,
                        focusNode: ageFocusNode,
                        inputType: TextInputType.number,
                        validator: (value) =>
                            _validatePositiveNumber(value, 'Age')),
                    const SizedBox(height: 16), // Spacing between fields
// Activity level dropdown field
                    _buildDropdownField(
                      label: 'Activity Level',
                      value: selectedExerciseLevel,
                      options: exerciseOptions,
                      onChanged: (value) =>
                          setState(() => selectedExerciseLevel = value),
                    ),
                    const SizedBox(height: 24), // Spacing before button
// Save changes button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Button background color
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                      ),
                      onPressed: () async {
                        if (!_validateAllFields())
                          return; // Validate fields before saving

// Create a FitnessUser  object with updated data
                        final fitnessUser = FitnessUser(
                          weight: int.parse(weightController.text),
                          height: int.parse(heightController.text),
                          gender: selectedGender!,
                          age: int.parse(ageController.text),
                          exercise: selectedExerciseLevel == 'very heavy'
                              ? 'veryheavy'
                              : selectedExerciseLevel!,
                        );

                        await FirebaseCalls().updateFitnessUser(
                            fitnessUser); // Update user in Firestore
                        setState(() {}); // Refresh the UI
                      },
                      child: const Text(
                        'SAVE', // Button text
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Button text color
                        ),
                      ),
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

  /// Builds a text field with specified parameters
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required TextInputType inputType,
    String? suffixText,
    String? Function(String?)? validator,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.black), // Text color
      decoration: InputDecoration(
        labelText: label, // Label for the text field
        suffixText: suffixText, // Suffix text (e.g., kg, cm)
        suffixStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded border
          borderSide: const BorderSide(color: Colors.black),
        ),
        filled: true,
        fillColor: Colors.grey[400], // Background color of the text field
        labelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold), // Label text style
      ),
    );
  }

  /// Builds a dropdown field with specified parameters
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label, // Label for the dropdown
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded border
          borderSide: const BorderSide(color: Colors.black),
        ),
        filled: true,
        fillColor: Colors.grey[400], // Background color of the dropdown
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: const Icon(Icons.arrow_drop_down,
              color: Colors.black), // Arrow icon for dropdown
          iconEnabledColor: Colors.black, // Color when dropdown is enabled
          iconDisabledColor: Colors.black, // Color when dropdown is disabled
          value: value, // Current selected value
          isExpanded: true, // Expand to fill available space
          style: const TextStyle(
              color: Colors.black), // Text color for dropdown items
          dropdownColor: Colors.grey[400], // Background color for dropdown menu
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value, // Value for the dropdown item
              child: Text(
                value.toUpperCase(), // Display value in uppercase
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black, // Text color for dropdown item
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged, // Callback when a new item is selected
        ),
      ),
    );
  }

  /// Validates all input fields and shows a snackbar if any are invalid
  bool _validateAllFields() {
    String? weightError = _validatePositiveNumber(
        weightController.text, 'Weight'); // Validate weight
    String? heightError = _validatePositiveNumber(
        heightController.text, 'Height'); // Validate height
    String? ageError =
        _validatePositiveNumber(ageController.text, 'Age'); // Validate age

// Check if any fields are invalid
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

  /// Validates if a given value is a positive number
  String? _validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty'; // Return error if the field is empty
    }
    final numValue =
        int.tryParse(value); // Try to parse the value as an integer
    if (numValue == null || numValue <= 0) {
      return '$fieldName must be a positive number greater than zero'; // Return error if not a positive number
    }
    return null; // Return null if validation passes
  }
}
