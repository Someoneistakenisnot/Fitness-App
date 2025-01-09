class Bmi {
  final double bmi;
  final String bmiConclusion;
  final double idealBodyWt;
  final double bodyFatPercent;
  final int totalDailyEE;

  Bmi({
    required this.bmi,
    required this.bmiConclusion,
    required this.idealBodyWt,
    required this.bodyFatPercent,
    required this.totalDailyEE,
  });

  factory Bmi.fromJson(Map<String, dynamic> json) {
    return Bmi(
      bmi: json['bmi'],
      bmiConclusion: json['bmiConclusion'],
      idealBodyWt: json['idealBodyWt'],
      bodyFatPercent: json['bodyFatPercent'],
      totalDailyEE: json['totalDailyEE'],
    );
  }
  //TODO implement Bmi.fromJson
}
