import 'dart:async';

import 'package:location/location.dart';
import 'package:user_location/datamodals/user_location.dart';

class LocationService {
  late UserLocation _currentLocation;
  Location location = Location();
  StreamController<UserLocation> _locationController =
  StreamController<UserLocation>.broadcast();

  LocationService(){
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          _locationController.add(UserLocation(
            latitude: locationData.latitude!,
            longitude: locationData.longitude!,
          ));
        });
      }
    });
  }
  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude!,
        longitude: userLocation.longitude!,
      );
    } catch (e) {
      print('Could not get the location: $e');
    }
    return _currentLocation;
  }
}