class Plant {
  final int id;
  final String germanName;
  final String englishName;
  final int germinationTemperatureMin;
  final int germinationTemperatureMax;
  final int germinationDurationMin;
  final int germinationDurationMax;
  final double sowingDepthMin;
  final double sowingDepthMax;
  final int minSowBy;
  final int maxSowBy;

  Plant({
    required this.id,
    required this.germanName,
    required this.englishName,
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
      id: json['id'],
      germanName: json['GermanName'],
      englishName: json['EnglishName'],
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

  String intToMonth(int month) {
    Map<int, String> months = {
      1: 'Januar',
      2: 'Februar',
      3: 'März',
      4: 'April',
      5: 'Mai',
      6: 'Juni',
      7: 'Juli',
      8: 'August',
      9: 'September',
      10: 'Oktober',
      11: 'November',
      12: 'Dezember'
    };
    return months[month] ?? 'Ungültige Monatszahl';
  }
}
