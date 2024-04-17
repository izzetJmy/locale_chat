// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:geolocator/geolocator.dart';

class LocationModel {
  String id;
  Position currentPosition;
  Map<String, Position> locations;
  LocationModel({
    required this.id,
    required this.currentPosition,
    required this.locations,
  });
}
