class City {
  final String name;
  final double latitude;
  final double longitude;
  final String? country;

  City({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      country: json['country'] as String?,
    );
  }
}
