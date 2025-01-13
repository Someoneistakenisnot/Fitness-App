import '../models/fitness_user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCalls {

  Future<List<Bmi>> fetchBmi(String baseURL) async {
    const String baseURL = 'https://fitness-api.p.rapidapi.com/fitness';
    MapEntry<String, String> EE_Entry =
        MapEntry("totalDailyEnergyExpenditure.bmi.calories", "value");
=======
  void fetchBmi() async {
    String baseURL = 'https://fitness-api.p.rapidapi.com/fitness';
>>>>>>> 0a7a60136f2d78c788e6765098884e9d16dbfed2

    Map<String, String> requestHeaders = {
      'X-RapidAPI-Host': 'fitness-api.p.rapidapi.com',
      'X-RapidAPI-Key':
          'c93f0e349bmsh4f90f71e75907a8p166d42jsne574e84b3e47', //TODO
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

      String ReceivedResponse = await response.stream.bytesToString();
      List<dynamic> jsonList = jsonDecode(ReceivedResponse) as List<dynamic>;
      List<Bmi> bmiInfo = jsonList.map((json) => Bmi.fromJson(json)).toList();
      return bmiInfo; //uncomment when apis are implemented in their respective pages
      //TO DO return bmi data
      //TODO return Bmi object
>>>>>>> 0a7a60136f2d78c788e6765098884e9d16dbfed2
    } else {
      throw Exception('Failed to load bmi data.');
    }
  }

  void fetchBurnedCalories() {}
}
