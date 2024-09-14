import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:telpoapp/api/vehicle.dart';
import 'package:telpoapp/controller/check_route.dart';
import 'package:telpoapp/controller/recharge_controller.dart';
import 'package:telpoapp/controller/route_controller.dart';
import 'package:telpoapp/model/vehicle.dart';
import 'package:telpoapp/res/colors.dart';
import 'package:telpoapp/res/strings.dart';
import 'package:telpoapp/screens/homeDriverScreen.dart';
import 'package:telpoapp/screens/homeScreen.dart';
import 'package:telpoapp/screens/loginScreen.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:telpoapp/screens/rechargeScreen.dart';
import 'package:telpoapp/widgets/AppLifecycleDisplay.dart';

import 'package:uuid/uuid.dart';

import '../api/auth.dart';
import '../model/user.dart';
import '../utils/utilities.dart';
import '../widgets/sundry_components.dart';

class AuthController extends GetxController {
  late final sessionToken;
  var user = Rxn<User>();
  var isLoggedIn = false.obs;
  var login_process = false.obs;
  var logoff_process = false.obs;
  var register_process = false.obs;
  var unregister_process = false.obs;

  var modify_process = false.obs;

  var retrieve_pass_process = false.obs;

  var restEmail = "".obs;
  var codeSent = false.obs;
  var codeValidated = false.obs;
  var temp_user = Rxn<User>();
  var vehicle = Rxn<Vehicle>();
  var eventChannel = const EventChannel('platform_channel_events/nfcsession');
  static const platform = MethodChannel('platform_channel_events/nfcsession');

  deviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var deviceIdentifier = '${androidInfo.serialNumber}';
    print(deviceIdentifier);
    GetStorage().write(DEVICE_ID, deviceIdentifier);
  }

  logoff() {
    logoff_process.value = true;
    Auth.logoff().then((value) {
      popSnackSuccess(message: "Deconnexion de votre session!");
      logoff_process.value = false;
    }).onError((dio.DioException error, stackTrace) {
      print("${error.response!.data}");
      logoff_process.value = false;
    }).whenComplete(() => logoff_process.value = false);
    resetAuth();

    Get.offAll(() => LoginScreen(),
        transition: AppUtils.pageTransition,
        duration: Duration(milliseconds: AppUtils.timeTransition));
  }

  resetAuth() {
    GetStorage().remove("user");
    GetStorage().remove("token");
    //GetStorage().remove(PROFILE_PIC_FIREBASE);
    GetStorage().remove(VEHICLE_KEY);
    GetStorage().remove("refreshToken");
    Get.delete<RouteController>();
    Get.delete<CheckRouteController>();

    user.value = null;
    isLoggedIn.value = false;
  }

  modify(Map<String, dynamic> muser) {
    var token = GetStorage().read("token");
    modify_process.value = true;
    Auth.modify(user.value!.id!, token, muser).then((value) {
      //  printDebug(value.data.toString());

      try {
        User _user = User.fromJson(null, value.data['data']);
        if (_user.id != null) {
          popSnack(
            title: 'congratulations!'.tr,
            message: "profile editing has been completed successfully".tr,
          );
          _user.token = token;
          user.value = _user;
          GetStorage().write("user", _user.toMap());
          // GetStorage().write("token", value.data['accessToken']);
        } else {
          popSnack(message: "no user found".tr, bgColor: errorColor);
        }
      } catch (_) {
        popSnack(message: value.data['message'], bgColor: errorColor);
      }
    }).whenComplete(() {
      modify_process.value = false;
    });
  }

  delayIntroScreen() async {
    await Future.delayed(Duration(seconds: AppUtils.timeInterval));

    autoLogin();
  }

  loginWithNfc(String nfcUid) {
    print(nfcUid);
    login_process.value = true;
    Map<String, dynamic> creds = {"taguid": nfcUid, "login_type": "NFC_LOGIN"};
    Auth.loginNfc(creds).then((value) {
      handleLogin(value);
    }).onError((dio.DioException error, stackTrace) {
      if (error.response != null) {
        print(error.response!.data);
        popSnackError(message: error.response!.data['message']);
      } else {
        print(error);
        popSnackError(message: "Login failed!");
      }
      sendDataToAndroid();
    }).catchError((error) {
      login_process.value = false;
      print(error);
      sendDataToAndroid();
    }).whenComplete(() {
      login_process.value = false;
    });
  }

  login(Map<String, dynamic> creds) {
    login_process.value = true;
    Auth.login(creds).then((value) {
      handleLogin(value);
    }).onError((dio.DioException error, stackTrace) {
      if (error.response != null) {
        print(error.response!.data);
        popSnackError(message: error.response!.data['message']);
      } else {
        print(error);
        popSnackError(message: "Reesayer plus tard");
      }
    }).catchError((error) {
      login_process.value = false;
      print(error);
      popSnackError(message: "Reesayer plus tard");
    }).whenComplete(() {
      login_process.value = false;
    });
  }

  handleLogin(dio.Response<dynamic> value) {
    if (value.data['token'] != null) {
      try {
        final encodedPayload = value.data['token'].split('.')[1];
        final payloadData =
            utf8.fuse(base64).decode(base64.normalize(encodedPayload));
        print(payloadData);
        print(value.data);
        print(jsonDecode(payloadData));
        Map<String, dynamic> payLoadDecoded = jsonDecode(payloadData);
        print("====== payLoadDecoded =======");
        print(payLoadDecoded);
        if (!payLoadDecoded.containsKey('roles')) {
          popSnackError(message: NOT_ALLOWED);
          sendDataToAndroid();
          return;
        }
        var rls = payLoadDecoded['roles'];
        var uroles = List<String>.from(rls);
        if (uroles.isEmpty) {
          popSnackError(message: NOT_ALLOWED);
          sendDataToAndroid();
          return;
        }
        if (!uroles.contains(CONVEYOR) && !uroles.contains(DRIVER)) {
          popSnackError(message: NOT_ALLOWED);
          sendDataToAndroid();
          return;
        }

        User _user = User.fromJson(null, value.data);
        print(_user.id);
        if (_user.id != null) {
          Get.closeAllSnackbars();
          print("save token");
          //print(value.data);
          /* popSnackSuccess(
              message: value.data['message'],
            );*/
          //_user.token = value.data['token'];
          _user.refresh_token = value.data['refresh_token'];

          _user.roles = uroles;
          _user.fullname = value.data['fullname'];
          _user.phone = value.data['phone'];
          //_user.id = value.data['sub'];
          _user.isActive = value.data['isActive'];
          print("map user");
          print(_user.toMap());
          user.value = _user;
          print(user.value!.roles);
          isLoggedIn.value = true;
          sendDataToAndroid();
          GetStorage().write("user", _user.toMap());
          GetStorage().write("token", value.data['token']);
          GetStorage().write("refreshToken", value.data['refresh_token']);
          print("saved user");
          print(GetStorage().read("user"));

          //Get.find<RouteController>().getTicketPrices();
          if (user.value!.roles!.contains(DRIVER)) {
            Get.put(RouteController());
            Get.put(CheckRouteController());
            print("==== Driver connected =======");
            print("====== User vehicle ${value.data['vehicle']} ======");
            var v = Vehicle.fromJson(value.data['vehicle']);

            vehicle.value = v;

            VehicleApi.getVehicleById("${v.id}").then((value) {
              print("====== Vehicle ==> ${value.data} ======");
              var v2 = Vehicle.fromJson(value.data);
              vehicle.value = v2;
              GetStorage().write(DEVICE_ID, v2.deviceID);
              GetStorage().write(VEHICLE_KEY, v2.toJson());
              Get.find<RouteController>().getPlaces(v2.region!);
              Get.find<RouteController>().getTicketPrices();
              Get.find<CheckRouteController>().updatingRoute(v2.id!);

              print("===== Go to Page ======");

              Get.offAll(
                  () => const AppLifecycleDisplay(child: HomeDriverScreen()),
                  transition: AppUtils.pageTransition,
                  duration: Duration(milliseconds: AppUtils.timeTransition));
            }).onError((DioException error, stackTrace) {
              print("====== Error load vehicle ======");
              print(error.response!.data);
            });
            //
          } else if (user.value!.roles!.contains(CONVEYOR)) {
            Get.put(RouteController());
            Get.put(CheckRouteController());
            getVehicle();
            Get.find<RouteController>().getMyRoutes();
            //Get.find<RouteController>().getCards();

            Get.offAll(() => const AppLifecycleDisplay(child: HomeScreen()),
                transition: AppUtils.pageTransition,
                duration: Duration(milliseconds: AppUtils.timeTransition));
          } else {
            popSnackError(message: NOT_ALLOWED);
            return;
          }
        } else {
          popSnackError(message: value.data['message']);
          sendDataToAndroid();
          return;
        }
      } catch (ex) {
        print(ex.toString());
        popSnackError(message: "une erreur s\'est produite, réessayez");
        sendDataToAndroid();
      }
    } else {
      sendDataToAndroid();
      print("no token");
      popSnackError(message: value.data['message']);
    }
  }

  String nfcId(NfcTag tag) {
    NfcA? nfca = NfcA.from(tag);
    if (nfca == null) {
      print('Tag is not compatible with Nfca');
      return "";
    }
    final String identifier = nfca.identifier
        .map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join(':');

    return identifier.toUpperCase();
  }

  String convertNfcUID(String nfcuid) {
    final String identifier = nfcuid;
    print("===> UID IN FLUTTER: ${identifier}");

    return identifier.toUpperCase();
  }

  autoLogin() async {
    // Check availability
    bool isAvailable = await NfcManager.instance.isAvailable();
    final eventStream =
        eventChannel.receiveBroadcastStream().distinct().map((event) {
      print("== channel event ==");
      print(event);
    });

// Start Session
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        // Do something with an NfcTag instance.
        if (user.value == null) {
          print("user is null");
          loginWithNfc(nfcId(tag));
        } else {
          print("listened");
          if (user.value!.roles!.contains("ROLE_RECHARGEUR")) {
            Get.find<RechargeController>().process(nfcId(tag));
          } else if (user.value!.roles!.contains("ROLE_CONVEYOR")) {
            Get.find<RouteController>().cardPay(nfcId(tag));
          }
        }

        print("data nfc: ");
      },
    );

    try {
      Get.offAll(() => AppLifecycleDisplay(child: LoginScreen()),
          transition: AppUtils.pageTransition,
          duration: Duration(milliseconds: AppUtils.timeTransition));
    } catch (_) {
      //printDebug("OUTER CATCH ERROR : ${_.toString()}");
      isLoggedIn.value = false;
      Get.offAll(() => AppLifecycleDisplay(child: LoginScreen()),
          transition: AppUtils.pageTransition,
          duration: Duration(milliseconds: AppUtils.timeTransition));
    }
  }

  @override
  onReady() async {}

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    resetAuth();
    deviceInfo();
    sendDataToAndroid();
    //Get.delete<RouteController>();
    //Get.delete<CheckRouteController>();
    sessionToken = const Uuid().v4();

    _setMethodCallHandler();
    //getVehicle();
    delayIntroScreen();
  }

  getVehicle() async {
    print("get vehicle...");
    print(
        "======= Getting Vehicle by DeviceID ${GetStorage().read(DEVICE_ID)} ======");
    VehicleApi.getVehicleByDevice().then((value) async {
      print(value.data);
      if (value.data.length < 1) {
        popSnackError(message: "No Vehicle registered for this device");
        return;
      }
      //var vList =  await Vehicle.vehiclesfromJson(value.data);

      var v = Vehicle.fromJson(value.data.first);
      vehicle.value = v;
      GetStorage().write(VEHICLE_KEY, v.toJson());
      Get.find<RouteController>().getTicketPrices();
      Get.find<RouteController>().checkActiveRoute(v.id!);

      Get.find<RouteController>().getTicketPrices();
      Get.find<RouteController>().getPlaces(v.region!);
      print(
          "======= End Getting Vehicle by DeviceID ${GetStorage().read(DEVICE_ID)} Vehicle ${v.id} Region ${v.region}======");
    }).onError((dio.DioException error, stackTrace) {
      print("${error.response!.data}");
    });
  }

  Future<bool> refreshToken() async {
    String refresh = GetStorage().read<String>("refreshToen")!;
    Map<String, String> data = {"refresh_token": refresh};
    var resp = await Auth.postRefresh(data);
    if (resp.statusCode == 200) {
      GetStorage().write("token", resp.data['token']);
      GetStorage().write("refreshToken", resp.data['refresh_token']);

      return true;
    } else {
      print("refresh error");
      /*Get.snackbar(
        error.tr,
        session_expired.tr,
      );*/
      //signOut();
      return false;
    }
  }

  Future<void> sendAlert(String title, String description) async {
    Map<String, dynamic> alert = {
      "vehicle": '/api/vehicles/${vehicle.value!.id}',
      "title": title,
      "description": description,
      "isSeen": false
    };
    await VehicleApi.postAlert(alert).then((value) {
      print(value.data);
    }).onError((dio.DioException error, stackTrace) {
      print("${error.response!.data}");
    });
  }

  Future<void> resumeAlert() async {
    if (vehicle.value != null) {
      await VehicleApi.resumeAlert('${vehicle.value!.id}').then((value) {
        print(value.data);
      }).onError((dio.DioException error, stackTrace) {
        print("${error.response!.data}");
      });
    }
  }

  void _setMethodCallHandler() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "onNfcData") {
        String nfcDataUID = convertNfcUID(call.arguments);
        if (user.value == null) {
          print("user is null");
          loginWithNfc(nfcDataUID);
        } else {
          print("listened");
          if (user.value!.roles!.contains("ROLE_RECHARGEUR")) {
            Get.find<RechargeController>().process(nfcDataUID);
          } else if (user.value!.roles!.contains("ROLE_CONVEYOR")) {
            Get.find<RouteController>().cardPay(nfcDataUID);
          }
        }
      }
    });
  }

  static Future<void> sendDataToAndroid() async {
    try {
      await platform
          .invokeMethod('sendData', {"message": "Hello from Flutter!"});
    } on PlatformException catch (e) {
      print("Failed to send data to Android: '${e.message}'.");
    }
  }

  Future<void> sendDataToAndroidOut() async {
    await sendDataToAndroid();
  }

  // upload to firebase storage
}
