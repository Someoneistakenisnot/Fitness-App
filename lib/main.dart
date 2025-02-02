// Import necessary packages and screens
import 'package:firebase_core/firebase_core.dart'; // Firebase core package
import 'package:flutter/material.dart'; // Flutter material design package

import '../screens/chatbot_screen.dart';
// Application screens
import '../screens/exercise_screen.dart';
import '../screens/game.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/update_fitness_user_screen.dart';
// Firebase configuration generated file
import 'firebase_options.dart';

// Main application entry point
Future<void> main() async {
  // Ensure Flutter widgets are properly initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Start the application with MyApp widget
  runApp(const MyApp());
}

// Root application widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner
      theme: ThemeData.dark(), // Use dark theme for entire app
      initialRoute: '/', // Starting route of the application

      // Define application routes and their associated screens
      routes: {
        // Authentication route
        '/': (context) => const LoginScreen(),

        // Main application screen
        '/home': (context) => const HomeScreen(),

        // Exercise-related screen
        '/exercise': (context) => const ExerciseScreen(),

        // User profile management screen
        '/user': (context) => const UpdateFitnessUserScreen(),

        // Game feature screen
        '/game': (context) => const GameScreen(),

        // Chatbot interface screen
        '/chatbot': (context) => const ChatBotScreen(),
      },
    );
  }
}
