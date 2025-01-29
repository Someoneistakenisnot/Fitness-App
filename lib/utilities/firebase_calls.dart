import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/models/exercise.dart';

import '../models/fitness_user.dart';

bool newUser = false;

FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference fitnessUsersCollection =
    FirebaseFirestore.instance.collection('fitnessUsers');
CollectionReference exercisesCollection =
    FirebaseFirestore.instance.collection('exercises');

class FirebaseCalls {
  Future<FitnessUser> getFitnessUser(String uid) async {
    final doc = await fitnessUsersCollection.doc(uid).get();
    if (doc.exists) {
      return FitnessUser.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      return FitnessUser(
        weight: 0,
        height: 0,
        gender: '',
        age: 0,
        exercise: '',
      );
    }
  }

  Future<void> updateFitnessUser(FitnessUser fitnessUser) async {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await fitnessUsersCollection.doc(user.uid).set({
      'weight': fitnessUser.weight,
      'height': fitnessUser.height,
      'gender': fitnessUser.gender,
      'age': fitnessUser.age,
      'exercise': fitnessUser.exercise,
      'userid': user.uid,
    }, SetOptions(merge: true));
  }

  Future<Exercise> getExercise(String uid) async {
    final doc = await exercisesCollection.doc(uid).get();
    if (doc.exists) {
      return Exercise.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      return Exercise(
        activity: '',
        duration: 0,
        burnedCalories: 0,
      );
    }
  }

  Future<void> addExercise(Exercise exercises) async {
    final user = auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await exercisesCollection.doc(user.uid).set({
      'activity': exercises.activity,
      'duration': exercises.duration,
      'burnedCalories': exercises.burnedCalories,
      'userid': user.uid,
    }, SetOptions(merge: true));
  }
}
