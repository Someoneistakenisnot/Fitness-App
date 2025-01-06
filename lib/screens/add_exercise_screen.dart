import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../utilities/api_calls.dart';
import '../utilities/firebase_calls.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO TextField widgets for user to enter activity and duration (in mins).
    // TODO ElevatedButton for ApiCalls().fetchBurnedCalories() and FirebaseCalls().addExercise()
    return const Placeholder();
  }
}
