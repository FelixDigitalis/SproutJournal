// plants from https://media.kiepenkerl.de/medienarchiv/die-besten-aussaat-tipps/6/ with little chacges from own experience

class Plant {
  final String germanName;
  final int germinationTemperatureMin;
  final int germinationTemperatureMax;
  final int germinationDurationMin;
  final int germinationDurationMax;
  final double sowingDepthMin;
  final double sowingDepthMax;
  final int minSowBy;
  final int maxSowBy;

  Plant({
    required this.germanName,
    required this.germinationTemperatureMin,
    required this.germinationTemperatureMax,
    required this.germinationDurationMin,
    required this.germinationDurationMax,
    required this.sowingDepthMin,
    required this.sowingDepthMax,
    required this.minSowBy,
    required this.maxSowBy,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      germanName: json['GermanName'],
      germinationTemperatureMin: json['GerminationTemperatureMin'],
      germinationTemperatureMax: json['GerminationTemperatureMax'],
      germinationDurationMin: json['GerminationDurationMin'],
      germinationDurationMax: json['GerminationDurationMax'],
      sowingDepthMin: json['SowingDepthMin'].toDouble(),
      sowingDepthMax: json['SowingDepthMax'].toDouble(),
      minSowBy: json['MinSowBy'],
      maxSowBy: json['MaxSowBy'],
    );
  }
}
