/// A class representing Body Mass Index (BMI) and related health metrics.
class Bmi {
  final double bmi; // The calculated Body Mass Index value
  final String
      bmiConclusion; // Conclusion based on the BMI value (e.g., underweight, normal, overweight)
  final double idealBodyWt; // Ideal body weight based on the user's metrics
  final double bodyFatPercent; // Body fat percentage
  final int totalDailyEE; // Total daily energy expenditure in calories

  // Constructor for the Bmi class, requiring all properties to be provided
  Bmi({
    required this.bmi,
    required this.bmiConclusion,
    required this.idealBodyWt,
    required this.bodyFatPercent,
    required this.totalDailyEE,
  });

  // TODO: Implement Bmi.fromJson to create a Bmi instance from a JSON object

  /// Factory method to create a Bmi instance from a JSON map.
  ///
  /// This method extracts the relevant data from the provided JSON map
  /// and returns a new instance of the Bmi class.
  factory Bmi.fromJson(Map<String, dynamic> json) {
    // Debug prints to check the values being extracted from the JSON
    print(json['bodyMassIndex']['value']); // Print the BMI value
    print(json['bodyMassIndex']['conclusion']); // Print the BMI conclusion
    print(json['idealBodyWeight']['peterson']['metric']
        ['value']); // Print the ideal body weight
    print(json['bodyFatPercentage']['bmi']
        ['value']); // Print the body fat percentage
    print(json['totalDailyEnergyExpenditure']['bmi']['calories']
        ['value']); // Print total daily energy expenditure

    // Return a new Bmi instance using the extracted values from the JSON
    return Bmi(
      bmi: json['bodyMassIndex']['value'], // Extract BMI value
      bmiConclusion: json['bodyMassIndex']
          ['conclusion'], // Extract BMI conclusion
      idealBodyWt: json['idealBodyWeight']['peterson']['metric']
          ['value'], // Extract ideal body weight
      bodyFatPercent: json['bodyFatPercentage']['bmi']
          ['value'], // Extract body fat percentage
      totalDailyEE: json['totalDailyEnergyExpenditure']['bmi']['calories']
          ['value'], // Extract total daily energy expenditure
    );
  }
}
