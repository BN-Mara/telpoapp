import 'package:flutter_map/plugin_api.dart';
//import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
//import 'package:latlong2/latlong.dart';
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
import 'package:telpoapp/res/strings.dart';
import 'package:telpoapp/screens/dashboardScreen.dart';
import 'package:telpoapp/screens/routesScreen.dart';
//import 'package:telpoapp/widgets/line.dart';
import 'package:telpoapp/widgets/submitButton.dart';
import 'package:telpoapp/widgets/sundry_components.dart';

//import '../widgets/inputTextWidget.dart';

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
  google.GoogleMapController? mapController;
  // For holding Co-ordinates as LatLng
  final List<google.LatLng> polyPoints = [];

//For holding instance of Polyline
  final Set<google.Polyline> polyLines = {};
// For holding instance of Marker
  final Set<google.Marker> markers = {};
  var data;
  // Dummy Start and Destination Points

  void _onMapCreated(google.GoogleMapController controller) {
    mapController = controller;

    if (checkController.markers.isNotEmpty) {
      mapController!.animateCamera(google.CameraUpdate.newLatLngZoom(
          google.LatLng(checkController.markers.first.position.latitude,
              checkController.markers.first.position.longitude),
          12));
    } else {
      locationController.getCurrentPosition().then((value) {
        mapController!.animateCamera(google.CameraUpdate.newLatLngZoom(
            google.LatLng(value.latitude, value.longitude), 12));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckRouteController>(
        init: checkController,
        builder: (controller) {
          if (controller.markers.isNotEmpty) {}
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
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              print("====== Getting polylines ======");
                              print(checkController.polyLines.value);

                              return google.GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition:
                                    const google.CameraPosition(
                                  target: google.LatLng(
                                      -4.307667545627436, 15.291246101191055),
                                  zoom: 13,
                                ),
                                markers: controller.markers,
                                polylines: checkController.polyLines.value,
                                myLocationEnabled: true,
                                trafficEnabled: true,
                              );
                            }),
                          ),
                          Container(
                            width: MediaQuery.sizeOf(context).width / 3.5,
                            child: Obx(() {
                              return Column(children: [
                                checkController.currentRoute.value != null
                                    ? Expanded(
                                        child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: SingleChildScrollView(
                                              child: Column(children: [
                                                const Text(IN_PROGRESS),
                                                16.height,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                      Icons.pin_drop,
                                                      color: greenColor,
                                                      size: 30,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      checkController
                                                                  .currentRoute
                                                                  .value ==
                                                              null
                                                          ? ""
                                                          : '${checkController.currentRoute.value!.origine!}',
                                                      style: secondaryTextStyle(
                                                          size: 15),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                  ],
                                                ),
                                                16.height,
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.pin_drop,
                                                      color: redColor,
                                                      size: 30,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      checkController
                                                                  .currentRoute
                                                                  .value ==
                                                              null
                                                          ? ""
                                                          : '${checkController.currentRoute.value!.destination!}',
                                                      style: secondaryTextStyle(
                                                          size: 15),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                  ],
                                                ),
                                                16.height,
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.people_alt,
                                                      color: redColor,
                                                      size: 30,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      checkController
                                                                  .currentRoute
                                                                  .value ==
                                                              null
                                                          ? ""
                                                          : '${checkController.currentRoute.value!.passengers}',
                                                      style: secondaryTextStyle(
                                                          size: 18),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )),
                                                  ],
                                                ),
                                                16.height,
                                                checkController.currentRoute
                                                            .value!.status ==
                                                        WAITING_STATE
                                                    ? Form(
                                                        key: _formkey,
                                                        child: Column(
                                                          children: [
                                                            TextFormField(
                                                              decoration:
                                                                  textInputDecoration(
                                                                      "Nombre de passagers"),
                                                              controller:
                                                                  checkController
                                                                      .passagerCtr
                                                                      .value,
                                                              keyboardType:
                                                                  const TextInputType
                                                                      .numberWithOptions(
                                                                      signed:
                                                                          false,
                                                                      decimal:
                                                                          false),
                                                            ),
                                                            10.height,
                                                            checkController
                                                                    .process_route_end
                                                                    .isTrue
                                                                ? LinearProgressIndicator()
                                                                : SubmitButton(
                                                                    onPressed:
                                                                        () {
                                                                      if (_formkey
                                                                          .currentState!
                                                                          .validate()) {
                                                                        checkController
                                                                            .endCurrentRoute();
                                                                      }
                                                                    },
                                                                    text:
                                                                        "Valider",
                                                                    bgColor:
                                                                        primaryColor),
                                                            16.height,
                                                          ],
                                                        ))
                                                    : Container(),
                                              ]),
                                            )))
                                    : Expanded(
                                        child: Container(
                                        child: const Center(
                                          child: Text("No active route"),
                                        ),
                                      )),
                                16.height,
                                SubmitButton(
                                  onPressed: () {
                                    Get.to(() => DashboardScreen());
                                  },
                                  text: "Details",
                                  bgColor: primaryColor,
                                  height: 40,
                                  iconSize: 13,
                                ),
                                16.height,
                                Container(
                                    width: 100,
                                    height: 40,
                                    color: whiteColor,
                                    child: IconButton(
                                        icon:
                                            const Icon(Icons.video_camera_back),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return FractionallySizedBox(
                                                  heightFactor: 1,
                                                  child: Container(),
                                                );
                                              });
                                        }))
                              ]);
                            }),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        _key.currentState!.openDrawer();
                                        /*var pose = await locationController
                                      .getCurrentPosition();
                                  _mapctl.move(
                                      LatLng(pose.latitude, pose.longitude),
                                      16.5);*/
                                        //Get.back();
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration:
                                            boxDecorationWithRoundedCorners(
                                          backgroundColor: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.2)),
                                        ),
                                        child: const Icon(
                                          Icons.menu,
                                          color: primaryColor,
                                        ),
                                      )),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                  ),
                                  GestureDetector(
                                      onTap: (() {
                                        authController.logoff();
                                        //checkController.updatingRoute(1);
                                      }),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration:
                                            boxDecorationWithRoundedCorners(
                                          backgroundColor: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.2)),
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
                              Text('Welcome Back',
                                      style: boldTextStyle(size: 20))
                                  .paddingOnly(left: 16, right: 16),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(),
                              ),
                              16.height,
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          );
        });
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
          color: secondaryColor,
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
          border: Border.all(color: secondaryColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: primaryColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [primaryColor, secondaryColor],
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
          color: secondaryColor,
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
        /* SidebarXItem(
          icon: Icons.app_registration,
          label: 'Itineraires',
          onTap: () {
            Get.back();
            Get.to(() => const RoutesScreen());
          },
        ),*/
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
