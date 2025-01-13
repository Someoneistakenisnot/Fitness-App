import 'dart:convert';

import 'package:http/http.dart' as http;

// import '../models/fitness_user.dart';
import '../models/bmi.dart';

class ApiCalls {
  Future<List<Bmi>> fetchBmi(String baseURL) async {
    const String baseURL = 'https://fitness-api.p.rapidapi.com/fitness';
    MapEntry<String, String> EE_Entry =
        MapEntry("totalDailyEnergyExpenditure.bmi.calories", "value");

    Map<String, String> requestHeaders = {
      'X-RapidAPI-Host': 'fitness-api.p.rapidapi.com',
      'X-RapidAPI-Key':
          'c93f0e349bmsh4f90f71e75907a8p166d42jsne574e84b3e47', //TODO
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Map<String, String> payload = {
      "bodyMassIndex": "conclusion, value",
      "idealBodyWeight.peterson.metric": "value",
      "bodyFatPercentage.bmi": "value",
      EE_Entry.key: EE_Entry.value,
      //TODO Add API request parameters
    };

    var request = http.Request('POST', Uri.parse(baseURL));
    request.bodyFields = payload;
    request.headers.addAll(requestHeaders);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String ReceivedResponse = await response.stream.bytesToString();
      Map<String, dynamic> jsonMap = jsonDecode(ReceivedResponse);
      Bmi bmiInfo = Bmi.fromJson(jsonMap);
      return [bmiInfo];
      //TODO return Bmi object
    } else {
      throw Exception('Failed to load bmi data.');
    }
  }

  void fetchBurnedCalories() {}
}
