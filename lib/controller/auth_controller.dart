import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
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

  //forgot(Map<String, dynamic> user) {}
  /*forgot(Map<String, dynamic> user) {
    restEmail.value = user["email"];
    retrieve_pass_process.value = true;
    Auth.forgot(user).then((value) {
      retrieve_pass_process.value = false;
      if (value.data["success"] == true) {
        Get.closeAllSnackbars();
        popSnackSuccess(
          message: value.data['message'],
        );
        codeSent.value = true;
        /*Get.to(() => OtpForgotten(),
                transition: AppUtils.pageTransition,
                duration: Duration(milliseconds: AppUtils.timeTransition));*/
      } else {
        popSnackError(message: value.data['message']);
      }
    }).catchError((error) {
      retrieve_pass_process.value = false;
      popSnackError(
          message:
              "there is an error on the system, please notify the administrator"
                  .tr);
    });
  }*/

  /*forgotValidate(Map<String, dynamic> xuser) {
    retrieve_pass_process.value = true;
    Auth.forgotValidate(xuser).then((value) {
      if (value.data["success"] == true) {
        Get.closeAllSnackbars();
        popSnackSuccess(
          message: value.data['message'],
        );
        try {
          User _user = User.fromJson(null, value.data['user']);
          if (_user.id != null) {
            Get.closeAllSnackbars();
            popSnackSuccess(
              message: value.data['message'],
            );
            _user.token = value.data['refreshToken'];
            temp_user.value = _user;
            //isLoggedIn.value = true;
            GetStorage().write("temp_user", _user.toMap());
            GetStorage().write("temp_token", value.data['refreshToken']);
            GetStorage().write("isReset", true);
            retrieve_pass_process.value = false;

            //checkActiveRide();
            /*Get.offAll(() => const PassForgottenChangeView(),
                transition: AppUtils.pageTransition,
                duration: Duration(milliseconds: AppUtils.timeTransition));*/
          } else {
            retrieve_pass_process.value = false;
            popSnackError(message: value.data['message']);
          }
        } catch (_) {
          retrieve_pass_process.value = false;
          popSnackError(message: value.data['message']);
        }
      } else {
        retrieve_pass_process.value = false;
        popSnackError(message: value.data['message']);
      }
    }).catchError((error) {
      retrieve_pass_process.value = false;
      popSnackError(
          message:
              "there is an error on the system, please notify the administrator"
                  .tr);
    });
  }*/

  /*forgotChange(Map<String, dynamic> xuser) {
    retrieve_pass_process.value = true;
    Auth.forgotChange(xuser).then((value) {
      if (value.data["success"] == true) {
        retrieve_pass_process.value = false;
        Get.closeAllSnackbars();
        popSnackSuccess(
          message: value.data['message'],
        );
        isLoggedIn.value = true;
        user.value = temp_user.value;
        //isLoggedIn.value = true;

        GetStorage().write("user", GetStorage().read("temp_user"));
        GetStorage().write("token", GetStorage().read("temp_token"));
        //GetStorage().write("isReset", false);

        Get.off(() => const HomeScreen(),
            transition: AppUtils.pageTransition,
            duration: Duration(milliseconds: AppUtils.timeTransition));
      } else {
        retrieve_pass_process.value = false;
        popSnackError(message: value.data['message']);
      }
    }).catchError((error) {
      print(error);
      retrieve_pass_process.value = false;
      popSnackError(
          message:
              "there is an error on the system, please notify the administrator"
                  .tr);
    });
  }
*/
  deviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var deviceIdentifier = androidInfo.id;
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
    GetStorage().remove("user");
    GetStorage().remove("token");
    //GetStorage().remove(PROFILE_PIC_FIREBASE);
    GetStorage().remove(VEHICLE_KEY);
    user.value = null;
    isLoggedIn.value = false;

    Get.offAll(() => LoginScreen(),
        transition: AppUtils.pageTransition,
        duration: Duration(milliseconds: AppUtils.timeTransition));
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
    }).catchError((error) {
      login_process.value = false;
      print(error);
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
          print(jsonDecode(payloadData)['roles']);
          var rls = jsonDecode(payloadData)['roles'];
          _user.roles = List<String>.from(rls);
          _user.fullname = value.data['fullname'];
          _user.phone = value.data['phone'];
          //_user.id = value.data['sub'];
          _user.isActive = value.data['isActive'];
          print("map user");
          print(_user.toMap());
          user.value = _user;
          print(user.value!.roles);
          isLoggedIn.value = true;
          GetStorage().write("user", _user.toMap());
          GetStorage().write("token", value.data['token']);
          GetStorage().write("refreshToken", value.data['refresh_token']);
          print("saved user");
          print(GetStorage().read("user"));

          //Get.find<RouteController>().getTicketPrices();
          if (user.value!.roles!.contains('ROLE_DRIVER')) {
            var v = Vehicle.fromJson(value.data['vehicle']);
            vehicle.value = v;
            GetStorage().write(VEHICLE_KEY, v.toJson());
            Get.find<RouteController>().getTicketPrices();

            Get.find<CheckRouteController>().updatingRoute(v.id!);
            Get.off(() => const AppLifecycleDisplay(child: HomeDriverScreen()),
                transition: AppUtils.pageTransition,
                duration: Duration(milliseconds: AppUtils.timeTransition));
          } else if (user.value!.roles!.contains('ROLE_CONVEYOR')) {
            getVehicle();
            Get.find<RouteController>().checkActiveRoute(1);
            Get.find<RouteController>().getCards();
            Get.find<RouteController>().getTicketPrices();

            Get.offAll(() => const AppLifecycleDisplay(child: HomeScreen()),
                transition: AppUtils.pageTransition,
                duration: Duration(milliseconds: AppUtils.timeTransition));
          } else if (user.value!.roles!.contains('ROLE_RECHARGEUR')) {
            Get.offAll(() => const RechargeScreen(),
                transition: AppUtils.pageTransition,
                duration: Duration(milliseconds: AppUtils.timeTransition));
          } else {}
        } else {
          popSnackError(message: value.data['message']);
        }
      } catch (_) {
        print(_);
        popSnackError(message: "une erreur s\'est produite, réessayez");
      }
    } else {
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

  autoLogin() async {
    // Check availability
    bool isAvailable = await NfcManager.instance.isAvailable();

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
    //print("this");
    /*if (GetStorage().read<String>(DEVICE_ID) == null) {
      var deviceInfo = await DeviceImei().getDeviceInfo();
      if (deviceInfo != null) {
        GetStorage().write(DEVICE_ID, deviceInfo.deviceId);
      }
    }*/
    //Get.offAll(() => const HomeScreen());
    try {
      /* var uu = GetStorage().read("user");
      print(uu);
      var token = GetStorage().read("token");
      User _user0 = User.fromJson(null, uu);
      print(_user0);
      user.value = _user0;
      print(user.value!.roles);
      //Get.find<CheckRouteController>().updatingRoute(1);
      //Get.find<RouteController>().checkActiveRoute(1);
      //Get.find<RouteController>().getCards();
      getVehicle();

      if (user.value!.roles!.contains('ROLE_DRIVER')) {
        Get.find<CheckRouteController>().updatingRoute(1);
        Get.offAll(() => const HomeDriverScreen(),
            transition: AppUtils.pageTransition,
            duration: Duration(milliseconds: AppUtils.timeTransition));
      } else if (user.value!.roles!.contains('ROLE_CONVEYOR')) {
        Get.find<RouteController>().checkActiveRoute(1);
        Get.find<RouteController>().getCards();
        Get.find<RouteController>().getTicketPrices();

        Get.offAll(() => const HomeScreen(),
            transition: AppUtils.pageTransition,
            duration: Duration(milliseconds: AppUtils.timeTransition));
      } else if (user.value!.roles!.contains('ROLE_RECHARGEUR')) {
        Get.offAll(() => const RechargeScreen(),
            transition: AppUtils.pageTransition,
            duration: Duration(milliseconds: AppUtils.timeTransition));
      } else {}*/

      Get.offAll(() => AppLifecycleDisplay(child: LoginScreen()),
          transition: AppUtils.pageTransition,
          duration: Duration(milliseconds: AppUtils.timeTransition));

      /*Auth.refreshLogin(_user0.refresh_token!, _user0.email!).then((value) {
        print('data here :  ${value.data.toString()}');

        Get.closeAllSnackbars();
        final encodedPayload = value.data['token'].split('.')[1];
        final payloadData =
            utf8.fuse(base64).decode(base64.normalize(encodedPayload));
        //User _user = User.fromJson(null, jsonDecode(payloadData));
        User _user = User.fromJson(null, value.data);
        _user.token = value.data['token'];
        _user.refresh_token = value.data['refresh_token'];
        user.value = _user;
        GetStorage().write("user", _user.toMap());
        GetStorage().write("token", value.data['token']);
        isLoggedIn.value = true;

        if (GetStorage().read<bool>("isReset") == true) {
          /*Get.offAll(() => const PassForgottenChangeView(),
                transition: AppUtils.pageTransition,
                duration: Duration(milliseconds: AppUtils.timeTransition));*/
        } else {
          Get.offAll(() => const HomeScreen(),
              transition: AppUtils.pageTransition,
              duration: Duration(milliseconds: AppUtils.timeTransition));
        }
      });*/
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
    sessionToken = const Uuid().v4();
    deviceInfo();
    //getVehicle();
    delayIntroScreen();
  }

  getVehicle() async {
    print("get vehicle...");
    VehicleApi.getVehicleByDevice().then((value) {
      print(value.data);
      if (value.data.length < 1) {
        popSnackError(message: "No Vehicle registered for this device");
        return;
      }

      var v = Vehicle.fromJson(value.data.first);
      vehicle.value = v;
      GetStorage().write(VEHICLE_KEY, v.toJson());
      Get.find<RouteController>().getTicketPrices();
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

  // upload to firebase storage
}
