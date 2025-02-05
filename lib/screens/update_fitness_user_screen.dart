import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/fitness_user.dart';
import '../utilities/firebase_calls.dart';
import '../widgets/navigation_bar.dart';

class UpdateFitnessUserScreen extends StatefulWidget {
  const UpdateFitnessUserScreen({Key? key}) : super(key: key);

  @override
  State<UpdateFitnessUserScreen> createState() =>
      _UpdateFitnessUserScreenState();
}

class _UpdateFitnessUserScreenState extends State<UpdateFitnessUserScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final FocusNode weightFocusNode = FocusNode();
  final FocusNode heightFocusNode = FocusNode();
  final FocusNode ageFocusNode = FocusNode();
  String? selectedGender;
  String? selectedExerciseLevel;
  final List<String> genderOptions = ['male', 'female'];
  final List<String> exerciseOptions = [
    'little',
    'light',
    'moderate',
    'heavy',
    'very heavy'
  ];
  bool _isInitialized = false;
  late DocumentSnapshot _initialData;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void dispose() {
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    weightFocusNode.dispose();
    heightFocusNode.dispose();
    ageFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('fitnessUsers')
        .where('userid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      _initialData = snapshot.docs.first;
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    if (_isInitialized) return;

    weightController.text = _initialData.get('weight').toString();
    heightController.text = _initialData.get('height').toString();
    ageController.text = _initialData.get('age').toString();
    selectedGender = _initialData.get('gender');
    final exercise = _initialData.get('exercise');
    selectedExerciseLevel = exercise == 'veryheavy' ? 'very heavy' : exercise;

    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Update Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 2),
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _loadInitialData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildTextField(
                      label: 'Weight (kg)',
                      controller: weightController,
                      focusNode: weightFocusNode,
                      inputType: TextInputType.number,
                      suffixText: 'kg',
                      validator: (value) =>
                          _validatePositiveNumber(value, 'Weight'),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Height (cm)',
                      controller: heightController,
                      focusNode: heightFocusNode,
                      inputType: TextInputType.number,
                      suffixText: 'cm',
                      validator: (value) =>
                          _validatePositiveNumber(value, 'Height'),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Gender',
                      value: selectedGender,
                      options: genderOptions,
                      onChanged: (value) =>
                          setState(() => selectedGender = value),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                        label: 'Age',
                        controller: ageController,
                        focusNode: ageFocusNode,
                        inputType: TextInputType.number,
                        validator: (value) =>
                            _validatePositiveNumber(value, 'Age')),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Activity Level',
                      value: selectedExerciseLevel,
                      options: exerciseOptions,
                      onChanged: (value) =>
                          setState(() => selectedExerciseLevel = value),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (!_validateAllFields()) return;

                        final fitnessUser = FitnessUser(
                          weight: int.parse(weightController.text),
                          height: int.parse(heightController.text),
                          gender: selectedGender!,
                          age: int.parse(ageController.text),
                          exercise: selectedExerciseLevel == 'very heavy'
                              ? 'veryheavy'
                              : selectedExerciseLevel!,
                        );

                        await FirebaseCalls().updateFitnessUser(fitnessUser);
                        setState(() {});
                      },
                      child: const Text(
                        'SAVE CHANGES',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
      style:
          const TextStyle(color: Colors.black), // Add this line for black text
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffixText,
        suffixStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        filled: true,
        fillColor:
            Colors.grey[400], // Changed from grey to white for better contrast
        labelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold), // Optional: Style label text
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        filled: true,
        fillColor: Colors.grey[400],
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: const Icon(Icons.arrow_drop_down,
              color: Colors.black), // Arrow icon
          iconEnabledColor: Colors.black, // Color when dropdown is enabled
          iconDisabledColor: Colors.black,
          value: value,
          isExpanded: true,
          style: const TextStyle(color: Colors.black),
          dropdownColor:
              Colors.grey[400], // Add this for dropdown menu background
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black, // Keep text color black for contrast
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  bool _validateAllFields() {
    String? weightError =
        _validatePositiveNumber(weightController.text, 'Weight');
    String? heightError =
        _validatePositiveNumber(heightController.text, 'Height');
    String? ageError = _validatePositiveNumber(ageController.text, 'Age');

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
