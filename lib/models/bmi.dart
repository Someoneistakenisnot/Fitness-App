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
  //TODO implement Bmi.fromJson
  factory Bmi.fromJson(Map<String, dynamic> json){

    print(json['bodyMassIndex']['value']);
    print(json['bodyMassIndex']['conclusion']);
    print(json['idealBodyWeight']['peterson']['metric']['value']);
    print(json['bodyFatPercentage']['bmi']['value']);
    print(json['totalDailyEnergyExpenditure']['bmi']['calories']['value']);

    return Bmi(
      bmi: json['bodyMassIndex']['value'],
      bmiConclusion: json['bodyMassIndex']['conclusion'],
      idealBodyWt: json['idealBodyWeight']['peterson']['metric']['value'],
      bodyFatPercent: json['bodyFatPercentage']['bmi']['value'],
      totalDailyEE: json['totalDailyEnergyExpenditure']['bmi']['calories']['value'],
    );
  }
}
