import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:telpoapp/api/route.dart';
import 'package:telpoapp/controller/auth_controller.dart';
import 'package:telpoapp/controller/route_controller.dart';
import 'package:telpoapp/model/itineraire.dart';
import 'package:flutter/material.dart';
import 'package:telpoapp/model/line_string.dart';
import 'package:telpoapp/model/place.dart';
import 'package:telpoapp/res/strings.dart';

class CheckRouteController extends GetxController {
  var updating_process = false.obs;
  var currentRoute = Rxn<Itineraire>();
  bool done = false;
  var routeContrller = Get.find<RouteController>();
  var markers = <Marker>{}.obs;
  var line = Rxn<LineString>();
  var polyPoints = <LatLng>[].obs;
  var polyLines = <Polyline>{}.obs;
  var process_route_end = false.obs;
  var hasData = false.obs;
  var passagerCtr = TextEditingController().obs;
  var auth = Get.find<AuthController>();

  Itineraire? getCurrent() {
    return currentRoute.value;
  }

  updatingRoute(int vehicleId) async {
    updating_process.value = true;
    RouteApi.getCurrentRoute(vehicleId).then((value) async {
      print("in updating!");
      updating_process.value = false;
      try {
        var list = await Itineraire.itinerairesfromJson(value.data);
        currentRoute.value = list.last;
        print(currentRoute.toJson());
        if (currentRoute.value != null && !hasData.value) {
          routeContrller.activeRoute.value = currentRoute.value;
          getData();
        }

        update();
        Future.delayed(Duration(seconds: 5), checkingRoute);
      } catch (e) {
        print("error list route ");
        currentRoute.value = null;
        hasData.value = false;
        polyLines.clear();
        markers.clear();
        Future.delayed(Duration(seconds: 5), checkingRoute);
      }
      //checkingRoute();
    }).onError((DioException error, stackTrace) {
      updating_process.value = false;
      if (error.response != null) {
        print('${error.response!.data}');
      } else {
        print(error);
      }
      Future.delayed(Duration(seconds: 5), checkingRoute);
    });
  }

  //final stream = Stream<int>.periodic(const Duration(seconds: 1));
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkingRoute();
    /*stream.takeWhile((_) => true).forEach((element) async {
      updatingRoute(1);
    });*/
  }

  void checkingRoute() async {
    /*final Stream _myStream =
        Stream.periodic(const Duration(seconds: 3), (int count) {
      // Do something and return something here
      print("updating...");
      updatingRoute(1);
    });*/
    print("first try");
    if (auth.user.value != null &&
        auth.user.value!.roles!.contains('ROLE_DRIVER')) {
      print("updating...");
      if (auth.vehicle.value != null) {
        updatingRoute(auth.vehicle.value!.id!);
      }
    }
  }

  Future getData() async {
    if (currentRoute.value != null) {
      var or = routeContrller.getPlaceByName(currentRoute.value!.origine!);
      var ds = routeContrller.getPlaceByName(currentRoute.value!.destination!);
      RouteApi.getDataRoute(or.first, ds.first).then((value) {
        print("inside");
        print(value.data);
        try {
          line.value =
              LineString(value.data['features'][0]['geometry']['coordinates']);
          for (int i = 0; i < line.value!.lineString.length; i++) {
            polyPoints.value.add(LatLng(
                line.value!.lineString[i][1], line.value!.lineString[i][0]));
          }
          markers.value.add(
            Marker(
              markerId: const MarkerId("Depart"),
              position: LatLng(or.first.latitude!, or.first.longitude!),
              infoWindow: InfoWindow(
                title: "Depart",
                snippet: or.first.name,
              ),
            ),
          );
          markers.value.add(Marker(
            markerId: MarkerId("Destination"),
            position: LatLng(ds.first.latitude!, ds.first.longitude!),
            infoWindow: InfoWindow(
              title: "Destination",
              snippet: ds.first.name,
            ),
          ));
          Polyline polyline = Polyline(
            polylineId: const PolylineId("polyline"),
            color: Colors.lightBlue,
            points: polyPoints.value,
          );
          if (polyPoints.value.isNotEmpty) {
            print(polyline.points);
            hasData.value = true;
            polyLines.value.add(polyline);
            update();
          }
          return value.data;
        } catch (ex) {
          print(ex);
        }
      }).onError((DioException error, stackTrace) {
        print(error);
        print("error o ${error.response!.data}");
      });
    }
  }

  endCurrentRoute() async {
    process_route_end.value = true;
    //var pose = await locationController.getCurrentPosition();
    //currentRoute.value!.endLng = pose.longitude;
    //currentRoute.value!.endLat = pose.latitude;
    currentRoute.value!.isActive = false;
    currentRoute.value!.endingTime = DateTime.now().toIso8601String();
    currentRoute.value!.status = COMPLETE_STATE;
    currentRoute.value!.driverPassengers = int.parse(passagerCtr.value.text);

    //process_route.value = false;
    //activeRoute.value = null;

    print(currentRoute.value!.toJson());

    RouteApi.putCurrentRoute(currentRoute.value!.toJson()).then((value) {
      //destPlaces.value = getPlaceByName(currentRoute.value!.destination!);
      currentRoute.value = null;
      hasData.value = false;
      polyLines.clear();
      markers.clear();
      passagerCtr.value.clear();
      process_route_end.value = false;
    }).onError((DioException error, stackTrace) {
      print("update: ${error.response!.data}");
      process_route_end.value = false;
    });
  }
}
