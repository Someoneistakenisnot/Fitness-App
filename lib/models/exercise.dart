class Exercise {
  late final String activity;
  late final int duration;
  final int burnedCalories;

  Exercise({
    required this.activity,
    required this.duration,
    required this.burnedCalories,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    print(json['name']);
    print(json['duration_minutes']);
    print(json['total_calories']);
    return Exercise(
        activity: json['name'],
        duration: json['duration_minutes'],
        burnedCalories: json['total_calories']);
  }
}
