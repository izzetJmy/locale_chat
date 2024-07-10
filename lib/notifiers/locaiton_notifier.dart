import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locale_chat/mixin/error_holder.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/model/error_model.dart';
import 'package:locale_chat/model/location_model.dart';
import 'package:locale_chat/service/location_service.dart';

class LocationChangeNotifier extends AsyncChangeNotifier with ErrorHolder {
  LocationService _locationService = LocationService();
  Timer? timer;

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
    notifyListeners();
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

  @override
  AsyncChangeNotifierState state = AsyncChangeNotifierState.idle;

  void handleLocaitonPermission() {
    wrapAsync(
      () async {
        isValidPermission = await _locationService.handleLocationPermissions();
        notifyListeners();
      },
      ErrorModel(id: "Locaiton error ID", message: "Can not handle permission"),
    );
  }

  void getCurrentLocaiton() {
    wrapAsync(
      () async {
        if (isValidPermission!) {
          currentPosition = await _locationService.getCurrentLocaiton();
          notifyListeners();
        } else {
          return null;
        }
      },
      ErrorModel(id: "id", message: ""),
    );
  }

  void saveLocaitonToFirebase() {
    LocationModel locationModel = LocationModel(
        currentPosition: currentPosition!, locations: locationsMap!);
    wrapAsync(
      () async {
        await _locationService.saveLocationFirebase(locationModel);
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

  void getOtherLocaitons() {
    wrapAsync(
      () async {
        otherLocations = await _locationService.getOtherLocations();
        notifyListeners();
      },
      ErrorModel(id: "", message: "message"),
    );
  }

  void getNearUsersLocation() {
    wrapAsync(
      () async {
        nearUsersLocaiton =
            await _locationService.getNearUsersLocations(currentPosition!);
      },
      ErrorModel(id: "id", message: "message"),
    );
  }

  Future<void> listConvertToMap(PositionModel currentPositionModel) async {
    Map<String, PositionModel> positionMap = {};
    try {
      getNearUsersLocation();
      for (var position in nearUsersLocaiton!) {
        positionMap[position.id] = position;
      }
      locationsMap = positionMap;
      notifyListeners();
    } catch (e) {
      Future.error(e); //error showDialog gösterilecek
      return;
    }
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
}
