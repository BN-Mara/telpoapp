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

  updatingRoute(int vehicleId) {
    updating_process.value = true;
    RouteApi.getCurrentRoute(vehicleId).then((value) {
      updating_process.value = false;
      currentRoute.value = Itineraire.fromJson(value.data);
      update();
    }).onError((DioException error, stackTrace) {
      updating_process.value = true;
      print('${error.response!.data}');
    });
  }

  final stream = Stream<int>.periodic(const Duration(seconds: 1));
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    stream.takeWhile((_) => true).forEach((element) async {
      updatingRoute(1);
    });
  }
}
