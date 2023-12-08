import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:telpoapp/model/place.dart';
import 'package:telpoapp/res/strings.dart';

import '../main.dart';
import '../utils/utilities.dart';

class VehicleApi {
  static Future<Response> getVehicleByDevice() async {
    var token = GetStorage().read("token");
    var deviceId = GetStorage().read(DEVICE_ID);

    AppUtils.http.headers['Authorization'] = "Bearer $token";
    return await DIO.get(
      AppUtils.http.VEHICLE_BY_DEVICE_ID(deviceId),
      options: Options(headers: AppUtils.http.headers),
    );
  }

  static Future<Response> putVehicle(
      Map<String, dynamic> vehicle, int id) async {
    var token = GetStorage().read("token");
    AppUtils.http.headers['Authorization'] = "Bearer $token";

    print(AppUtils.http.POST_ROUTE_URL);
    return await DIO.put(
      AppUtils.http.VEHICLE_TRACK_UPDATE_URL(id),
      data: vehicle,
      options: Options(headers: AppUtils.http.headers),
    );
    // return await http.get(Configs.http.GET_PING, headers: Configs.http.headers);
  }
}