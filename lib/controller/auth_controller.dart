import 'dart:convert';
import 'dart:io';

import 'package:device_imei/device_imei.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:telpoapp/res/colors.dart';
import 'package:telpoapp/res/strings.dart';
import 'package:telpoapp/screens/homeScreen.dart';
import 'package:telpoapp/screens/loginScreen.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
  logoff() {
    logoff_process.value = true;
    GetStorage().remove("user");
    GetStorage().remove("token");
    //GetStorage().remove(PROFILE_PIC_FIREBASE);
    user.value = null;
    isLoggedIn.value = false;
    Get.offAll(() => LoginScreen(),
        transition: AppUtils.pageTransition,
        duration: Duration(milliseconds: AppUtils.timeTransition));
    logoff_process.value = false;

    /*Auth.logoff().then((value) {
      // popSnack(message: value.data['message'], bgColor: CiyaTheme.primaryColor);
      GetStorage().remove("user");
      GetStorage().remove("token");
      //GetStorage().remove(PROFILE_PIC_FIREBASE);
      user.value = null;
      isLoggedIn.value = false;
      Get.offAll(() => LoginScreen(),
          transition: AppUtils.pageTransition,
          duration: Duration(milliseconds: AppUtils.timeTransition));
    }).whenComplete(() {
      logoff_process.value = false;
    });*/
  }

  /* register(Map<String, dynamic> creds) {
    register_process.value = true;

    Auth.register(creds).then((value) {
      print(value.data);
      if (value.data['success'] == true) {
        try {
          User _user = User.fromJson(null, value.data['user']);
          if (_user.id != null) {
            Get.closeAllSnackbars();
            popSnackSuccess(
              message: value.data['message'],
              // bgColor: CiyaTheme.primaryColor,
            );
            _user.token = value.data['refreshToken'];
            user.value = _user;
            isLoggedIn.value = true;
            GetStorage().write("user", _user.toMap());
            GetStorage().write("token", value.data['refreshToken']);

            Get.off(() => const HomeScreen(),
                transition: AppUtils.pageTransition,
                duration: Duration(milliseconds: AppUtils.timeTransition));
          } else {
            popSnackError(message: value.data['message']);
          }
        } catch (_) {
          popSnackError(message: value.data['message']);
        }
      } else {
        popSnackError(message: value.data['message']);
      }
    }).catchError((error) {
      try {
        var resp = Map<String, dynamic>.from(error.response.data);
        var respData = resp['data'];
        Get.closeAllSnackbars();
        popSnackError(
            title: resp['message'],
            message: respData[respData.keys.toList().first].toString(),
            duration: Duration(seconds: 5));

        print("error register: ${error.response.statusCode}");
      } catch (ex) {
        popSnackError(
            message:
                "there is an error on the system, please notify the administrator"
                    .tr,
            duration: Duration(seconds: 5));
      }
    }).whenComplete(() {
      register_process.value = false;
    });
  }*/

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

  /*unregister() async {
    unregister_process.value = true;
    Auth.unregister().then((value) {
      GetStorage().remove("user");
      GetStorage().remove("token");
    }).whenComplete(() {
      user.value = null;
      if (user.value != null) {
        isLoggedIn.value = false;
        Get.offAll(() => LoginScreen(),
            transition: AppUtils.pageTransition,
            duration: Duration(milliseconds: AppUtils.timeTransition));
      }
      unregister_process.value = false;
    });
  }*/

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
      } else {
        print(error);
      }
    }).catchError((error) {
      login_process.value = false;
      print(error);
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

        User _user = User.fromJson(null, value.data);
        print(_user.id);
        if (_user.id != null) {
          Get.closeAllSnackbars();
          print("save token");
          print(value.data);
          /* popSnackSuccess(
              message: value.data['message'],
            );*/
          _user.token = value.data['token'];
          _user.refresh_token = value.data['refresh_token'];
          print(jsonDecode(payloadData)['roles']);
          var rls = jsonDecode(payloadData)['roles'];
          _user.roles = List<String>.from(rls);
          print(_user.refresh_token);
          user.value = _user;
          isLoggedIn.value = true;
          GetStorage().write("user", _user.toMap());
          GetStorage().write("token", value.data['token']);
          GetStorage().write("refreshToken", value.data['refresh_token']);
          print("saved user");

          Get.off(() => const HomeScreen(),
              transition: AppUtils.pageTransition,
              duration: Duration(milliseconds: AppUtils.timeTransition));
        } else {
          popSnackError(message: value.data['error']);
        }
      } catch (_) {
        print(_);
        popSnackError(message: value.data['error']);
      }
    } else {
      print("no token");
      popSnackError(message: value.data['error']);
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
      var uu = GetStorage().read("user");
      var token = GetStorage().read("token");
      User _user0 = User.fromJson(null, uu);
      print(_user0);
      Get.offAll(() => const HomeScreen(),
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
      Get.offAll(() => LoginScreen(),
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
    delayIntroScreen();
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

  // upload to firebase storage
}
