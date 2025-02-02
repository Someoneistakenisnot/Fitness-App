/// A class representing a fitness user with personal metrics.
class FitnessUser {
  int weight; // User's weight in kilograms
  int height; // User's height in centimeters
  String gender; // User's gender (e.g., male, female, other)
  int age; // User's age in years
  String exercise; // User's preferred type of exercise

  // TODO: Add properties for gender, age, and exercise level

  // Constructor for the FitnessUser  class, requiring all properties to be provided
  FitnessUser({
    required this.weight,
    required this.height,
    required this.gender,
    required this.age,
    required this.exercise,
  });

  /// Factory method to create a FitnessUser  instance from a Map.
  ///
  /// This method extracts the relevant data from the provided map
  /// and returns a new instance of the FitnessUser  class.
  factory FitnessUser.fromMap(Map<String, dynamic> map) {
    // Return a new FitnessUser  instance using values from the map
    return FitnessUser(
      weight:
          map['weight'] ?? 0.0, // Provide a default value if key doesn't exist
      height:
          map['height'] ?? 0.0, // Provide a default value if key doesn't exist
      gender:
          map['gender'] ?? '', // Provide a default value if key doesn't exist
      age: map['age'] ?? 0, // Provide a default value if key doesn't exist
      exercise:
          map['exercise'] ?? '', // Provide a default value if key doesn't exist
    );
  }
}
