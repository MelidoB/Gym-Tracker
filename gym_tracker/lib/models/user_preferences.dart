class UserPreferences {
  String? name;
  bool useKg;

  UserPreferences({this.name = '', this.useKg = false});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'useKg': useKg,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      name: json['name'] ?? '',
      useKg: json['useKg'] ?? false,
    );
  }
}
