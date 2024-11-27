import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:telpoapp/controller/auth_controller.dart';
import 'package:telpoapp/res/colors.dart';
import 'package:telpoapp/res/strings.dart';
import 'package:telpoapp/widgets/change_ip.dart';
import 'package:telpoapp/widgets/loadingIndicator.dart';
import 'package:telpoapp/widgets/submitButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:telpoapp/widgets/inputTextWidget.dart';

import 'homeScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen() : super();

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<LoginScreen> {
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  //final snackBar = SnackBar(content: Text('email ou mot de passe incorrect'));
  final _formKey = GlobalKey<FormState>();
  var authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double r = (175 / 360); //  rapport for web test(304 / 540);
    final coverHeight = screenWidth * r;
    bool _pinned = false;
    bool _snap = false;
    bool _floating = false;

    final widgetList = [
      const Row(
        children: [
          SizedBox(
            width: 28,
          ),
          Text(
            'Bienvenue',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xff000000),
            ),
            textAlign: TextAlign.left,
          ),
          /*IconButton(
              onPressed: () {
                Get.bottomSheet(const ChangeIpForm());
              },
              icon: Icon(Icons.settings))*/
        ],
      ),
      const SizedBox(
        height: 30.0,
      ),
      Form(
          key: _formKey,
          child: Column(
            children: [
              InputTextWidget(
                  controller: _emailController,
                  labelText: "Username",
                  icon: Icons.person,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(
                height: 30.0,
              ),
              InputTextWidget(
                  controller: _pwdController,
                  labelText: "Mots de Passe",
                  icon: Icons.lock,
                  obscureText: true,
                  keyboardType: TextInputType.text),
              /*Padding(
                padding: const EdgeInsets.only(right: 25.0, top: 10.0),
                child: Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          "Mots de passe oublié ?",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ),
                    )),
              ),*/
              const SizedBox(
                height: 40.0,
              ),
              Obx(() {
                return authController.login_process.isTrue
                    ? LoadingIndicator(text: "please wait..")
                    : SubmitButton(
                        onPressed: () {
                          //Get.to(() => HomeScreen());
                          var form = _formKey.currentState;
                          if (form!.validate()) {
                            Map<String, dynamic> creds = {
                              'username': _emailController.text,
                              'password': _pwdController.text,
                            };
                            authController.login(creds);
                          }
                        },
                        text: 'Connexion',
                        bgColor: primaryColor,
                        height: 80,
                      );
              }),
              20.height,
              Text("ID: ${GetStorage().read(DEVICE_ID)}")
            ],
          )),
      const SizedBox(
        height: 15.0,
      ),
      const SizedBox(
        height: 15.0,
      ),
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: coverHeight / 4, //304,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Container(
                color: primaryColor,
                child: Image.asset(
                  "assets/images/logo_transcar.png",
                  height: 50,
                  scale: 2,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(),
                  gradient: LinearGradient(colors: <Color>[
                    primaryColor,
                    primaryColor.withOpacity(0.8)
                  ])),
              width: screenWidth,
              height: 25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            return widgetList[index];
          }, childCount: widgetList.length))
        ],
      ),
      /*bottomNavigationBar: Stack(
        children: [
          Container(
            height: 50.0,
            color: Colors.white,
            child: Center(
                child: Wrap(
              children: [
                Text(
                  "Vous n'avez pas un compte?  ",
                  style: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.bold),
                ),
                Material(
                    child: InkWell(
                  onTap: () {
                    print("sign up tapped");
                    Get.to(() => Container());
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                )),
              ],
            )),
          ),
        ],
      ),*/
    );
  }
}
