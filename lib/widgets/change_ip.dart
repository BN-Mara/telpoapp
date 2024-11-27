import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:telpoapp/controller/auth_controller.dart';
import 'package:telpoapp/res/colors.dart';
import 'package:telpoapp/res/strings.dart';
import 'package:telpoapp/widgets/inputTextWidget.dart';
import 'package:telpoapp/widgets/submitButton.dart';
import 'package:telpoapp/widgets/sundry_components.dart';
import 'package:telpoapp/widgets/text_styled.dart';

class ChangeIpForm extends StatefulWidget {
  const ChangeIpForm({super.key});

  @override
  State<ChangeIpForm> createState() => _ChangeIpFormState();
}

class _ChangeIpFormState extends State<ChangeIpForm> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  var auth = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child: textStyled("Change remote IP", 15, primaryBlack, grey)),
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.close_outlined,
                  color: primaryColor,
                ))
          ],
        ),
        Divider(),
        10.height,
        Form(
            key: _formkey,
            child: Column(
              children: [
                Text(""),
                const SizedBox(
                  height: 20,
                ),
                InputTextWidget(
                  labelText: "URL",
                  icon: Icons.money_sharp,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  controller: auth.changeURLCtr.value,
                ),
                const SizedBox(
                  height: 20,
                ),
                SubmitButton(
                    height: 45,
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        GetStorage().write(
                            REMOTE_URL_KEY, auth.changeURLCtr.value.text);

                        popSnackSuccess(
                            message: "Remote URL Changed successfully!");
                        return;
                      }
                    },
                    text: "Valider",
                    bgColor: successColor)
              ],
            )),
      ]),
    );
  }
}
