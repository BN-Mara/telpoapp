import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:telpoapp/model/place.dart';

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

  static Future<Response> getCurrentRoute(int vehicle) async {
    var token = GetStorage().read("token");
    AppUtils.http.headers['Authorization'] = "Bearer $token";
    return await DIO.get(
      "${AppUtils.http.POST_ROUTE_URL}?vehicle=1&isActive=1",
      options: Options(headers: AppUtils.http.headers),
    );
  }

  static Future<Response> getList() async {
    var token = GetStorage().read("token");
    AppUtils.http.headers['Authorization'] = "Bearer $token";
    return await DIO.get(
      AppUtils.http.POST_ROUTE_URL,
      options: Options(headers: AppUtils.http.headers),
    );
  }

  static Future<Response> getPlaces() async {
    var token = GetStorage().read("token");
    //AppUtils.http.headers['Authorization'] = "Bearer $token";
    return await DIO.get(
      AppUtils.http.POST_ROUTE_PLACES,
      options: Options(headers: AppUtils.http.headers),
    );
  }

  static Future<Response> getDataRoute(Place s, Place d) async {
    final String url = 'https://api.openrouteservice.org/v2/directions/';
    final String apiKey =
        '5b3ce3597851110001cf6248c85582ce6c9b453f9c480c258b1289f5';
    final String pathParam = 'driving-car';
    //AppUtils.http.headers['Authorization'] = "Bearer $token";
    return await DIO.get(
      '$url$pathParam?api_key=$apiKey&start=${s.longitude},${s.latitude}&end=${d.longitude},${d.latitude}',
      // options: Options(headers: AppUtils.http.headers),
    );
  }

  static Future<Response> postCardPay(Map<String, dynamic> card) async {
    var token = GetStorage().read("token");
    AppUtils.http.headers['Authorization'] = "Bearer $token";

    print(AppUtils.http.POST_ROUTE_URL);
    return await DIO.post(
      AppUtils.http.POST_CARD_PAY,
      data: card,
      options: Options(headers: AppUtils.http.headers),
    );
    // return await http.get(Configs.http.GET_PING, headers: Configs.http.headers);
  }

  static Future<Response> getCards() async {
    var token = GetStorage().read("token");
    AppUtils.http.headers['Authorization'] = "Bearer $token";
    return await DIO.get(
      AppUtils.http.GET_CARD_ALL,
      options: Options(headers: AppUtils.http.headers),
    );
  }
}
