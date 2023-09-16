import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:telpoapp/controller/check_route.dart';
import 'package:telpoapp/controller/location_controller.dart';
import 'package:telpoapp/controller/route_controller.dart';
import 'package:telpoapp/res/strings.dart';
import 'package:telpoapp/screens/homeScreen.dart';
import 'package:telpoapp/screens/loginScreen.dart';

import 'controller/auth_controller.dart';

var DIO = Dio();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  AuthController pagesController = Get.put(AuthController());
  LocationController locationController = Get.put(LocationController());
  RouteController routeController = Get.put(RouteController());
  CheckRouteController ckController = Get.put(CheckRouteController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      //home: const HomeScreen(),
    );
  }
}
