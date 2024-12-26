import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  // -- variables --
  final RxBool processingLocationAccess = RxBool(false);
  final RxString errorDesc = ''.obs;
  final Rx<LocationData?> userLocation = Rx<LocationData?>(null);
  final RxString uAddress = RxString('');

  void updateLocationAccess(bool hasAccess) {
    processingLocationAccess.value = hasAccess;
  }

  void updateUserLocation(LocationData locationData) {
    userLocation.value = locationData;
  }
}
