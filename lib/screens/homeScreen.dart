import 'package:dropdown_search/dropdown_search.dart';
//import 'package:flutter_map/plugin_api.dart';
//import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:latlong2/latlong.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:telpoapp/controller/auth_controller.dart';
import 'package:telpoapp/controller/location_controller.dart';
import 'package:telpoapp/controller/route_controller.dart';
import 'package:telpoapp/model/place.dart';
import 'package:telpoapp/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:telpoapp/res/colors.dart' as res;
import 'package:telpoapp/res/strings.dart';
import 'package:telpoapp/screens/dashboardScreen.dart';
import 'package:telpoapp/screens/homeDriverScreen.dart';
import 'package:telpoapp/screens/routesScreen.dart';
import 'package:telpoapp/widgets/inputDecoration.dart';
import 'package:telpoapp/widgets/inputParentWidget.dart';
import 'package:telpoapp/widgets/inputTextNoPadding.dart';
import 'package:telpoapp/widgets/inputTextWidget.dart';
//import 'package:telpoapp/widgets/line.dart';
import 'package:telpoapp/widgets/submitButton.dart';
import 'package:telpoapp/widgets/sundry_components.dart';
import 'package:telpoapp/widgets/text_styled.dart';

//import '../widgets/inputTextWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<FormState> _formkey = GlobalKey();
  final routeController = Get.put(RouteController());
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  final authController = Get.find<AuthController>();
  final locationController = Get.find<LocationController>();
  //final MapController _mapctl = MapController();
  final psgCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    routeController.getPlaces("");
    authController.resumeAlert();
  }

  @override
  Widget build(BuildContext context) {
    print(routeController.departPlaces.length);
    print(routeController.destPlaces.length);

    return SafeArea(
      child: Scaffold(
        key: _key,
        drawer: ExampleSidebarX(controller: _controller),
        body: Container(
            height: Get.height,
            width: Get.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/transcar_bg.jpg'),
                  fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        rowMenuAndLogout(),
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
                          return routeController.activeRoute.value != null
                              ? showRoute()
                              : Container();
                        })
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Obx(() {
                      return routeController.search_process.isTrue ||
                              routeController.paying_process.isTrue
                          ? const LinearProgressIndicator()
                          : Container(
                              padding: const EdgeInsets.all(8),
                              child: routeController.activeRoute.value != null
                                  ? Row(children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: routeController
                                                  .process_add_pass.isTrue
                                              ? LinearProgressIndicator()
                                              : SubmitButton(
                                                  onPressed: () {
                                                    psgCtl.text = "0";

                                                    showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        builder: (context) {
                                                          return FractionallySizedBox(
                                                            heightFactor: 0.95,
                                                            child: Container(
                                                              color:
                                                                  primaryWhite,
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    child: textStyled(
                                                                        "Ajouter passagers",
                                                                        30,
                                                                        primaryColor,
                                                                        primaryBlack
                                                                            .withOpacity(0.2)),
                                                                  ),
                                                                  16.height,
                                                                  Divider(),
                                                                  16.height,
                                                                  addPassengersForm()
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });

                                                    /*Get.defaultDialog(
                                                        title:
                                                            "Ajouter passagers",
                                                        content:
                                                            addPassengersForm());*/
                                                  },
                                                  text: "+Passagers",
                                                  bgColor: primaryColor,
                                                  icon: Icons.add,
                                                  height: 80,
                                                )),
                                      Expanded(
                                          child: routeController
                                                  .process_route_end.isTrue
                                              ? LinearProgressIndicator()
                                              : SubmitButton(
                                                  onPressed: () {
                                                    routeController
                                                        .endCurrentRoute();
                                                  },
                                                  text: "Arrive",
                                                  bgColor: redColor,
                                                  icon: Icons.stop_outlined,
                                                  height: 80,
                                                  color: redColor,
                                                ))
                                    ])
                                  : routeController.process_create_route.isTrue
                                      ? LinearProgressIndicator()
                                      : SubmitButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (context) {
                                                  return FractionallySizedBox(
                                                    heightFactor: 0.95,
                                                    child: Container(
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              child: textStyled(
                                                                  "ITINERAIRE",
                                                                  30,
                                                                  primaryColor,
                                                                  primaryBlack
                                                                      .withOpacity(
                                                                          0.5)),
                                                            ),
                                                            10.height,
                                                            Divider(),
                                                            Expanded(
                                                                child:
                                                                    routeAdd())
                                                          ],
                                                        )),
                                                  );
                                                });
                                            /*Get.bottomSheet(
                                                FractionallySizedBox(
                                              heightFactor: 1,
                                              child: Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        child:
                                                            Text("ITINERAIRE"),
                                                      ),
                                                      10.height,
                                                      Divider(),
                                                      Expanded(
                                                          child: routeAdd())
                                                    ],
                                                  )),
                                            ));*/
                                            /*showDialog(
                                              context: context,
                                              builder: (_) => StatefulBuilder(
                                                builder: (BuildContext context,
                                                    setState) {
                                                  return AlertDialog(
                                                      scrollable: true,
                                                      title: const Text(
                                                          "ITINERAIRE"),
                                                      content: routeAdd());
                                                },
                                              ),
                                            );*/
                                          },
                                          text: "Nouvel itinéraire",
                                          bgColor: primaryColor,
                                          icon: Icons.add,
                                          height: 80,
                                        ),
                            );
                    })),
              ],
            )),
      ),
    );
  }

  Widget showRoute() {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: () async {
              //_key.currentState!.openDrawer();
            },
            child: Container(
              padding: EdgeInsets.all(8),
              width: 200,
              height: 200,
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Center(
                  child: Column(children: [
                const Icon(
                  Icons.pin_drop_outlined,
                  color: greenColor,
                  size: 100,
                ),
                Text(
                  routeController.activeRoute.value == null
                      ? ""
                      : routeController.activeRoute.value!.origine!,
                  style: secondaryTextStyle(size: 20),
                  textAlign: TextAlign.center,
                ),
              ])),
            )),
        const Expanded(
            /*child: Line()*/
            child: Divider(
          thickness: 3,
          height: 5,
          color: Colors.transparent,
        )),
        GestureDetector(
            onTap: (() {}),
            child: Container(
              padding: EdgeInsets.all(8),
              width: 200,
              height: 200,
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              alignment: Alignment.center,
              child: Column(children: [
                const Icon(
                  Icons.pin_drop,
                  color: res.errorColor,
                  size: 100,
                ),
                Text(
                  routeController.activeRoute.value == null
                      ? ""
                      : routeController.activeRoute.value!.destination!,
                  style: secondaryTextStyle(size: 20),
                  textAlign: TextAlign.center,
                )
              ]),
            ))
      ],
    ).paddingOnly(left: 16, right: 16, bottom: 16));
  }

  Widget rowMenuAndLogout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: () async {
              _key.currentState!.openDrawer();
              /*var pose = await locationController
                                      .getCurrentPosition();
                                  _mapctl.move(
                                      LatLng(pose.latitude, pose.longitude),
                                      16.5);*/
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
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
              width: 80,
              height: 80,
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.logout, color: res.errorColor),
            ))
      ],
    ).paddingOnly(left: 16, right: 16, bottom: 16);
  }

  Widget routeAdd() {
    print(routeController.departPlaces.length);
    print("=== dest: ${routeController.destPlaces.value}");
    return Container(child: Obx(() {
      return Container(
          child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InputParentWidget(
                      child: DropdownSearch<Place>(
                        filterFn: (item, filter) {
                          return item.name!
                              .toUpperCase()
                              .contains(filter.toUpperCase());
                        },
                        popupProps: PopupProps.menu(
                          searchFieldProps: TextFieldProps(
                            cursorColor: primaryColor,
                            decoration: textInputDecoration("Rechercher..."),
                          ),
                          showSearchBox: true,
                          showSelectedItems: false,
                          //showSearchBox: true,
                          disabledItemFn: (Place p) =>
                              p.name == routeController.toContrl.value,
                        ),
                        items: routeController.departPlaces.value,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration:
                                //textInputDecoration("Depart", "", ""),
                                myInputDecoration(Icons.flag, "Depart")),
                        onChanged: (value) {
                          if (value != null) {
                            routeController.fromContrl.value = value.name!;
                            // _province = value;
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Ce champs est requis";
                          } else {
                            return null;
                          }
                        },
                        itemAsString: (Place p) => p.name!,
                        //selectedItem: provices.first,
                      ),
                    ),
                    30.height,
                    InputParentWidget(
                        child: DropdownSearch<Place>(
                      filterFn: (item, filter) {
                        return item.name!
                            .toUpperCase()
                            .contains(filter.toUpperCase());
                      },
                      popupProps: PopupProps.menu(
                        searchFieldProps: TextFieldProps(
                          cursorColor: primaryColor,
                          decoration: textInputDecoration("rechercher..."),
                        ),
                        showSearchBox: true,
                        showSelectedItems: false,
                        //showSearchBox: true,
                        disabledItemFn: (Place p) =>
                            p.name == routeController.fromContrl.value,
                      ),
                      items: routeController.destPlaces.value,
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration:
                              //textInputDecoration("Destination", "", ""),
                              InputDecoration(
                        icon: Icon(
                          Icons.pin_drop,
                          color: Colors.black,
                          size: 32.0, /*Color(0xff224597)*/
                        ),
                        labelText: "Destination",
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 18.0),
                        hintText: '',
                        enabledBorder: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        border: InputBorder.none,
                      )),
                      onChanged: (value) {
                        if (value != null) {
                          routeController.toContrl.value = value.name!;
                          // _province = value;
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Ce champs est requis";
                        } else {
                          return null;
                        }
                      },
                      itemAsString: (Place p) => p.name!,
                      //selectedItem: provices.first,
                    )),
                    30.height,
                    InputTextWidget(
                        controller: routeController.passangenrContrl.value,
                        labelText: "Nombre de passagers",
                        icon: Icons.people,
                        obscureText: false,
                        keyboardType: TextInputType.numberWithOptions())
                    /*TextFormField(
                      decoration: textInputDecoration("Nombre de passagers"),
                      controller: routeController.passangenrContrl.value,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                    )*/
                    ,
                    40.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: SubmitButton(
                          onPressed: () {
                            var form = _formkey.currentState;
                            if (form!.validate()) {
                              routeController.setCurrentRoute();
                              Get.back();
                            }
                          },
                          text: "Valider",
                          bgColor: greenColor,
                          height: 80.0,
                        ))
                      ],
                    )
                  ],
                ),
              )));
    }));
  }

  Widget addPassengersButtons() {
    return Row(
      children: [
        Expanded(
          child: SubmitButton(
            bgColor: primaryBlack.withOpacity(0.5),
            onPressed: () {
              int p = int.parse(psgCtl.text) + 1;
              psgCtl.text = "$p";
            },
            text: "+1",
            height: 80,
            color: primaryBlack.withOpacity(0.5),
            icon: Icons.add,
          ),
        ),
        Expanded(
          child: SubmitButton(
            bgColor: primaryBlack,
            onPressed: () {
              int p = int.parse(psgCtl.text) + 5;
              psgCtl.text = "$p";
            },
            text: "+5",
            height: 80,
            color: primaryBlack.withOpacity(0.5),
            icon: Icons.add,
          ),
        ),
        Expanded(
          child: SubmitButton(
            bgColor: redColor.withOpacity(0.5),
            onPressed: () {
              int p = int.parse(psgCtl.text) - 5;
              psgCtl.text = "$p";
            },
            text: "-1",
            height: 80,
            color: redColor.withOpacity(0.5),
            icon: Icons.remove,
          ),
        ),
        Expanded(
          child: SubmitButton(
            bgColor: redColor,
            onPressed: () {
              int p = int.parse(psgCtl.text) - 5;
              psgCtl.text = "$p";
            },
            text: "-5",
            height: 80,
            icon: Icons.remove,
            color: redColor,
          ),
        )
      ],
    );
  }

  Widget addPassengersForm() {
    return Container(
        child: Form(
            child: SingleChildScrollView(
                child: Column(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: InputTextNoPadding(
              labelText: "Nombre de passagers",
              icon: Icons.people,
              obscureText: false,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: false, decimal: false),
              readOnly: true,
              controller: psgCtl,
            )
            /*TextFormField(
              decoration: textInputDecoration("Nombre de passagers"),
              controller: psgCtl,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: false, decimal: false),
              readOnly: true,
            )*/
            ),
        50.height,
        addPassengersButtons(),
        70.height,
        SubmitButton(
          onPressed: () {
            routeController.addPassengers(psgCtl.text);
            Get.back();
          },
          text: "Valider",
          bgColor: primaryColor,
          height: 80,
        )
      ],
    ))));
  }
}

