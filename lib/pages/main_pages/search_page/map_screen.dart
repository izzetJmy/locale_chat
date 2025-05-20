import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locale_chat/comopnents/my_circular_progress_Indicator.dart';
import 'package:locale_chat/model/location_model.dart';
import 'package:locale_chat/provider/auth_change_notifier/auth_change_notifier.dart';
import 'package:locale_chat/provider/location_change_notifier/locaiton_change_notifier.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userID = FirebaseAuth.instance.currentUser!.uid;
  late AuthChangeNotifier authChangeNotifier;
  late LocationChangeNotifier locationChangeNotifier;

  @override
  void initState() {
    super.initState();
    authChangeNotifier = AuthChangeNotifier();
    locationChangeNotifier = LocationChangeNotifier();
    loadLocation();
  } // AuthChangeNotifier'ı başlatın

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  // void getUserInfo() {
  //   authChangeNotifier.getUserInfo(_userID).then((user) {
  //     if (user != null) {
  //       debugPrint('User Info: ${user.toJson()}');
  //     } else {
  //       debugPrint('User not found');
  //     }
  //   }).catchError((error) {
  //     debugPrint('Error fetching user info: $error');
  //   });
  // }

  // Future<Expanded> getCustomIcon() async {
  //   return Expanded(
  //     child: ProfileInfo(
  //       image_path: authChangeNotifier.user?.profilePhoto != null &&
  //               authChangeNotifier.user!.profilePhoto.isNotEmpty
  //           ? authChangeNotifier.user!.profilePhoto
  //           : ImagePath.user_avatar,
  //     ),
  //   );
  // }

  // Future<Uint8List> getFirebaseImage(String downloadUrl) async {
  //   final response = await http.get(Uri.parse(downloadUrl));
  //   if (response.statusCode == 200) {
  //     return response.bodyBytes; // Uint8List olarak döner
  //   } else {
  //     throw Exception("Resim yüklenemedi");
  //   }
  // }

  // Future<BitmapDescriptor?> _getMarkerIcon(String imageUrl) async {
  //   try {
  //     // Firebase'den resmi al
  //     Uint8List markerIconBytes = await getFirebaseImage(imageUrl);

  //     // Resmi BitmapDescriptor'a dönüştür
  //     return BitmapDescriptor.bytes(markerIconBytes);
  //   } catch (e) {
  //     debugPrint("Resim alınırken hata: $e");
  //     return null;
  //   }
  // }
  void loadLocation() async {
    setState(() {});
    try {
      var documentSnapshot =
          await _firestore.collection('location').doc(_userID).get();
      PositionModel? currentPosition = documentSnapshot
                  .data()?['currentPosition'] !=
              null
          ? PositionModel.fromJson(documentSnapshot.data()!['currentPosition'])
          : null;

      // Get current location regardless of whether it exists in Firebase
      await locationChangeNotifier.getCurrentLocaiton();

      if (currentPosition == null) {
        // If no location exists in Firebase, save the current location
        if (locationChangeNotifier.currentPosition != null) {
          await _firestore.collection('location').doc(_userID).set({
            'currentPosition': locationChangeNotifier.currentPosition!.toJson(),
            'locations': {}
          });
          debugPrint("Initial location saved to Firebase");
        }
      }

      // Continue with getting other locations and nearby users
      await locationChangeNotifier.getOtherLocaitons();
      await locationChangeNotifier.getNearUsersLocation();
      await locationChangeNotifier.listConvertToMap();
    } catch (e) {
      debugPrint('Konum yüklenirken hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await locationChangeNotifier.getCurrentLocaiton();

            await locationChangeNotifier.listConvertToMap();
            if (locationChangeNotifier.locationsMap != null) {
              _firestore.collection('location').doc(_userID).update(
                {
                  'currentPosition':
                      locationChangeNotifier.currentPosition!.toJson(),
                  'locations': locationChangeNotifier.locationsMap!.map(
                    (key, value) => MapEntry(key, value.toJson()),
                  )
                },
              );

              debugPrint("Nearby users saved successfully.");
            }
            debugPrint("Failed to save nearby users.");
          } catch (e) {
            debugPrint("Error: $e");
          }
        },
        child: const Icon(Icons.search),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('location').doc(_userID).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: MyCircularProgressIndicator());
          }

          // If we're still waiting for the first data, show loading
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            // Try to get current location while waiting
            locationChangeNotifier.getCurrentLocaiton().then((_) {
              if (locationChangeNotifier.currentPosition != null) {
                _firestore.collection('location').doc(_userID).set({
                  'currentPosition':
                      locationChangeNotifier.currentPosition!.toJson(),
                  'locations': {}
                });
              }
            });
            return Center(child: MyCircularProgressIndicator());
          }

          var locationData = snapshot.data!.data() as Map<String, dynamic>;

          try {
            var currentPosition =
                PositionModel.fromJson(locationData['currentPosition']);

            LatLng initialPosition =
                LatLng(currentPosition.latitude, currentPosition.longitude);

            return GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 14.0,
              ),
              mapType: MapType.hybrid,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: {
                Marker(
                    markerId: MarkerId(currentPosition.id),
                    position: initialPosition,
                    infoWindow: InfoWindow(
                      title: 'Current Location',
                      snippet:
                          '${currentPosition.latitude}, ${currentPosition.longitude}',
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue)),
              },
            );
          } catch (e) {
            debugPrint('Error parsing location data: $e');
            return Center(child: MyCircularProgressIndicator());
          }
        },
      ),
    );
  }
}
