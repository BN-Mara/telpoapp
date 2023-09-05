import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:telpoapp/api/route.dart';
import 'package:telpoapp/controller/auth_controller.dart';
import 'package:telpoapp/controller/location_controller.dart';
import 'package:telpoapp/model/itineraire.dart';
import 'package:telpoapp/res/strings.dart';

class RouteController extends GetxController {
  var fromContrl = "".obs;
  var toContrl = "".obs;
  var passangenrContrl = TextEditingController().obs;
  var increasePassen = TextEditingController().obs;
  var locationController = Get.find<LocationController>();
  var auth = Get.find<AuthController>();
  var process_route = false.obs;
  var activeRoute = Rxn<Itineraire>();

  setCurrentRoute() async {
    process_route.value = true;

    var pose = await locationController.getCurrentPosition();
    var itineraire = Itineraire(
        conveyor: "/api/users/1", //auth.user.value!.id,
        origine: fromContrl.value,
        destination: toContrl.value,
        startLat: pose.latitude,
        startLng: pose.longitude,
        startingTime: DateTime.now().toIso8601String(),
        deviceId: GetStorage().read(DEVICE_ID),
        isActive: true,
        vehicle: '/api/vehicles/1',
        passengers: int.parse(passangenrContrl.value.text));
    print(itineraire.toJson());
    //activeRoute.value = itineraire;
    process_route.value = false;
    //Get.back();

    RouteApi.postCurrentRoute(itineraire.toJson()).then((value) {
      process_route.value = false;
      activeRoute.value = Itineraire.fromJson(value.data);
      //start active route
    }).onError((DioException error, stackTrace) {
      process_route.value = false;
      print("route:${error.response!.data}");
    }).whenComplete(() {
      process_route.value = false;
    });
  }

  endCurrentRoute() async {
    process_route.value = true;
    var pose = await locationController.getCurrentPosition();
    activeRoute.value!.endLng = pose.longitude;
    activeRoute.value!.endLat = pose.latitude;
    activeRoute.value!.isActive = false;
    activeRoute.value!.endingTime = DateTime.now().toIso8601String();
    //process_route.value = false;
    //activeRoute.value = null;
    print(activeRoute.value!.toJson());

    RouteApi.putCurrentRoute(activeRoute.value!.toJson()).then((value) {
      activeRoute.value = null;
      process_route.value = false;
    }).onError((DioException error, stackTrace) {
      print("update: ${error.response!.data}");
      process_route.value = false;
    });
  }

  void addPassengers(String text) {
    activeRoute.value!.passengers =
        activeRoute.value!.passengers! + int.parse(text);
    Map<String, dynamic> rt = {
      "id": activeRoute.value!.id,
      "passengers": activeRoute.value!.passengers
    };
    RouteApi.putCurrentRoute(rt).then((value) {
      print(value.data);
    }).onError((DioException error, stackTrace) {
      print("update: ${error.response!.data}");
      process_route.value = false;
    });
  }
}
