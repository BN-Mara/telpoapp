import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:telpoapp/controller/auth_controller.dart';
import 'package:telpoapp/controller/check_route.dart';
import 'package:telpoapp/controller/location_controller.dart';
import 'package:telpoapp/controller/route_controller.dart';
import 'package:telpoapp/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:telpoapp/res/colors.dart' as res;
import 'package:telpoapp/screens/dashboardScreen.dart';
import 'package:telpoapp/screens/routesScreen.dart';
import 'package:telpoapp/widgets/line.dart';
import 'package:telpoapp/widgets/submitButton.dart';
import 'package:telpoapp/widgets/sundry_components.dart';

import '../widgets/inputTextWidget.dart';

class HomeDriverScreen extends StatefulWidget {
  const HomeDriverScreen({super.key});

  @override
  State<HomeDriverScreen> createState() => _HomeDriverScreenState();
}

class _HomeDriverScreenState extends State<HomeDriverScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<FormState> _formkey = GlobalKey();
  final routeController = Get.put(RouteController());
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final checkController = Get.find<CheckRouteController>();

  final authController = Get.find<AuthController>();
  final locationController = Get.find<LocationController>();
  final MapController _mapctl = MapController();
  final psgCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        drawer: ExampleSidebarX(controller: _controller),
        body: Container(
            height: Get.height,
            width: Get.width,
            decoration: const BoxDecoration(
                /*image: DecorationImage(
                  image: AssetImage('assets/images/wa_bg.jpg'),
                  fit: BoxFit.cover),*/
                ),
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapctl,
                  options: MapOptions(
                      center: const LatLng(-4.325, 15.322222),
                      zoom: 16.5,
                      maxZoom: 19.0,
                      minZoom: 13),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                      maxZoom: 19.0,
                      minZoom: 13.0,
                    ),
                    CurrentLocationLayer(
                      followOnLocationUpdate: FollowOnLocationUpdate.always,
                      turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
                      style: const LocationMarkerStyle(
                        marker: DefaultLocationMarker(
                          child: Icon(
                            Icons.navigation,
                            color: Colors.white,
                          ),
                        ),
                        markerSize: Size(40, 40),
                        markerDirection: MarkerDirection.heading,
                      ),
                    )
                  ],
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  //_key.currentState!.openDrawer();
                                  var pose = await locationController
                                      .getCurrentPosition();
                                  _mapctl.move(
                                      LatLng(pose.latitude, pose.longitude),
                                      16.5);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: boxDecorationWithRoundedCorners(
                                    backgroundColor: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2)),
                                  ),
                                  child: const Icon(
                                    Icons.menu,
                                    color: primaryColor,
                                  ),
                                )),
                            GestureDetector(
                                onTap: (() {
                                  authController.logoff();
                                }),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: boxDecorationWithRoundedCorners(
                                    backgroundColor: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2)),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.logout,
                                      color: res.errorColor),
                                ))
                          ],
                        ).paddingOnly(left: 16, right: 16, bottom: 16),
                        Text('${authController.user.value != null ? authController.user.value!.fullname : "test testR"},',
                                style: secondaryTextStyle())
                            .paddingOnly(left: 16, right: 16),
                        Text('Welcome Back', style: boldTextStyle(size: 20))
                            .paddingOnly(left: 16, right: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(),
                        ),
                        16.height,
                        Obx(() {
                          return checkController.currentRoute.value != null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                        onTap: () async {
                                          //_key.currentState!.openDrawer();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          decoration:
                                              boxDecorationWithRoundedCorners(
                                            backgroundColor:
                                                Colors.white.withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.2)),
                                          ),
                                          child: Column(children: [
                                            const Icon(
                                              Icons.pin_drop_outlined,
                                              color: greenColor,
                                              size: 40,
                                            ),
                                            Text(
                                              checkController
                                                          .currentRoute.value ==
                                                      null
                                                  ? ""
                                                  : 'Orgine: ${checkController.currentRoute.value!.origine!}',
                                              style:
                                                  secondaryTextStyle(size: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              checkController
                                                          .currentRoute.value ==
                                                      null
                                                  ? ""
                                                  : ' dest: ${checkController.currentRoute.value!.destination!}',
                                              style:
                                                  secondaryTextStyle(size: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              checkController
                                                          .currentRoute.value ==
                                                      null
                                                  ? ""
                                                  : 'passagers: ${checkController.currentRoute.value!.passengers}',
                                              style:
                                                  secondaryTextStyle(size: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                            SubmitButton(
                                                onPressed: () {
                                                  Get.to(
                                                      () => DashboardScreen());
                                                },
                                                text: "Voir tout",
                                                bgColor: primaryColor)
                                          ]),
                                        )),
                                    //Expanded(child: Line()
                                    /*Divider(
                              thickness: 3,
                              height: 5,
                              color: primaryColor,
                            )*/
                                    //),
                                  ],
                                ).paddingOnly(left: 16, right: 16, bottom: 16)
                              : Container();
                        })
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: secondaryColoro,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: primaryWhite,
        textStyle: TextStyle(
            color: primaryColor.withOpacity(0.7), fontWeight: FontWeight.bold),
        selectedTextStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: secondaryColoro),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: primaryColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [primaryColor, secondaryColoro],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: primaryColor.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: const BoxDecoration(
          color: secondaryColoro,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return const SizedBox(
          height: 100,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Stack(children: [
              Icon(Icons.person, size: 60),
              Positioned(
                  top: 40,
                  left: 30,
                  child: Icon(
                    Icons.circle,
                    color: greenColor,
                  ))
            ]), //Image.asset('assets/images/africell_logo.png'),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
          onTap: () {
            Get.back();
            Get.to(() => const HomeDriverScreen());
          },
        ),
        SidebarXItem(
          icon: Icons.home,
          label: 'Dashboard',
          onTap: () {
            Get.back();
            Get.to(() => const DashboardScreen());
          },
        ),
        SidebarXItem(
          icon: Icons.app_registration,
          label: 'Itineraires',
          onTap: () {
            Get.back();
            Get.to(() => const RoutesScreen());
          },
        ),
        /* const SidebarXItem(
          icon: Icons.people,
          label: 'People',
        ),
        const SidebarXItem(
          icon: Icons.favorite,
          label: 'Favorites',
        ),
        const SidebarXItem(
          iconWidget: FlutterLogo(size: 20),
          label: 'Flutter',
        ),
        */
      ],
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) => Container(
                height: 100,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).canvasColor,
                  boxShadow: const [BoxShadow()],
                ),
              ),
            );
          default:
            return Text(
              pageTitle,
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Dashboard';
    case 2:
      return 'Itineraires';
    case 3:
      return 'Favorites';
    case 4:
      return 'Custom iconWidget';
    case 5:
      return 'Profile';
    case 6:
      return 'Settings';
    default:
      return 'Not found page';
  }
}

final divider = Divider(color: white.withOpacity(0.3), height: 1);
