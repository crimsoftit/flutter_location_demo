import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as location;
import 'package:location/location.dart';
import 'package:location_demo/controllers/location_controller.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class LocationServices {
  LocationServices.init();

  static LocationServices instance = LocationServices.init();

  final location.Location _location = location.Location();

  final geocoding = Geolocator();

  Future<bool> checkForServiceAvailability() async {
    bool locationIsEnabled = await _location.serviceEnabled();

    if (locationIsEnabled) {
      return Future.value(true);
    }

    locationIsEnabled = await _location.requestService();

    if (locationIsEnabled) {
      return Future.value(true);
    }

    return Future.value(false);
  }

  Future<bool> locationServicePermitted() async {
    PermissionStatus permissionStatus = await _location.hasPermission();

    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();

      if (permissionStatus == PermissionStatus.granted) {
        // -- access device location --
        return true;
      }
      return false;
    }

    if (permissionStatus == PermissionStatus.deniedForever) {
      Get.snackbar('location permission required',
          'we need location services to protect our vendors and customers!',
          onTap: (snack) {
        permission_handler.openAppSettings();
      }).show();
      return false;
    }

    return Future.value(true);
  }

  Future<void> getUserLocation(
      {required LocationController locationController}) async {
    locationController.updateLocationAccess(true);

    if (!await checkForServiceAvailability()) {
      locationController.errorDesc.value = 'location services disabled!';
      locationController.updateLocationAccess(false);
      return;
    }

    if (!await locationServicePermitted()) {
      locationController.errorDesc.value = 'location permission denied!';
      locationController.updateLocationAccess(false);
      return;
    }

    final LocationData locationData = await _location.getLocation();

    locationController.updateUserLocation(locationData);

    locationController.updateLocationAccess(false);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        locationController.userLocation.value!.latitude!,
        locationController.userLocation.value!.longitude!);

    var userAddress = placemarks.first;

    locationController.uAddress.value =
        'locality:${userAddress.locality}, subLocality:${userAddress.subLocality}, adminArea:${userAddress.administrativeArea}, subAdminArea:${userAddress.subAdministrativeArea}, addressLine:${userAddress.administrativeArea}, thoroughfare:${userAddress.thoroughfare}, subThoroughfare:${userAddress.subThoroughfare}, street:${userAddress.street}, name:${userAddress.name}, postalCode:${userAddress.postalCode}';

    print(locationController.uAddress.value);

    //return userAddress;
  }
}
