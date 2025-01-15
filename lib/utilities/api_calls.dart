import '../models/fitness_user.dart';
import '../models/bmi.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCalls {
  Future<Bmi> fetchBmi(String weight, String height) async {
    String baseURL = 'https://fitness-api.p.rapidapi.com/fitness';

    Map<String, String> requestHeaders = {
      'X-RapidAPI-Host': 'fitness-api.p.rapidapi.com',
      'X-RapidAPI-Key': '10d17024f3msh55d1271fc091eaep18e217jsn6714a3f892f1', //TODO
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Map<String, String> payload = {
      'weight': '80',
      'height': '180',
      //TODO Add API request parameters
    };

    var request = http.Request('POST', Uri.parse(baseURL));
    request.bodyFields = payload;
    request.headers.addAll(requestHeaders);

    http.StreamedResponse response = await request.send();


    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode();
      Bmi bmiInfo = Bmi.fromJson(jsonMap);
      return bmiInfo;
      //TODO return Bmi object
    }
    else {
      throw Exception('Failed to load bmi');
    }
  }

  void fetchBurnedCalories() {}
}
