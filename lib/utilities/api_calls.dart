import 'dart:convert';

import 'package:fitness/models/exercise.dart';
import 'package:http/http.dart' as http;

import '../models/bmi.dart';

class ApiCalls {
  final List<String> debugLog = [];

  Future<Bmi> fetchBmi() async {
    String baseURL = 'https://fitness-api.p.rapidapi.com/fitness';

    // Request headers
    Map<String, String> requestHeaders = {
      'X-RapidAPI-Host': 'fitness-api.p.rapidapi.com',
      'X-RapidAPI-Key': "50a01b3ffamshc8df8f41d92e983p1bab6fjsneb8c0e60c5ad",
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    // Hardcoded payload
    Map<String, String> payload = {
      'weight': '90',
      'height': '190',
      'age': '30',
      'gender': 'male',
      'exercise': 'little',
    };

    debugLog.add('Sending POST request to $baseURL');
    debugLog.add('Headers: $requestHeaders');
    debugLog.add('Payload: $payload');

    // HTTP POST request
    var response = await http.post(
      Uri.parse(baseURL),
      headers: requestHeaders,
      body: payload,
    );

    if (response.statusCode == 200) {
      try {
        // Decode JSON response
        Map<String, dynamic> jsonMap = jsonDecode(response.body);
        debugLog.add('Response: $jsonMap');

        // Parse into Bmi object
        Bmi bmiInfo = Bmi.fromJson(jsonMap);
        return bmiInfo;
      } catch (e) {
        debugLog.add('Error decoding JSON: $e');
        throw Exception('Failed to parse BMI data');
      }
    } else {
      debugLog.add('Failed to load BMI. Status code: ${response.statusCode}');
      debugLog.add('Response body: ${response.body}');
      throw Exception('Failed to load BMI');
    }
  }

  Future<Exercise> fetchBurnedCalories(String activity, int duration) async {
    const baseURL =
        "https://calories-burned-by-api-ninjas.p.rapidapi.com/v1/caloriesburned";

    Map<String, String> requestHeaders = {
      'X-RapidAPI-Key': 'c93f0e349bmsh4f90f71e75907a8p166d42jsne574e84b3e47',
      'X-RapidAPI-Host': 'calories-burned-by-api-ninjas.p.rapidapi.com'
    };

    Map<String, String> queryParams = {
      'activities': activity,
      'duration': duration.toString(), // Add duration as a query parameter
    };

    // DO NOT EDIT
    String queryString = Uri(queryParameters: queryParams).query;
    final response = await http.get(
      Uri.parse(baseURL + '?' + queryString),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      // Decode the JSON response and return an Exercise object
      return Exercise.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load burned calories');
    }
  }
}
