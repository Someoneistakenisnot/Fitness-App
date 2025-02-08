import 'dart:convert'; // For handling JSON encoding/decoding operations

import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore database package
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication package
import 'package:fitness/models/exercise.dart'; // Exercise data model
import 'package:http/http.dart' as http; // HTTP client for making API requests

import '../models/bmi.dart'; // BMI data model

/// Central class for handling fitness-related API communications
class ApiCalls {
  // List to track API call details for debugging purposes
  final List<String> debugLog = [];

  /// Fetches BMI data from external fitness API using user profile data
  Future<Bmi> fetchBmi() async {
    // Get current authenticated user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated. Please log in.');
    }

    // Retrieve user document from Firestore
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('fitnessUsers')
        .where('userid', isEqualTo: user.uid)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('User data not found. Please update your profile.');
    }

    // Extract user data from document
    DocumentSnapshot doc = querySnapshot.docs.first;
    Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

    // Validate required user data fields exist
    if (userData['weight'] == null ||
        userData['height'] == null ||
        userData['age'] == null ||
        userData['gender'] == null ||
        userData['exercise'] == null) {
      throw Exception('Incomplete user data. Please update your profile.');
    }

    // Prepare API parameters from user data
    String weight = userData['weight'].toString();
    String height = userData['height'].toString();
    String age = userData['age'].toString();
    String gender = userData['gender'];
    String exercise = userData['exercise'] == 'veryheavy'
        ? 'very heavy' // Handle special case formatting
        : userData['exercise'];

    // API configuration
    const String baseURL = 'https://fitness-api.p.rapidapi.com/fitness';
    const Map<String, String> requestHeaders = {
      'X-RapidAPI-Host': 'fitness-api.p.rapidapi.com',
      'X-RapidAPI-Key': "c93f0e349bmsh4f90f71e75907a8p166d42jsne574e84b3e47",
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    // Construct request payload
    Map<String, String> payload = {
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'exercise': exercise,
    };

    // Log request details
    debugLog.addAll([
      'Sending POST request to $baseURL',
      'Headers: $requestHeaders',
      'Payload: $payload'
    ]);

    // Execute POST request
    final response = await http.post(
      Uri.parse(baseURL),
      headers: requestHeaders,
      body: payload,
    );

    // Handle response
    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        debugLog.add('Response: $jsonMap');
        return Bmi.fromJson(jsonMap); // Convert JSON to BMI model
      } catch (e) {
        debugLog.add('Error decoding JSON: $e');
        throw Exception('Failed to parse BMI data: $e');
      }
    } else {
      debugLog.add('Failed to load BMI. Status code: ${response.statusCode}');
      debugLog.add('Response body: ${response.body}');
      throw Exception('Failed to load BMI: ${response.statusCode}');
    }
  }

  /// Retrieves calorie expenditure data for specific activity
  Future<Exercise> fetchBurnedCalories(String activity, int duration) async {
    const String baseURL =
        "https://calories-burned-by-api-ninjas.p.rapidapi.com/v1/caloriesburned";
    const Map<String, String> requestHeaders = {
      'X-RapidAPI-Key': 'c93f0e349bmsh4f90f71e75907a8p166d42jsne574e84b3e47',
      'X-RapidAPI-Host': 'calories-burned-by-api-ninjas.p.rapidapi.com'
    };

    // Build query parameters
    final Map<String, String> queryParams = {
      'activity': activity,
      'duration': duration.toString(),
    };

    // Log request details
    final String queryString = Uri(queryParameters: queryParams).query;
    debugLog.addAll([
      'Sending GET request to $baseURL?$queryString',
      'Headers: $requestHeaders'
    ]);

    // Execute GET request
    final response = await http.get(
      Uri.parse('$baseURL?$queryString'),
      headers: requestHeaders,
    );

    // Handle response
    debugLog.addAll([
      'Response status: ${response.statusCode}',
      'Response body: ${response.body}'
    ]);

    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body)[0]; // Extract first result
        debugLog.add('Decoded response: $jsonData');
        return Exercise.fromJson(jsonData); // Convert JSON to Exercise model
      } catch (e) {
        debugLog.add('Error decoding JSON: $e');
        throw Exception('Failed to parse exercise data: $e');
      }
    } else {
      throw Exception('Failed to load burned calories: ${response.statusCode}');
    }
  }

  Future<String> chatGptRequest(String message) async {
    const String url = "https://chatgpt-42.p.rapidapi.com/gpt4";
    const Map<String, String> requestHeaders = {
      "x-rapidapi-key": "c93f0e349bmsh4f90f71e75907a8p166d42jsne574e84b3e47",
      "x-rapidapi-host": "chatgpt-42.p.rapidapi.com",
      "Content-Type": "application/json",
    };

    // System prompt to set the AI's personality
    const String systemPrompt =
        "You are a uwu kitty, you will uwuify anything and reply in gen z slang uwufied. "
        "You are a UWU fitness coach with an uwu personality. "
        "Encourage users to exercise using cute and playful language.";

    // Construct chat message payload
    final Map<String, dynamic> payload = {
      "system_prompt": systemPrompt, // Set initial system behavior
      "messages": [
        {"role": "user", "content": message}
      ],
      "temperature": 0.9,
      "top_k": 5,
      "top_p": 0.9,
      "max_tokens": 256
    };

    // Log request details
    debugLog.addAll([
      'Sending POST request to $url',
      'Headers: $requestHeaders',
      'Payload: $payload'
    ]);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: requestHeaders,
        body: jsonEncode(payload),
      );

      debugLog.addAll([
        'Response status: ${response.statusCode}',
        'Response body: ${response.body}'
      ]);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['result']; // Extract generated response
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugLog.add('Error in ChatGPT request: $e');
      throw Exception('ChatGPT communication failed: $e');
    }
  }
}
