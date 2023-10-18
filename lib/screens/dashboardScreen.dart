import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:telpoapp/controller/route_controller.dart';
import 'package:telpoapp/res/colors.dart';
import 'package:telpoapp/screens/routesScreen.dart';
import 'package:telpoapp/widgets/my_files.dart';
import 'package:telpoapp/widgets/submitButton.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final routeController = Get.find<RouteController>();

  @override
  void initState() {
    super.initState();
    routeController.getMyRoutes();
  }

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
        ],
      ),
      const SizedBox(
        height: 12.0,
      ),
      Container(
        child: Obx(() => Column(
              children: [
                //Text("data"),
                const SizedBox(
                  height: 12.0,
                ),
                /*Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: MyFiles(
                      infos: routeController.routesInfoList.value,
                    )),*/
                Card(
                  elevation: 2,
                  margin: EdgeInsets.all(30),
                  child: Column(children: [
                    Text("Details"),
                    16.height,
                    Text(
                        'Total d\'Itineraires: ${routeController.todayRoutes.value}'),
                    const Divider(),
                    13.height,
                    Text(
                        'Total Passagers: ${routeController.todayPassengers.value}'),
                    const Divider(),
                    13.height,
                    Text('Montant: ${routeController.todayAmount.value}'),
                    16.height,
                    SubmitButton(
                        onPressed: () {
                          Get.to(() => const RoutesScreen(
                                flag: 1,
                              ));
                        },
                        text: "voir list",
                        bgColor: blackColor)
                  ]),
                ),

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
                  height: 15.0,
                ),
              ],
            )),
      ),
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
            title: const Text("Dashboard",
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
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: coverHeight / 4, //304,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Container(
                  color: primaryColor,
                  child:
                      Container() /*Image.asset(
                  "assets/images/wlogo.png",
                ),*/
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
