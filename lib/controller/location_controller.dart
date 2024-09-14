import 'dart:async';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:telpoapp/api/vehicle.dart';
import 'package:telpoapp/controller/auth_controller.dart';
import 'package:telpoapp/model/vehicle.dart';
import 'package:telpoapp/res/strings.dart';

import '../widgets/sundry_components.dart';

class LocationController extends GetxController {
  var isEnabled = false.obs;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 0,
  );

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _handleLocationPermission();
    listenLocationChange();
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

  listenLocationChange() async {
    if (Get.find<AuthController>().user.value!.roles!.contains(CONVEYOR)) {
      StreamSubscription<Position> positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position? position) {
        print(position == null
            ? 'Unknown'
            : '====== update: ${position.latitude.toString()}, ${position.longitude.toString()} ======');
        Map<String, dynamic> data = {
          "currentLat": position!.latitude,
          "currentLng": position.longitude
        };
        if (Get.find<AuthController>().vehicle.value != null) {
          VehicleApi.putVehicle(
                  data, Get.find<AuthController>().vehicle.value!.id!)
              .then((value) {
            print(value.data);
            var v = Vehicle.fromJson(value.data);
            GetStorage().write(VEHICLE_KEY, v.toJson());
            Get.find<AuthController>().vehicle.value = v;
          }).onError((DioException error, stackTrace) {
            print("${error.response!.data}");
          });
        } else {
          print("====== Update Location: Vehicle is null =====");
        }
      });
    }
  }
}
