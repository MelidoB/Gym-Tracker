// lib/models/weather.dart
class Weather {
  final String condition;
  final bool recommendIndoor;

  Weather({
    this.condition = 'Sunny',
    this.recommendIndoor = false,
  });

  Map<String, dynamic> toJson() => {
        'condition': condition,
        'recommendIndoor': recommendIndoor,
      };

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        condition: json['condition'] ?? 'Sunny',
        recommendIndoor: json['recommendIndoor'] ?? false,
      );
}