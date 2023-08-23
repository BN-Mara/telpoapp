import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:telpoapp/res/colors.dart';
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
  forgot(Map<String, dynamic> user) {
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
  }

  forgotValidate(Map<String, dynamic> xuser) {
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
  }

  forgotChange(Map<String, dynamic> xuser) {
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
        GetStorage().write("isReset", false);

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

  logoff() {
    logoff_process.value = true;
    Auth.logoff().then((value) {
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
    });
  }

  register(Map<String, dynamic> creds) {
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

  unregister() async {
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
  }

  delayIntroScreen() async {
    /*if(GetStorage().read<bool>(INTRO_SEEN) == true)
    {
      await Future.delayed(Duration(seconds: AppUtils.timeInterval));
      autoLogin();

    }*/

    await Future.delayed(Duration(seconds: AppUtils.timeInterval));
    //await AppUtils.timeInterval.delay();
    //print("delayed");
    /*Get.off(() => IntroductionView(),
            transition: AppUtils.pageTransition,
            duration: Duration(milliseconds: AppUtils.timeTransition));*/
    //getProfilePicture();
    autoLogin();
  }

  login(Map<String, dynamic> creds) {
    login_process.value = true;
    Auth.login(creds).then((value) {
      if (value.data['access_token'] != null) {
        try {
          final encodedPayload = value.data['access_token'].split('.')[1];
          final payloadData =
              utf8.fuse(base64).decode(base64.normalize(encodedPayload));
          print(payloadData);

          User _user = User.fromJson(null, jsonDecode(payloadData));
          print(_user.id);
          if (_user.id != null) {
            Get.closeAllSnackbars();
            print("save token");
            /* popSnackSuccess(
              message: value.data['message'],
            );*/
            _user.token = value.data['access_token'];
            _user.refresh_token = value.data['refresh_token'];
            print(_user.refresh_token);
            user.value = _user;
            isLoggedIn.value = true;
            GetStorage().write("user", _user.toMap());
            GetStorage().write("token", value.data['access_token']);

            Get.off(() => const HomeScreen(),
                transition: AppUtils.pageTransition,
                duration: Duration(milliseconds: AppUtils.timeTransition));
          } else {
            popSnackError(message: value.data['error']);
          }
        } catch (_) {
          popSnackError(message: value.data['error']);
        }
      } else {
        popSnackError(message: value.data['error_description']);
      }
    }).whenComplete(() {
      login_process.value = false;
    });
  }

  autoLogin() async {
    //print("this");
    Get.offAll(() => const HomeScreen());
    /*try {
      var uu = GetStorage().read("user");
      var token = GetStorage().read("access_token");
      User _user0 = User.fromJson(null, uu);
      print(_user0);

      Auth.refreshLogin(_user0.refresh_token!, _user0.email!).then((value) {
        print('data here :  ${value.data.toString()}');

        Get.closeAllSnackbars();
        final encodedPayload = value.data['access_token'].split('.')[1];
        final payloadData =
            utf8.fuse(base64).decode(base64.normalize(encodedPayload));
        User _user = User.fromJson(null, jsonDecode(payloadData));
        _user.token = value.data['access_token'];
        _user.refresh_token = value.data['refresh_token'];
        user.value = _user;
        GetStorage().write("user", _user.toMap());
        GetStorage().write("token", value.data['access_token']);
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
      });
    } catch (_) {
      //printDebug("OUTER CATCH ERROR : ${_.toString()}");
      isLoggedIn.value = false;
      Get.offAll(() => LoginScreen(),
          transition: AppUtils.pageTransition,
          duration: Duration(milliseconds: AppUtils.timeTransition));
    }*/
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

  // upload to firebase storage
}
