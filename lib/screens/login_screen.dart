import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider; // Import Firebase authentication
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // Import Firebase UI for authentication
import 'package:flutter/material.dart'; // Import Flutter material design package

import '../models/fitness_user.dart'; // Import FitnessUser  model
import '../screens/home_screen.dart'; // Import home screen
import '../screens/update_fitness_user_screen.dart'; // Import screen for updating fitness user profile
import '../utilities/firebase_calls.dart'; // Import Firebase utility functions

/// Login screen for user authentication and profile management
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance
            .userChanges(), // Listen for changes in user authentication state
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // If no user is logged in, show the sign-in screen
            return SignInScreen(
              providers: [
                EmailAuthProvider(), // Allow email authentication
              ],
            );
          } else {
            // If user is logged in, check if they have a display name
            if (snapshot.data?.displayName == null) {
              // If display name is null, show profile screen for user to complete their profile
              return ProfileScreen(
                providers: [
                  EmailAuthProvider(), // Allow email authentication
                ],
              );
            } else {
              // If user has a display name, check if they exist in the fitnessUsers collection
              return FutureBuilder<FitnessUser>(
                future: FirebaseCalls().getFitnessUser(
                    snapshot.data!.uid), // Fetch fitness user data
                builder: (context, snapshot2) {
                  if (snapshot2.hasData) {
                    // If fitness user data is found
                    if (newUser) {
                      // Check if the user is new (this variable should be defined elsewhere)
                      return const UpdateFitnessUserScreen(); // Show screen to update fitness user profile
                    } else {
                      return const HomeScreen(); // Show home screen for existing users
                    }
                  } else if (snapshot2.hasError) {
                    // If there was an error fetching fitness user data
                    return Text('${snapshot2.error}'); // Display error message
                  }
                  return const CircularProgressIndicator(); // Show loading indicator while fetching data
                },
              );
            }
          }
        },
      ),
    );
  }
}
