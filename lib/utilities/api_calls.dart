import 'package:http/http.dart' as http;
// import 'package:Fitness-App/models.bmi.dart';

class ApiCalls {
  void fetchBmi() async {
    String baseURL = 'https://fitness-api.p.rapidapi.com/fitness';

    Map<String, String> requestHeaders = {
      'X-RapidAPI-Host': 'fitness-api.p.rapidapi.com',
      'X-RapidAPI-Key': 'c93f0e349bmsh4f90f71e75907a8p166d42jsne574e84b3e47',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Map<String, String> payload = {
      'X-RapidAPI-Host': 'fitness-api.p.rapidapi.com',
      'X-RapidAPI-Key': 'c93f0e349bmsh4f90f71e75907a8p166d42jsne574e84b3e47',
      'Content-Type': 'application/x-www-form-urlencoded',
      //TO DO Add API request parameters
    };

    var request = http.Request('POST', Uri.parse(baseURL));
    request.bodyFields = payload;
    request.headers.addAll(requestHeaders);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      // List<Bmi> BmiInfo = jsonList.map((json) => Bmi.fromJson(json)).toList();
      // return BmiInfo; //uncomment when apis are implemented in their respective pages
      //TO DO return Bmi object
    } else {
      throw Exception('Failed to load bmi');
    }
  }

  void fetchBurnedCalories() {} //still have yet to do
}
