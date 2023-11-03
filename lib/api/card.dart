import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:telpoapp/model/place.dart';

import '../main.dart';
import '../utils/utilities.dart';

class CardApi {
  static Future<Response> postCard(Map<String, dynamic> card) async {
    var token = GetStorage().read("token");
    AppUtils.http.headers['Authorization'] = "Bearer $token";

    print(AppUtils.http.POST_ROUTE_URL);
    return await DIO.post(
      AppUtils.http.POST_CARD,
      data: card,
      options: Options(headers: AppUtils.http.headers),
    );
    // return await http.get(Configs.http.GET_PING, headers: Configs.http.headers);
  }
}
