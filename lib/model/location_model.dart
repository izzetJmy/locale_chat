// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  PositionModel currentPosition;
  Map<String, PositionModel> locations;
  LocationModel({
    required this.currentPosition,
    required this.locations,
  });
  factory LocationModel.fromJson(Map<String, dynamic> map) {
    var locations = (map['locations'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(key, PositionModel.fromJson(value)),
        ) ??
        {}; // Null ise boş bir map döndürün

    return LocationModel(
      currentPosition: map['currentPosition'] != null
          ? PositionModel.fromJson(map['currentPosition'])
          : PositionModel(
              id: '',
              latitude: 0.0,
              longitude: 0.0,
              timestamp: DateTime.now(),
            ), // Null ise varsayılan bir PositionModel döndürün
      locations: locations,
    );
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
  final DateTime timestamp;

  PositionModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
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
      id: map['id'] ?? '', // Varsayılan değer ekleyin
      latitude:
          (map['latitude'] as num?)?.toDouble() ?? 0.0, // Null ise 0.0 döndürün
      longitude: (map['longitude'] as num?)?.toDouble() ??
          0.0, // Null ise 0.0 döndürün
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ??
          DateTime.now(), // Null ise şu anki zamanı döndürün
    );
  }
}
