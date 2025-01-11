import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bmi.dart';

class ApiCalls {
  Future<List<Bmi>> fetchBmi(String baseURL) async {
    // Ensure that baseURL is being passed correctly
    print("fetchBmi method called."); // Entry point confirmation
    print("Received baseURL: $baseURL");

    // Define API URL (use the passed baseURL parameter instead of redefining)
    final String apiURL = 'https://fitness-api.p.rapidapi.com/fitness';
    print("Using API URL: $apiURL");

    MapEntry<String, String> EE_Entry =
        MapEntry("totalDailyEnergyExpenditure.bmi.calories", "value");

    Map<String, String> requestHeaders = {
      'X-RapidAPI-Host': 'fitness-api.p.rapidapi.com',
      'X-RapidAPI-Key': 'c93f0e349bmsh4f90f71e75907a8p166d42jsne574e84b3e47',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Map<String, String> payload = {
      "bodyMassIndex": "conclusion, value",
      "idealBodyWeight.peterson.metric": "value",
      "bodyFatPercentage.bmi": "value",
      EE_Entry.key: EE_Entry.value,
    };

    try {
      print("Preparing HTTP request..."); // Debugging
      var request = http.Request('POST', Uri.parse(apiURL));
      request.bodyFields = payload;
      request.headers.addAll(requestHeaders);

      print("Sending POST request to API...");
      print("Request Headers: $requestHeaders");
      print("Request Body Fields: $payload");

      http.StreamedResponse response = await request.send();

      print("Waiting for API response...");
      if (response.statusCode == 200) {
        print("API call successful. Status code: ${response.statusCode}");

        String receivedResponse = await response.stream.bytesToString();
        print("Raw JSON response: $receivedResponse");

        try {
          List<dynamic> jsonList =
              jsonDecode(receivedResponse) as List<dynamic>;
          print("Decoded JSON: $jsonList");

          List<Bmi> bmiInfo =
              jsonList.map((json) => Bmi.fromJson(json)).toList();
          print("Parsed BMI objects: $bmiInfo");
          return bmiInfo;
        } catch (e) {
          print("Error decoding JSON: $e");
          throw Exception('Failed to decode JSON');
        }
      } else {
        print("API call failed. Status code: ${response.statusCode}");
        print("Reason: ${response.reasonPhrase}");
        throw Exception('Failed to load BMI');
      }
    } catch (e) {
      print("Exception caught: $e");
      throw Exception('Error occurred during API call');
    }
  }

  void fetchBurnedCalories() {
    print("fetchBurnedCalories method called."); // Debugging placeholder
    // TODO: Implement fetchBurnedCalories logic
  }
}
