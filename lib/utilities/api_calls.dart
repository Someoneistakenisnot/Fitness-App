import 'dart:convert'; // Import for JSON encoding/decoding

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/models/exercise.dart'; // Import Exercise model
import 'package:http/http.dart'
    as http; // Import HTTP package for making requests

import '../models/bmi.dart'; // Import BMI model

/// A class to handle API calls related to fitness data.
class ApiCalls {
  final List<String> debugLog =
      []; // List to store debug logs for tracking API calls

  /// Fetches BMI data from the fitness API.
  Future<Bmi> fetchBmi() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated. Please log in.');
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('fitnessUsers')
        .where('userid', isEqualTo: user.uid)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('User data not found. Please update your profile.');
    }

    DocumentSnapshot doc = querySnapshot.docs.first;
    Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

    // Validate required fields
    if (userData['weight'] == null ||
        userData['height'] == null ||
        userData['age'] == null ||
        userData['gender'] == null ||
        userData['exercise'] == null) {
      throw Exception('Incomplete user data. Please update your profile.');
    }

    String weight = userData['weight'].toString();
    String height = userData['height'].toString();
    String age = userData['age'].toString();
    String gender = userData['gender'];
    String exercise = userData['exercise'] == 'veryheavy'
        ? 'very heavy'
        : userData['exercise'];

    const String baseURL =
        'https://fitness-api.p.rapidapi.com/fitness'; // Base URL for the BMI API

    // Request headers for the API call
    const Map<String, String> requestHeaders = {
      'X-RapidAPI-Host':
          'fitness-api.p.rapidapi.com', // Host header for RapidAPI
      'X-RapidAPI-Key':
          "c93f0e349bmsh4f90f71e75907a8p166d42jsne574e84b3e47", // Replace with your API key
      'Content-Type':
          'application/x-www-form-urlencoded', // Content type for the request
    };

    // Hardcoded payload with user data for BMI calculation
    Map<String, String> payload = {
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'exercise': exercise,
      // 'weight': '90', // User's weight
      // 'height': '190', // User's height
      // 'age': '30', // User's age
      // 'gender': 'male', // User's gender
      // 'exercise': 'little', // User's exercise level
    };

    // Log the request details for debugging
    debugLog.add('Sending POST request to $baseURL');
    debugLog.add('Headers: $requestHeaders');
    debugLog.add('Payload: $payload');

    // HTTP POST request to fetch BMI data
    final response = await http.post(
      Uri.parse(baseURL), // Parse the base URL
      headers: requestHeaders, // Set request headers
      body: payload, // Set request body
    );

    // Check if the response status is OK (200)
    if (response.statusCode == 200) {
      try {
        // Decode JSON response into a Map
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        debugLog.add('Response: $jsonMap'); // Log the response for debugging

        // Parse the JSON map into a Bmi object
        return Bmi.fromJson(jsonMap); // Return the Bmi object
      } catch (e) {
        debugLog.add('Error decoding JSON: $e'); // Log any JSON decoding errors
        throw Exception(
            'Failed to parse BMI data: $e'); // Throw an exception if parsing fails
      }
    } else {
      // Log the error if the response status is not OK
      debugLog.add('Failed to load BMI. Status code: ${response.statusCode}');
      debugLog.add('Response body: ${response.body}');
      throw Exception(
          'Failed to load BMI: ${response.statusCode}'); // Throw an exception for failed request
    }
  }

  /// Fetches burned calories based on activity and duration.
  Future<Exercise> fetchBurnedCalories(String activity, int duration) async {
    const String baseURL =
        "https://calories-burned-by-api-ninjas.p.rapidapi.com/v1/caloriesburned";

    // Request headers for the API call
    const Map<String, String> requestHeaders = {
      'X-RapidAPI-Key': 'c93f0e349bmsh4f90f71e75907a8p166d42jsne574e84b3e47',
      'X-RapidAPI-Host': 'calories-burned-by-api-ninjas.p.rapidapi.com'
    };

    // Query parameters for the API call
    final Map<String, String> queryParams = {
      'activity': activity,
      'duration': duration.toString(),
    };

    final String queryString = Uri(queryParameters: queryParams).query;

    debugLog.add('Sending GET request to $baseURL?$queryString');
    debugLog.add('Headers: $requestHeaders');

    final response = await http.get(
      Uri.parse('$baseURL?$queryString'),
      headers: requestHeaders,
    );

    debugLog.add('Response status: ${response.statusCode}');
    debugLog.add('Response body: ${response.body}');

    print(response.body); // Print raw response body to console

    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body)[0];
        debugLog.add('Decoded response: $jsonData');
        return Exercise.fromJson(jsonData);
      } catch (e) {
        debugLog.add('Error decoding JSON: $e');
        throw Exception('Failed to parse exercise data: $e');
      }
    } else {
      throw Exception('Failed to load burned calories: ${response.statusCode}');
    }
  }
}
