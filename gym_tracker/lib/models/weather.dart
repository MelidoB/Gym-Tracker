class Weather {
  String condition;
  bool recommendIndoor;

  Weather({
    required this.condition,
    this.recommendIndoor = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'recommendIndoor': recommendIndoor,
    };
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      condition: json['condition'] ?? 'Sunny',
      recommendIndoor: json['recommendIndoor'] ?? false,
    );
  }
}