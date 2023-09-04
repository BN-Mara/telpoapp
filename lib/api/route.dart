import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../main.dart';
import '../utils/utilities.dart';

class RouteApi {
  static Future<Response> postCurrentRoute(
      Map<String, dynamic> routeData) async {
    var token = GetStorage().read("token");
    AppUtils.http.headers['Authorization'] = "Bearer $token";

    print(AppUtils.http.POST_ROUTE_URL);
    return await DIO.post(
      AppUtils.http.POST_ROUTE_URL,
      data: routeData,
      options: Options(headers: AppUtils.http.headers),
    );
    // return await http.get(Configs.http.GET_PING, headers: Configs.http.headers);
  }

  static Future<Response> putCurrentRoute(
      Map<String, dynamic> routeData) async {
    print(AppUtils.http.POST_ROUTE_URL);
    return await DIO.put(
      AppUtils.http.POST_ROUTE_URL + '/${routeData['id']}',
      data: routeData,
      options: Options(headers: AppUtils.http.headers),
    );
    // return await http.get(Configs.http.GET_PING, headers: Configs.http.headers);
  }
}
