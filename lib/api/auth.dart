import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../main.dart';
import '../utils/utilities.dart';

class Auth {
  /// User methods start

  static Future<Response> get(String id, String token) async {
    AppUtils.http.headers['Authorization'] = "Bearer $token";
    return await DIO.get(
      AppUtils.http.AUTH(id),
      options: Options(headers: AppUtils.http.headers),
      onReceiveProgress: (max, progress) {
        printDebug("max: $max ; profress: $progress");
      },
    );
  }

  static Future<Response> modify(
      String id, String token, Map<String, dynamic> user) async {
    AppUtils.http.headers['Authorization'] = "Bearer $token";
    return await DIO.put(
      AppUtils.http.AUTH(id),
      data: user,
      options: Options(headers: AppUtils.http.headers),
    );
  }

  static Future<Response> login(Map<String, dynamic> user) async {
    print(AppUtils.http.POST_LOGIN);
    return await DIO.post(
      AppUtils.http.POST_LOGIN,
      data: user,
      options: Options(headers: AppUtils.http.headers),
    );
    // return await http.get(Configs.http.GET_PING, headers: Configs.http.headers);
  }

  static Future<Response> refreshLogin(
      String refreshToken, String username) async {
    print(AppUtils.http.POST_LOGIN);
    return await DIO.post(
      AppUtils.http.POST_LOGIN,
      data: {
        'grant_type': 'refresh_token',
        'username': username,
        'refresh_token': refreshToken,
        'client_id': 'AficellRetailer_App'
      },
      options:
          Options(contentType: Headers.formUrlEncodedContentType, headers: {
        'client_id': 'AficellRetailer_App',
        'Content-Type': 'application/x-www-form-urlencoded'
      }),
    );
    // return await http.get(Configs.http.GET_PING, headers: Configs.http.headers);
  }

  static Future<Response> logoff() async {
    var token = GetStorage().read("token");
    AppUtils.http.headers['Authorization'] = "Bearer $token";
    return await DIO.post(
      AppUtils.http.POST_LOGOUT,
      options: Options(headers: AppUtils.http.headers),
    );
    // return await http.get(Configs.http.GET_PING, headers: Configs.http.headers);
  }

  static Future<Response> register(Map<String, dynamic> user) async {
    return await DIO.post(
      AppUtils.http.POST_REGISTER,
      data: user,
      options: Options(headers: AppUtils.http.headers),
    );
    print(user);
    /*return await DIO.get(
      AppUtils.http.POST_REGISTER,
      queryParameters: user,
      options: Options(headers: AppUtils.http.headers),
    );*/
    // return await http.get(Configs.http.GET_PING, headers: Configs.http.headers);
  }

  static Future<Response> unregister() async {
    var token = GetStorage().read("token");
    AppUtils.http.headers['Authorization'] = "Bearer $token";
    return await DIO.post(
      AppUtils.http.POST_UNREGISTER,
      options: Options(headers: AppUtils.http.headers),
    );
    // return await http.get(Configs.http.GET_PING, headers: Configs.http.headers);
  }

  static Future<Response> forgot(Map<String, dynamic> user) async {
    printDebug(AppUtils.http.headers.toString());
    printDebug(AppUtils.http.POST_LOGIN);
    return await DIO.post(
      AppUtils.http.POST_FORGOT_PASS,
      data: user,
      options: Options(headers: AppUtils.http.headers),
    );
    // return await http.get(Configs.http.GET_PING, headers: Configs.http.headers);
  }

  static Future<Response> forgotValidate(Map<String, dynamic> user) async {
    printDebug(AppUtils.http.headers.toString());
    printDebug(AppUtils.http.POST_LOGIN);
    return await DIO.post(
      AppUtils.http.POST_FORGOT_VALIDATE,
      data: user,
      options: Options(headers: AppUtils.http.headers),
    );
    // return await http.get(Configs.http.GET_PING, headers: Configs.http.headers);
  }

  static forgotChange(Map<String, dynamic> user) async {
    var token = GetStorage().read("temp_token");
    print(token);
    print(user);
    print(AppUtils.http.POST_FORGOT_RESET);
    AppUtils.http.headers['Authorization'] = "Bearer $token";
    return await DIO.post(
      AppUtils.http.POST_FORGOT_RESET,
      data: user,
      options: Options(headers: AppUtils.http.headers),
    );
  }

  //static Future<Response> postRefresh(Map<String, dynamic> userdata) async {
  //String token = GetStorage().read("access_token");
  //AppUtils.http.headers['Authorization'] = "Bearer $token";
  /* print(AppUtils.http.USER_REFRESH_TOKEN);
    return await DIO.post(
      AppUtils.http.USER_REFRESH_TOKEN,
      data: userdata,
      options: Options(headers: AppUtils.http.headers, followRedirects: true),
    );*/
  // return await http.get(Configs.http.GET_PING, headers: Configs.http.headers);
  //}

  /// User methods end
}
