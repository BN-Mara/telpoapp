import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:telpoapp/api/route.dart';
import 'package:telpoapp/model/itineraire.dart';
import 'package:flutter/material.dart';

class CheckRouteController extends GetxController {
  var updating_process = false.obs;
  var currentRoute = Rxn<Itineraire>();
  bool done = false;

  Itineraire? getCurrent() {
    return currentRoute.value;
  }

  updatingRoute(int vehicleId) async {
    updating_process.value = true;
    RouteApi.getCurrentRoute(vehicleId).then((value) async {
      print("in updating!");
      updating_process.value = false;
      var list = await Itineraire.itinerairesfromJson(value.data);
      currentRoute.value = list.last;
      print(currentRoute.toJson());

      update();
      Future.delayed(Duration(seconds: 5), checkingRoute);
      //checkingRoute();
    }).onError((DioException error, stackTrace) {
      updating_process.value = false;
      if (error.response != null) {
        print('${error.response!.data}');
      } else {
        print(error);
      }
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

    print("updating...");
    updatingRoute(1);
  }
}
