import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/fitness_user.dart';
import '../widgets/navigation_bar.dart';
import '../utilities/firebase_calls.dart';

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
    final snapshot = await fitnessUsersCollection
        .where('userid', isEqualTo: auth.currentUser?.uid)
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
                    const Text(
                      'Update Fitness User',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Weight (kg)',
                      controller: weightController,
                      focusNode: weightFocusNode,
                      inputType: TextInputType.number,
                      suffixText: 'kg',
                      validator: (value) =>
                          _validatePositiveNumber(value, 'Weight'),
                    ),
                    _buildTextField(
                      label: 'Height (cm)',
                      controller: heightController,
                      focusNode: heightFocusNode,
                      inputType: TextInputType.number,
                      suffixText: 'cm',
                      validator: (value) =>
                          _validatePositiveNumber(value, 'Height'),
                    ),
                    _buildDropdownField(
                      label: 'Gender',
                      value: selectedGender,
                      options: genderOptions,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    _buildTextField(
                      label: 'Age',
                      controller: ageController,
                      focusNode: ageFocusNode,
                      inputType: TextInputType.number,
                      validator: (value) =>
                          _validatePositiveNumber(value, 'Age'),
                    ),
                    _buildDropdownField(
                      label: 'Exercise Level',
                      value: selectedExerciseLevel,
                      options: exerciseOptions,
                      onChanged: (value) {
                        setState(() {
                          // Store display value directly, handle conversion only when saving
                          selectedExerciseLevel = value;
                        });
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Save'),
                      onPressed: () async {
                        if (!_validateAllFields()) {
                          return;
                        }

                        FitnessUser fitnessUser = FitnessUser(
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

  Widget _buildDropdownField({
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
        const SnackBar(content: Text('Please fill in all fields correctly')),
      );
      return false;
    }
    return true;
  }

  String? _validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty';
    }
    final numValue = int.tryParse(value);
    if (numValue == null || numValue <= 0) {
      return '$fieldName must be a positive number greater than zero';
    }
    return null;
  }
}
