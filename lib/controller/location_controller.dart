import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../widgets/sundry_components.dart';

class LocationController extends GetxController {
  var isEnabled = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _handleLocationPermission();
    /*stream.takeWhile((_) => true).forEach((element) async {
      updatingRoute(1);
    });*/
  }

  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      popSnackError(
          title: 'Error',
          message:
              'Location services are disabled. Please enable the services');
      isEnabled.value = false;

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        popSnackError(
            title: "Error!", message: 'Location permissions are denied');
        isEnabled.value = false;

        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      popSnackError(
          title: 'Error!',
          message:
              'Location permissions are permanently denied, we cannot request permissions.');
      isEnabled.value = false;

      return false;
    }
    isEnabled.value = true;
    return true;
  }
}
