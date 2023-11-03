import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:telpoapp/controller/recharge_controller.dart';
import 'package:telpoapp/res/colors.dart';
import 'package:telpoapp/widgets/inputTextNoPadding.dart';
import 'package:telpoapp/widgets/submitButton.dart';
import 'package:telpoapp/widgets/sundry_components.dart';
import 'package:telpoapp/widgets/text_styled.dart';

class RechargeForm extends StatelessWidget {
  final String tag;
  RechargeForm({super.key, required this.tag});

  var recController = Get.find<RechargeController>();
  final GlobalKey<FormState> _formkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(children: [
        Row(
          children: [
            Expanded(child: textStyled("Rechage", 15, primaryBlack, grey)),
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
                Text("No : ${tag}"),
                const SizedBox(
                  height: 20,
                ),
                InputTextNoPadding(
                  labelText: "Montant",
                  icon: Icons.money_sharp,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  controller: recController.amount.value,
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return recController.process_recharge.isTrue
                      ? LinearProgressIndicator()
                      : SubmitButton(
                          height: 45,
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              if (double.parse(
                                      recController.amount.value.text) <
                                  500) {
                                popSnackWarning(
                                    message: "Montant inferieur a 500 Fc");
                                return;
                              }
                              Map<String, dynamic> data = {
                                "amount": recController.amount.value.text,
                                "uid": tag
                              };
                              recController.createRecharge(data);
                            }
                          },
                          text: "Valider",
                          bgColor: successColor);
                })
              ],
            )),
      ]),
    );
  }
}
