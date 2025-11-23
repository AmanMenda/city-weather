class City {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;

  City({
    this.id,
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

  // Database methods
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'] as int?,
      name: map['name'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      country: map['country'] as String?,
    );
  }

  bool isSameLocation(City other, {double tolerance = 0.01}) {
    return (latitude - other.latitude).abs() < tolerance &&
        (longitude - other.longitude).abs() < tolerance;
  }
}