class ExampleSidebarX extends StatelessWidget {
  ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;
  var auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    String home = auth.user.value!.roles!.contains(DRIVER) &&
            auth.user.value!.roles!.contains(CONVEYOR)
        ? "Conducteur"
        : "Accueil";
    var sideItems = <SidebarXItem>[];
    if (auth.user.value!.roles!.contains(CONVEYOR)) {
      sideItems.addAll([
        SidebarXItem(
          icon: Icons.home,
          label: 'Accueil',
          onTap: () {
            Get.back();
            Get.to(() => const HomeScreen());
          },
        )
      ]);
    }
    if (auth.user.value!.roles!.contains(DRIVER)) {
      sideItems.addAll([
        SidebarXItem(
          icon: Icons.home,
          label: home,
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
        )
      ]);
    }
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
              color: primaryColor.withOpacity(0.7),
              fontWeight: FontWeight.bold),
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
        items:
            sideItems /*[
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
          onTap: () {
            Get.back();
            Get.to(() => const HomeScreen());
          },
        ),*/
        /*SidebarXItem(
          icon: Icons.home,
          label: 'Dashboard',
          onTap: () {
            Get.back();
            Get.to(() => const DashboardScreen());
          },
        ),*/
        /* SidebarXItem(
          icon: Icons.app_registration,
          label: 'Itineraires',
          onTap: () {
            Get.back();
            Get.to(() => const RoutesScreen());
          },
        ),*/
        /* SidebarXItem(
          icon: Icons.app_registration,
          label: 'Home Driver',
          onTap: () {
            Get.back();
            Get.to(() => const HomeDriverScreen());
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
        //],
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
      return 'Home Driver';
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
