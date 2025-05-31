import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locale_chat/model/location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateTime _nowTime = DateTime.now();
  Timer? timer;

  //LOCATION PERMISSIONS
  Future<bool> handleLocationPermissions() async {
    try {
      // Check SharedPreferences first
      final prefs = await SharedPreferences.getInstance();
      final hasRequestedLocationPermission =
          prefs.getBool('hasRequestedLocationPermission') ?? false;

      if (hasRequestedLocationPermission) {
        // If we've already requested permission, just check the current status
        LocationPermission permission = await Geolocator.checkPermission();
        return permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever;
      }

      LocationPermission permission;

      // Check if location services are enabled
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        debugPrint("Location services are disabled.");
        return false;
      }

      // Check the current permission status
      permission = await Geolocator.checkPermission();
      debugPrint("Current permission: $permission");

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        debugPrint("Requested permission: $permission");

        // Save that we've requested permission
        await prefs.setBool('hasRequestedLocationPermission', true);

        if (permission == LocationPermission.denied) {
          debugPrint("Location permissions are denied.");
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint("Location permissions are permanently denied.");
        return false;
      }

      debugPrint("Location permissions granted.");
      return true;
    } catch (e) {
      debugPrint("Error in handleLocationPermissions: $e");
      return false;
    }
  }

  //GET CURRENT LOCATION
  Future<PositionModel?> getCurrentLocaiton() async {
    try {
      Position currentPosition1 = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      debugPrint(
          "Current Position: ${currentPosition1.latitude}, ${currentPosition1.longitude}");
      PositionModel currentPosition = PositionModel(
          id: _auth.currentUser!.uid,
          latitude: currentPosition1.latitude,
          longitude: currentPosition1.longitude,
          timestamp: _nowTime);

      return currentPosition;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //SAVE LOCATION IN FIREBASE
  Future<void> saveLocationFirebase(LocationModel locationModel) async {
    await _firestore
        .collection('location')
        .doc(locationModel.currentPosition.id)
        .set(locationModel.toJson());
  }

  //GET OTHER LOCATION
  Future<List<LocationModel>> getOtherLocations() async {
    List<LocationModel> otherLocations = [];
    try {
      var querySnapshot = await _firestore.collection('location').get();
      for (var doc in querySnapshot.docs) {
        var location = LocationModel.fromJson(doc.data());
        otherLocations.add(location);
      }
      return otherLocations;
    } catch (e) {
      debugPrint(e.toString()); //error showDialog gösterilecek
      return [];
    }
  }

  //GET NEAR USERS
  Future<List<PositionModel>> getNearUsersLocations(
      PositionModel currentPosition, List<LocationModel> otherLocations) async {
    List<PositionModel> nearUsersPositions = [];
    double radiusInMeters = 100.0;
    try {
      List<LocationModel> allUsers = otherLocations;
      //burda yapılan işlemin amacı filtirelemyi daha kısa mesafeye indirerek performansı artırmak
      allUsers = allUsers
          .where((location) =>
              location.currentPosition.latitude >=
                  currentPosition.latitude - 0.01 &&
              location.currentPosition.latitude <=
                  currentPosition.latitude + 0.01 &&
              location.currentPosition.longitude >=
                  currentPosition.longitude - 0.01 &&
              location.currentPosition.longitude <=
                  currentPosition.longitude + 0.01)
          .toList();
      for (var location in allUsers) {
        if (location.currentPosition.id != currentPosition.id) {
          //burda her kullanıcın konumunu current posiitionun konumunun arasındaki mesafeyi buluyoruz
          double distance = Geolocator.distanceBetween(
              currentPosition.latitude,
              currentPosition.longitude,
              location.currentPosition.latitude,
              location.currentPosition.longitude);

          //burda istenilen mesafe içerisindeki kullanıcıların konum bilgisini PositionModele çevirerek listeye ekler
          if (distance <= radiusInMeters) {
            nearUsersPositions.add(PositionModel(
                id: location.currentPosition.id,
                timestamp: DateTime.now(),
                latitude: location.currentPosition.latitude,
                longitude: location.currentPosition.longitude));
          }
        }
      }
      return nearUsersPositions;
    } catch (e) {
      debugPrint(e.toString()); //error showDialog gösterilecek
      return [];
    }
  }

//CONVERT LIST TO MAP
  Future<Map<String, PositionModel>> listConvertToMap(
      List<PositionModel> nearUsersLocations) async {
    Map<String, PositionModel> positionMap = {};
    try {
      for (var position in nearUsersLocations) {
        positionMap[position.id] = position;
      }
      return positionMap;
    } catch (e) {
      debugPrint(e.toString()); //error showDialog gösterilecek
      return {};
    }
  }

/* //CREATE LOCATION MODEL LOCATION AND SAVE FIREBASE
  Future<LocationModel?> getLocationModel() async {
    String userID = _auth.currentUser != null ? _auth.currentUser!.uid : "";
    try {
      PositionModel? currentPosition = await getCurrentLocaiton();

      //CURRENT USERS LOCATION INFO
      PositionModel currentPositionModel = PositionModel(
          id: userID,
          latitude: currentPosition!.latitude,
          longitude: currentPosition.longitude,
          timestamp: _nowTime);

      //CURRENT AND NEAR USERS LOCATION INFO
      Map<String, PositionModel> locationsMap =
          await listConvertToMap(currentPositionModel);
      LocationModel locationModel = LocationModel(
        currentPosition: currentPositionModel,
        locations: locationsMap,
      );

      await saveLocationFirebase(locationModel);
      return locationModel;
    } catch (e) {
      Future.error(e); //error showDialog gösterilecek
      return null;
    }
  } */

  /*  //START TIMER
  Future<Set<Marker>> startTimer(int updateSecond) async {
    Set<Marker> markers = {};
    timer = Timer.periodic(
      //verdiğimiz saniye aralığında burdaki methodaları çağıracak
      Duration(seconds: updateSecond),
      (timer) async {
        try {
          PositionModel? currentPosition = await getCurrentLocaiton();
          if (currentPosition != null) {
            LocationModel? locationModel = await getLocationModel();
            markers = await addMarker(locationModel!);
          }
        } catch (e) {
          Future.error(
              "Error updating location: $e"); //error showDialog gösterilecek
        }
      },
    );
    return markers;
  }
 */

  /*  //STOP TIMER
  Future<void> stopTimer() async {
    timer?.cancel();
  } */

  /*  //ADD MARKER
  Future<Set<Marker>> addMarker(LocationModel locationModel) async {
    //haritada kullanacağımız markerlerde google_maps_flutter paketinde Marker classından nesneler üretmemizi istiyor bende burda üretiyorum
    Set<Marker> newMarkers = {
      Marker(
        markerId: MarkerId(
          locationModel.currentPosition.id.toString(),
        ),
        position: LatLng(locationModel.currentPosition.latitude,
            locationModel.currentPosition.longitude),
        icon: BitmapDescriptor.defaultMarker,
      ),
    };
    locationModel.locations.forEach(
      (id, poition) {
        newMarkers.add(
          Marker(
            markerId: MarkerId(id),
            position: LatLng(poition.latitude, poition.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(2),
          ),
        );
      },
    );
    return newMarkers;
  }
 */
}
