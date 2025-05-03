import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locale_chat/mixin/error_holder.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/model/error_model.dart';
import 'package:locale_chat/model/location_model.dart';
import 'package:locale_chat/service/location_service.dart';

class LocationChangeNotifier extends AsyncChangeNotifier with ErrorHolder {
  bool? _isValidPermission;
  bool? get isValidPermission => _isValidPermission;
  set isValidPermission(bool? value) {
    _isValidPermission = value;
    notifyListeners();
  }

  PositionModel? _currentPosition;
  PositionModel? get currentPosition => _currentPosition;
  set currentPosition(PositionModel? value) {
    _currentPosition = value;
    debugPrint("currentPosition güncellendi: $_currentPosition");
    notifyListeners(); // Notify listeners when currentPosition changes
  }

  Set<Marker>? _markers;
  Set<Marker>? get markers => _markers;
  set markers(Set<Marker>? value) {
    _markers = value;
    notifyListeners();
  }

  List<LocationModel>? _otherLocations;
  List<LocationModel>? get otherLocations => _otherLocations;
  set otherLocations(List<LocationModel>? value) {
    _otherLocations = value;
    notifyListeners();
  }

  List<PositionModel>? _nearUsersLocaiton;
  List<PositionModel>? get nearUsersLocaiton => _nearUsersLocaiton;
  set nearUsersLocaiton(List<PositionModel>? value) {
    _nearUsersLocaiton = value;
    notifyListeners();
  }

  Map<String, PositionModel>? _locationsMap;
  Map<String, PositionModel>? get locationsMap => _locationsMap;
  set locationsMap(Map<String, PositionModel>? value) {
    _locationsMap = value;
    notifyListeners();
  }

  LocationChangeNotifier() {
    handleLocaitonPermission();
  }

  @override
  AsyncChangeNotifierState state = AsyncChangeNotifierState.idle;
  final LocationService _locationService = LocationService();
  Timer? timer;

  void handleLocaitonPermission() {
    wrapAsync(
      () async {
        _isValidPermission = await _locationService.handleLocationPermissions();
        if (!_isValidPermission!) {
          ErrorModel(
            id: "locationError",
            message: "Konum izinleri verilmedi.",
          );
        }
        notifyListeners();
      },
      ErrorModel(
        id: "locationError",
        message: "Konum izinleri kontrol edilirken bir hata oluştu.",
      ),
    );
  }

  Future<void> getCurrentLocaiton() {
    return wrapAsync(
      () async {
        if (_isValidPermission == true) {
          _currentPosition = await _locationService.getCurrentLocaiton();

          debugPrint(
            "Current position: ${currentPosition?.latitude}, ${currentPosition?.longitude}",
          );
          if (currentPosition == null) {
            ErrorModel(
              id: "locationError",
              message: "Konum alınamadı.",
            );
          }
        } else {
          ErrorModel(
            id: "locationError",
            message: "Konum izinleri verilmedi.",
          );
        }
        notifyListeners();
      },
      ErrorModel(
        id: "locationError",
        message: "Konum alınırken bir hata oluştu.",
      ),
    );
  }

  void saveLocaitonToFirebase(LocationModel locationModel) {
    wrapAsync(
      () async {
        _locationService.saveLocationFirebase(locationModel);
      },
      ErrorModel(id: "id", message: "message"),
    );
  }

  /* void startTimer(int updateSecond) {
    wrapAsync(
      () async {
        markers = await _locationService.startTimer(updateSecond);
        notifyListeners();
      },
      ErrorModel(id: "", message: ""),
    );
  } */

  Future<void> getNearUsersLocation() async {
    return wrapAsync(
      () async {
        _nearUsersLocaiton = await _locationService.getNearUsersLocations(
            _currentPosition!, _otherLocations!);
        debugPrint(
            "Yakındaki kullanıcılarGKLJGLKJGKJDF : $nearUsersLocaiton.toString()");
      },
      ErrorModel(id: "locationError", message: "message"),
    );
  }

  Future<void> listConvertToMap() async {
    Map<String, PositionModel> _positionMap = {};
    try {
      await getNearUsersLocation();
      if (_nearUsersLocaiton == null || _nearUsersLocaiton!.isEmpty) {
        debugPrint("Yakındaki kullanıcı verisi bulunamadı.");
        return;
      }

      _positionMap =
          await _locationService.listConvertToMap(_nearUsersLocaiton!);
      _locationsMap = _positionMap;
      notifyListeners();
    } catch (e) {
      debugPrint("Error in listConvertToMap: $e");
    }
  }

  Future<void> getOtherLocaitons() {
    return wrapAsync(
      () async {
        _otherLocations = await _locationService.getOtherLocations();
        notifyListeners();
      },
      ErrorModel(id: "locationError", message: "message"),
    );
  }

  void addMarker() {
    LocationModel locationModel = LocationModel(
        currentPosition: currentPosition!, locations: locationsMap!);
    markers!.add(
      Marker(
          markerId: MarkerId(
            locationModel.currentPosition.id,
          ),
          position: LatLng(locationModel.currentPosition.latitude,
              locationModel.currentPosition.longitude),
          icon: BitmapDescriptor.defaultMarker),
    );
    notifyListeners();
  }

  Future<void> startTimer(int updateSecond, LocationModel locationModel) async {
    timer = Timer.periodic(
      Duration(seconds: updateSecond),
      (timer) {
        getCurrentLocaiton();
        addMarker();
      },
    );
    notifyListeners();
  }

  Future<void> stopTimer() async {
    timer!.cancel();
    notifyListeners();
  }

  List<ErrorModel> getLocationErrors(String errorName) {
    return errors.where((error) => error.id == errorName).toList();
  }
}
