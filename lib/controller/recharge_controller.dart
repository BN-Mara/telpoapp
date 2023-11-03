import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:telpoapp/api/card.dart';
import 'package:telpoapp/api/route.dart';
import 'package:telpoapp/controller/auth_controller.dart';
import 'package:telpoapp/model/nfc_card.dart';
import 'package:telpoapp/model/user.dart';
import 'package:telpoapp/res/colors.dart';
import 'package:telpoapp/screens/registerCardScreen.dart';
import 'package:telpoapp/widgets/inputTextNoPadding.dart';
import 'package:telpoapp/widgets/inputTextWidget.dart';
import 'package:telpoapp/widgets/recharge_form.dart';
import 'package:telpoapp/widgets/submitButton.dart';
import 'package:telpoapp/widgets/sundry_components.dart';

class RechargeController extends GetxController {
  var process_recharge = false.obs;
  var amount = TextEditingController().obs;

  var cardHolder = TextEditingController().obs;
  var phoneNumber = TextEditingController().obs;
  var balance = TextEditingController().obs;
  var process_register = false.obs;

  registerCard(String uid) {
    var card = NfcCard(
        uid: uid,
        cardHolder: cardHolder.value.text,
        phoneNumber: phoneNumber.value.text,
        balance: double.parse(balance.value.text));

    CardApi.postCard(card.toJson()).then((value) {
      process_register.value = false;
      popSnackSuccess(message: "Enregistrement effectué avec succès");
    }).onError((DioException error, stackTrace) {
      process_register.value = false;
      popSnackError(
          message: "Une erreur est survenue, merci de réessayer plus tard.");
      print("${error.response!.data}");
    }).whenComplete(() {
      process_register.value = false;
    });
  }

  createRecharge(Map<String, dynamic> data) {
    process_recharge.value = true;
    RouteApi.postCardRecharge(data).then((value) {
      var balance = value.data['balance'];
      var uu = GetStorage().read("user");
      print(uu);

      User _user0 = User.fromJson(null, uu);
      print(_user0);
      _user0.balance = balance;
      GetStorage().write("user", _user0.toMap());
      Get.find<AuthController>().user.value!.balance = balance;
      popSnackSuccess(message: "Recharge effectuée avec succès");
      process_recharge.value = false;
    }).onError((DioException error, stackTrace) {
      process_recharge.value = false;
      if (error.response != null) {
        print("${error.response!.data}");
        popSnackError(message: error.response!.data['message']);
      } else {
        popSnackError(message: "une erreur s'est produite! Réessayer..");
      }
    }).whenComplete(() {
      process_recharge.value = false;
    });
  }

  process(String tag) {
    Get.defaultDialog(
      title: "Card selected",
      content: Container(
          width: Get.size.width,
          padding: EdgeInsets.all(3),
          child: Row(
            children: [
              Expanded(
                  child: SubmitButton(
                      onPressed: () {
                        Get.back();
                        Get.bottomSheet(RechargeForm(tag: tag));
                      },
                      text: "Recharger",
                      bgColor: primaryColor)),
              Expanded(
                  child: SubmitButton(
                      onPressed: () {
                        //Get.back();
                        Get.off(() => RegisterCardScreen(
                              uid: tag,
                            ));
                      },
                      text: "Enregister",
                      bgColor: successColor))
            ],
          )),
    );
  }
}
