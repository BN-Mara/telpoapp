import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../res/colors.dart';

Future<dynamic> readJson(String res) async {
  final String response = await rootBundle.loadString(res);
  return await json.decode(response);
  // ...
}

popWaitingDialog() {
  Get.defaultDialog(
    title: "",
    barrierDismissible: false,
    titlePadding: EdgeInsets.zero,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          width: 10.0,
        ),
        Text("${'please_wait'.tr}...!"),
      ],
    ),
  );
}

popSnack(
    {String title = "Ciya!",
    String? message,
    String buttonText = "OK",
    Color messageColor = Colors.black,
    Color? bgColor = Colors.transparent,
    Color buttonColor = Colors.black,
    SnackPosition position = SnackPosition.TOP,
    Duration? duration = const Duration(seconds: 3),
    Function()? onMainTap}) {
  Get.snackbar(
    title,
    message ?? '',
    colorText: messageColor,
    backgroundColor: bgColor ?? Colors.transparent,
    snackPosition: position,
    isDismissible: false,
    duration: duration,
    mainButton: onMainTap == null
        ? null
        : TextButton(
            style: TextButton.styleFrom(
              primary: buttonColor,
            ),
            onPressed: () {
              Get.closeCurrentSnackbar();
              if (onMainTap != null) onMainTap();
            },
            child: Text(
              buttonText,
            ),
          ),
  );
}

popSnackError(
    {String title = "Erreur",
    String? message,
    String buttonText = "OK",
    Color messageColor = Colors.white,
    Color buttonColor = Colors.white,
    SnackPosition position = SnackPosition.TOP,
    Duration? duration = const Duration(seconds: 3),
    Function()? onMainTap}) {
  popSnack(
    title: title,
    message: message,
    buttonText: buttonText,
    messageColor: messageColor,
    bgColor: errorColor,
    buttonColor: buttonColor,
    position: position,
    duration: duration,
    onMainTap: onMainTap,
  );
}

popSnackSuccess(
    {String title = "Felicitations",
    String? message,
    String buttonText = "OK",
    Color messageColor = Colors.white,
    Color buttonColor = Colors.white,
    SnackPosition position = SnackPosition.TOP,
    Duration? duration = const Duration(seconds: 3),
    Function()? onMainTap}) {
  popSnack(
    title: title,
    message: message,
    buttonText: buttonText,
    messageColor: messageColor,
    bgColor: successColor,
    buttonColor: buttonColor,
    position: position,
    duration: duration,
    onMainTap: onMainTap,
  );
}

popSnackWarning(
    {String title = "Attention",
    String? message,
    String buttonText = "OK",
    Color messageColor = Colors.white,
    Color buttonColor = Colors.white,
    SnackPosition position = SnackPosition.TOP,
    Duration? duration = const Duration(seconds: 3),
    Function()? onMainTap}) {
  popSnack(
    title: title,
    message: message,
    buttonText: buttonText,
    messageColor: messageColor,
    bgColor: warningColor,
    buttonColor: buttonColor,
    position: position,
    duration: duration,
    onMainTap: onMainTap,
  );
}
