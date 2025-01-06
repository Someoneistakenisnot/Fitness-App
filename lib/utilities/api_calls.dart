import '../models/fitness_user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCalls {
  void fetchBmi() async {
    String baseURL = 'https://fitness-api.p.rapidapi.com/fitness';

    Map<String, String> requestHeaders = {
      'X-RapidAPI-Host': 'fitness-api.p.rapidapi.com',
      'X-RapidAPI-Key': 'YOUR-API-KEY', //TODO
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Map<String, String> payload = {
      //TODO Add API request parameters
    };

    var request = http.Request('POST', Uri.parse(baseURL));
    request.bodyFields = payload;
    request.headers.addAll(requestHeaders);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //TODO return Bmi object
    } else {
      throw Exception('Failed to load bmi');
    }
  }

  void fetchBurnedCalories() {}
}
