import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:telpoapp/controller/check_route.dart';
import 'package:telpoapp/controller/location_controller.dart';
import 'package:telpoapp/controller/route_controller.dart';
import 'package:telpoapp/res/colors.dart';
import 'package:telpoapp/res/strings.dart';
import 'package:telpoapp/screens/homeScreen.dart';
import 'package:telpoapp/screens/loginScreen.dart';

import 'controller/auth_controller.dart';

var DIO = Dio();
/*DIO.interceptors.add(InterceptorsWrapper(
       onError: (error) async {
          if (error.response?.statusCode == 403 ||
              error.response?.statusCode == 401) {
              await refreshToken();
              return _retry(error.request);
            }
            return error.response;
        }));*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  //DIO.interceptors.add(DioInterceptor());
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
        primarySwatch: materialPrimary,
      ),
      home: LoginScreen(),
      //home: const HomeScreen(),
    );
  }
}
