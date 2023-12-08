import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:telpoapp/controller/recharge_controller.dart';
import 'package:telpoapp/res/colors.dart';
import 'package:telpoapp/widgets/inputTextWidget.dart';
import 'package:telpoapp/widgets/loadingIndicator.dart';
import 'package:telpoapp/widgets/submitButton.dart';
import 'package:telpoapp/widgets/text_styled.dart';

class RegisterCardScreen extends StatefulWidget {
  final String? uid;
  const RegisterCardScreen({super.key, this.uid});

  @override
  State<RegisterCardScreen> createState() => _RegisterCardScreenState();
}

class _RegisterCardScreenState extends State<RegisterCardScreen> {
  final _formKey = GlobalKey<FormState>();
  var recController = Get.find<RechargeController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    //saleController.process_sale.value = false;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text("Reservation",
            style: TextStyle(
              color: primaryWhite,
              fontFamily: 'Segoe UI',
              fontSize: 30,
              shadows: [
                Shadow(
                  color: Color(0xba000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                )
              ],
            )),
        //centerTitle: true,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: primaryWhite),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          width: screenWidth,
          height: screenHeight,
          child: SingleChildScrollView(
            //controller: controller,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 0.5,
                      color: secondaryColor,
                      child: Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Center(
                                      child: textStyled(
                                          "Card No: ${widget.uid}",
                                          16,
                                          primaryBlack,
                                          grey)),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  InputTextWidget(
                                    controller: recController.cardHolder.value,
                                    labelText: "Nom complet",
                                    icon: Icons.person,
                                    obscureText: false,
                                    keyboardType: TextInputType.name,
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  InputTextWidget(
                                    controller: recController.phoneNumber.value,
                                    labelText: "Telephone",
                                    icon: Icons.person,
                                    obscureText: false,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  InputTextWidget(
                                    controller: recController.balance.value,
                                    labelText: "Balance",
                                    icon: Icons.person,
                                    obscureText: false,
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),

                              /*InputTextWidget(
                      controller: saleController.iccidEnd.value,
                      labelText: "ICCID end",
                      icon: Icons.sim_card,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      
                      ),*/

                              Obx(() {
                                //calculQty();
                                return Column(children: [
                                  const SizedBox(
                                    height: 25.0,
                                  ),
                                  recController.process_register.isTrue
                                      ? LoadingIndicator(text: "Sending...")
                                      : SubmitButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              recController
                                                  .registerCard(widget.uid!);
                                            }
                                          },
                                          text: "Enregistrer",
                                          bgColor: primaryColor,
                                          height: 80,
                                        ),
                                ]);
                              })
                            ],
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
