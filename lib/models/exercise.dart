/// A class representing an exercise activity with its details.
class Exercise {
  late final String activity; // The name of the exercise activity
  late final int duration; // Duration of the exercise in minutes
  final int burnedCalories; // Total calories burned during the exercise

  // Constructor for the Exercise class, requiring all properties to be provided
  Exercise({
    required this.activity,
    required this.duration,
    required this.burnedCalories,
  });

  /// Factory method to create an Exercise instance from a JSON map.
  ///
  /// This method extracts the relevant data from the provided JSON map
  /// and returns a new instance of the Exercise class.
  factory Exercise.fromJson(Map<String, dynamic> json) {
    // Debug prints to check the values being extracted from the JSON
    print(json['name']); // Print the name of the activity
    print(json['duration_minutes']); // Print the duration in minutes
    print(json['total_calories']); // Print the total calories burned

    // Return a new Exercise instance using the extracted values from the JSON
    return Exercise(
      activity: json['name'], // Extract activity name
      duration: json['duration_minutes'], // Extract duration in minutes
      burnedCalories: json['total_calories'], // Extract total calories burned
    );
  }

  /// Factory method to create an Exercise instance from a Map.
  ///
  /// This method extracts the relevant data from the provided map
  /// and returns a new instance of the Exercise class.
  /// Save to Firebase
  factory Exercise.fromMap(Map<String, dynamic> map) {
    // Return a new Exercise instance using values from the map
    return Exercise(
      activity:
          map['activity'] ?? '', // Provide a default value if key doesn't exist
      duration:
          map['duration'] ?? 0, // Provide a default value if key doesn't exist
      burnedCalories: map['burnedCalories'] ??
          0, // Provide a default value if key doesn't exist
    );
  }
}
