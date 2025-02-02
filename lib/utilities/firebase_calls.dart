import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth package
import 'package:fitness/models/exercise.dart'; // Exercise model

import '../models/fitness_user.dart'; // FitnessUser model

// Global flag to track new user status (not used in this snippet)
bool newUser = false;

// Firebase Auth instance for user authentication
FirebaseAuth auth = FirebaseAuth.instance;

// Firestore collections for fitness users and exercises
CollectionReference fitnessUsersCollection =
    FirebaseFirestore.instance.collection('fitnessUsers');
CollectionReference exercisesCollection =
    FirebaseFirestore.instance.collection('exercises');

/// Handles Firebase operations for fitness users and exercises.
class FirebaseCalls {
  /// Fetches a [FitnessUser] from Firestore using the user's [uid].
  /// Returns a default user if no document exists.
  Future<FitnessUser> getFitnessUser(String uid) async {
    final doc = await fitnessUsersCollection.doc(uid).get();
    if (doc.exists) {
      // Convert Firestore data to FitnessUser object
      return FitnessUser.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      // Return default user if document doesn't exist
      return FitnessUser(
        weight: 0,
        height: 0,
        gender: '',
        age: 0,
        exercise: '',
      );
    }
  }

  /// Updates or creates a [FitnessUser] document in Firestore.
  /// Throws an error if no user is logged in.
  Future<void> updateFitnessUser(FitnessUser fitnessUser) async {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    // Merge data to update existing fields without overwriting the entire document
    await fitnessUsersCollection.doc(user.uid).set({
      'weight': fitnessUser.weight,
      'height': fitnessUser.height,
      'gender': fitnessUser.gender,
      'age': fitnessUser.age,
      'exercise': fitnessUser.exercise,
      'userid': user.uid, // Include user ID for reference
    }, SetOptions(merge: true)); // Merge instead of overwrite
  }

  /// Fetches an [Exercise] from Firestore using the user's [uid].
  /// Returns a default exercise if no document exists.
  Future<Exercise> getExercise(String uid) async {
    final doc = await exercisesCollection.doc(uid).get();
    if (doc.exists) {
      // Convert Firestore data to Exercise object
      return Exercise.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      // Return default exercise if document doesn't exist
      return Exercise(
        activity: '',
        duration: 0,
        burnedCalories: 0,
      );
    }
  }

  /// Adds or updates an [Exercise] document in Firestore.
  /// Throws an error if no user is logged in.
  Future<void> addExercise(Exercise exercises) async {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    // Merge data to update existing fields without overwriting the entire document
    await exercisesCollection.doc(user.uid).set({
      'activity': exercises.activity, // Activity name
      'duration': exercises.duration, // Duration of the exercise
      'burnedCalories':
          exercises.burnedCalories, // Calories burned during the exercise
      'userid': user.uid, // Include user ID for reference
    }, SetOptions(merge: true)); // Merge instead of overwrite
  }
}
