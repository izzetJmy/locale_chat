// ignore_for_file: public_member_api_docs, sort_constructors_first
class LocationModel {
  PositionModel currentPosition;
  Map<String, PositionModel> locations;
  LocationModel({
    required this.currentPosition,
    required this.locations,
  });

  factory LocationModel.fromJson(Map<String, dynamic> map) {
    var locations = map['locations']
        .map((key, value) => MapEntry(key, PositionModel.fromJson(value)));
    return LocationModel(
        currentPosition: PositionModel.fromJson(map['currentPosition']),
        locations: locations);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'currentPosition': currentPosition.toJson(),
      'locations': locations.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

class PositionModel {
  final String id;
  final double latitude;
  final double longitude;
  final DateTime? timestamp;

  PositionModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
    };
  }

  factory PositionModel.fromJson(Map<String, dynamic> map) {
    return PositionModel(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      timestamp: map['timestamp'],
    );
  }
}
