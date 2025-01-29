class FitnessUser {
  int weight;
  int height;
  String gender;
  int age;
  String exercise;

  //TODO add gender, age, exercise_level

  FitnessUser({
    required this.weight,
    required this.height,
    required this.gender,
    required this.age,
    required this.exercise,
  });

  factory FitnessUser.fromMap(Map<String, dynamic> map) {
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
