import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
//import 'package:nb_utils/nb_utils.dart';
import 'package:telpoapp/api/route.dart';
import 'package:telpoapp/controller/auth_controller.dart';
import 'package:telpoapp/controller/location_controller.dart';
import 'package:telpoapp/model/client_card.dart';
import 'package:telpoapp/model/itineraire.dart';
import 'package:telpoapp/model/my_card_info.dart';
import 'package:telpoapp/model/place.dart';
import 'package:telpoapp/model/ticket_price.dart';
import 'package:telpoapp/res/colors.dart';
import 'package:telpoapp/res/strings.dart';
import 'package:telpoapp/screens/routesScreen.dart';
import 'package:telpoapp/widgets/sundry_components.dart';

class RouteController extends GetxController {
  var fromContrl = "".obs;
  var toContrl = "".obs;
  var passangenrContrl = TextEditingController().obs;
  var increasePassen = TextEditingController().obs;
  var locationController = Get.find<LocationController>();
  var auth = Get.find<AuthController>();
  var process_route = false.obs;
  var activeRoute = Rxn<Itineraire>();
  var routesInfo = Rxn<CloudStorageInfo>();
  var routeList = <Itineraire>[].obs;
  var process_route_list = false.obs;
  var todayList = <Itineraire>[].obs;
  var monthList = <Itineraire>[].obs;
  var weekList = <Itineraire>[].obs;
  var yearList = <Itineraire>[].obs;
  var routesInfoList = <CloudStorageInfo>[].obs;
  var process_places = false.obs;
  var places = <Place>[].obs;
  var destPlaces = <Place>[].obs;
  var departPlaces = <Place>[].obs;
  var process_create_route = false.obs;
  var process_route_end = false.obs;
  var process_add_pass = false.obs;
  var todayRoutes = Rx(0);
  var todayPassengers = Rx(0);
  var todayAmount = Rx(0.0);
  var search_process = false.obs;
  var paying_process = false.obs;

  var cardList = <ClientCard>[].obs;
  var process_get_cards = false.obs;
  var ticketPrice = <TicketPrice>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getPlaces();
    getCards();
    getTicketPrices();
  }

  @override
  onReady() async {
    getMyRoutes();
    getPlaces();
    getCards();
    getTicketPrices();
  }

  getPlaces() async {
    process_places.value = true;
    RouteApi.getPlaces().then((value) async {
      places.value = await Place.placesfromJson(value.data);
      destPlaces.value = places.value;
      departPlaces.value = places.value;
      print(places);
      process_places.value = false;
    }).onError((DioException error, stackTrace) {
      print('error get Places: ${error.response!.data}');
      process_places.value = false;
    }).whenComplete(() {
      process_places.value = false;
    });
  }

  getTicketPrices() async {
    RouteApi.getTicketPrice().then((value) async {
      ticketPrice.value = await TicketPrice.ticketsfromJson(value.data);
    }).onError((DioException error, stackTrace) {
      print("${error.response!.data}");
    }).whenComplete(() {});
  }

  getCards() async {
    print("loads card");
    process_get_cards.value = true;
    RouteApi.getCards().then((value) async {
      cardList.value = await ClientCard.ClientCardsfromJson(value.data);
      print("cardList: ${cardList.length}");

      process_get_cards.value = false;
    }).onError((DioException error, stackTrace) {
      print('error get cardList: ${error.response!.data}');
      process_get_cards.value = false;
    }).whenComplete(() {
      process_get_cards.value = false;
    });
  }

  setCurrentRoute() async {
    if (!locationController.isEnabled.value) {
      process_create_route.value = false;
      popSnackError(
          message: "Veuillez activer le service de localisation et réessayer.");
      return;
    }
    try {
      process_create_route.value = true;
      var pose = await locationController.getCurrentPosition();
      var itineraire = Itineraire(
          conveyor: "/api/users/${auth.user.value!.id}", //auth.user.value!.id,
          origine: fromContrl.value,
          destination: toContrl.value,
          startLat: pose.latitude,
          startLng: pose.longitude,
          startingTime: DateTime.now().toIso8601String(),
          deviceId: GetStorage().read(DEVICE_ID),
          isActive: true,
          vehicle: '/api/vehicles/1',
          passengers: int.parse(passangenrContrl.value.text),
          status: ONGOING_STATE);
      //print(itineraire.toJson());
      //activeRoute.value = itineraire;
      //process_create_route.value = false;
      //Get.back();

      RouteApi.postCurrentRoute(itineraire.toJson()).then((value) {
        activeRoute.value = Itineraire.fromJson(value.data);
        process_create_route.value = false;
        //start active route
      }).onError((DioException error, stackTrace) {
        process_create_route.value = false;
        print("route:${error.response!.data}");
      }).whenComplete(() {
        process_create_route.value = false;
        update();
      });
    } catch (e) {
      process_create_route.value = false;
      print(e);
    }
  }

  endCurrentRoute() async {
    process_route_end.value = true;
    var pose = await locationController.getCurrentPosition();
    activeRoute.value!.endLng = pose.longitude;
    activeRoute.value!.endLat = pose.latitude;
    activeRoute.value!.isActive = true;
    activeRoute.value!.endingTime = DateTime.now().toIso8601String();
    activeRoute.value!.status = WAITING_STATE;

    //process_route.value = false;
    //activeRoute.value = null;

    print(activeRoute.value!.toJson());

    RouteApi.putCurrentRoute(activeRoute.value!.toJson()).then((value) {
      destPlaces.value = getPlaceByName(activeRoute.value!.destination!);
      activeRoute.value = null;
      process_route_end.value = false;
      clearForm();
    }).onError((DioException error, stackTrace) {
      print("update: ${error.response!.data}");
      process_route.value = false;
    });
  }

  List<Place> getPlaceByName(String name) {
    return places.value.where((element) => element.name == name).toList();
  }

  void addPassengers(String text) {
    process_add_pass.value = true;
    var rs = activeRoute.value!.passengers! + int.parse(text);
    if (rs < 0) {
      popSnackError(message: "Nombre de passagers invalide");
      process_add_pass.value = false;
      return;
    }
    activeRoute.value!.passengers = rs;
    Map<String, dynamic> rt = {
      "id": activeRoute.value!.id,
      "passengers": activeRoute.value!.passengers
    };
    update();
    RouteApi.putCurrentRoute(rt).then((value) {
      print(value.data);
      process_add_pass.value = false;
    }).onError((DioException error, stackTrace) {
      print("update: ${error.response!.data}");
      process_add_pass.value = false;
    });
  }

  getMyRoutes() async {
    routesInfo.value = CloudStorageInfo(
        title: "Itineraires",
        totalStorage: "itineraires",
        numOfFiles: routeList.value.length,
        color: primaryWhite,
        svgSrc: "assets/icons/doc_file.svg",
        onPress: () => Get.to(() => const RoutesScreen()));
    process_route_list.value = true;
    var f = NumberFormat.compact(locale: "en_US");
    RouteApi.getList().then((value) async {
      print(value.data);
      routeList.value = await Itineraire.itinerairesfromJson(value.data);
      print(routeList.value.length);
      routesInfo.value = CloudStorageInfo(
          title: "Itineraires",
          totalStorage: "itineraires",
          numOfFiles: routeList.value.length,
          color: primaryWhite,
          svgSrc: "assets/icons/doc_file.svg",
          onPress: () => Get.to(() => const RoutesScreen()));
      try {
        //var t = DateTime.parse(routeList.value.first.startingTime!).isToday;
        //var tr = routeList.value.first.startingTime!.split('T');
        //var dt = DateFormat('yyyy-MM-dd').format(
        //   (DateTime.parse(routeList.value.first.startingTime!).toUtc()));
        //print(tr);
        //print(DateTime.parse(tr.first).day);
        //print(DateTime.now().day);
        //print(t);
        todayList.value = routeList.value
            .where((element) =>
                DateTime.parse(element.startingTime!.split('T').first).day ==
                DateTime.now().day)
            .toList();
      } catch (e) {
        print(e);
      }

      print(todayList.value.length);
      todayPassengers.value = 0;

      todayList.value.forEach((element) {
        if (element.driverPassengers != null) {
          todayPassengers.value =
              todayPassengers.value + element.driverPassengers!;
        }
      });
      todayRoutes.value = todayList.value.length;
      todayAmount.value = todayPassengers.value * 500;
      /*monthList.value = routeList.value
          .where((element) =>
              DateTime.parse(element.startingTime!).month ==
              DateTime.now().month)
          .toList();*/
      /*yearList.value = routeList.value
          .where((element) =>
              DateTime.parse(element.startingTime!).year == DateTime.now().year)
          .toList();
      routesInfoList.value = [];*/
      routesInfoList.value.addAll(
        [
          CloudStorageInfo(
              title: "Aujourd'hui",
              totalStorage: "itineraires",
              numOfFiles: todayList.value.length,
              color: primaryWhite,
              svgSrc: "assets/icons/doc_file.svg",
              onPress: () => Get.to(() => const RoutesScreen(
                    flag: 1,
                  ))),
        ],
      );

      process_route_list.value = false;
    }).onError((DioException error, stackTrace) {
      if (error.response != null) {
        print('${error.response!.data}');
      }
      process_route_list.value = false;
    });
  }

  checkActiveRoute(int vehicleId) async {
    search_process.value = true;
    RouteApi.getCurrentRoute(vehicleId).then((value) async {
      print("in updating!");
      search_process.value = false;
      try {
        var list = await Itineraire.itinerairesfromJson(value.data);
        activeRoute.value = list.last;
        print(activeRoute.toJson());
        if (activeRoute.value != null) {
          //activeRoute.value = currentRoute.value;
          //getData();
        }

        update();
        //Future.delayed(Duration(seconds: 5), checkingRoute);
      } catch (e) {
        print("error list route ");
        activeRoute.value = null;
      }
      //checkingRoute();
    }).onError((DioException error, stackTrace) {
      search_process.value = false;
      if (error.response != null) {
        print('${error.response!.data}');
      } else {
        print(error);
      }
    });
  }

  cardPay(String nfcUid) async {
    paying_process.value = false;
    Map<String, dynamic> card = {
      "uid": nfcUid,
      "amount": 500,
      "routeId": activeRoute.value!.id
    };
    var index = cardList.value.indexWhere((element) => element.uid == nfcUid);
    if (index > -1) {
      var c = cardList[index].balance! - 500;
      if (cardList[index].uid == null) {
        //player2.setLoopMode(LoopMode.off);
        PaymentAlert("Erreur!", "Carte invalide...", Icons.cancel, errorColor);

        var player = AudioPlayer();
        await player.setAsset('assets/images/invalid.mp3');
        player.play();
        paying_process.value = false;

        return;
      }
      if (c < 0) {
        //paying_process.value = false;

        //player2.setLoopMode(LoopMode.off);
        getCards();

        PaymentAlert(
            "Erreur!", "Balance insufisante...", Icons.cancel, errorColor);

        var player = AudioPlayer();
        await player.setAsset('assets/images/invalid.mp3');
        player.play();
        //FlutterBeep.beep(false);
        paying_process.value = false;
        return;
      }
      addPassengers("1");
      //player.setLoopMode(LoopMode.off);
      cardList[index].balance = c;
      cardList[index].updatedAt = DateTime.now().toIso8601String();
      //popSnackPayment("Félicitations!", "Paiement accepté.", Icons.check_circle,
      //  successColor);
      PaymentAlert("Félicitations!", "Paiement accepté.", Icons.check_circle,
          successColor);
      RouteApi.postCardPay(card).then((value) async {
        //paying_process.value = false;
        getCards();
        //addPassengers("1");
        //player.setLoopMode(LoopMode.off);
        //await player.setAsset('assets/images/valid.mp3');
        //player.play();
      }).onError((DioException error, stackTrace) async {
        //paying_process.value = false;
        print("error: ${error.response!.data}");
        //player2.setLoopMode(LoopMode.off);
        //await player2.setAsset('assets/images/invalid.mp3');
        //player2.play();
      }).whenComplete(() {
        paying_process.value = false;
      });
      var player = AudioPlayer();
      await player.setAsset('assets/images/valid.mp3');
      player.play();
    } else {
      PaymentAlert("Erreur!", "Carte invalide...", Icons.cancel, errorColor);
      var player = AudioPlayer();
      await player.setAsset('assets/images/invalid.mp3');
      player.play();
      paying_process.value = false;

      return;
    }
  }

  clearForm() {
    fromContrl.value = "";
    passangenrContrl.value.clear();
    toContrl.value = "";
  }

  PaymentAlert(String title, String message, IconData iconData, Color bgColor) {
    Get.defaultDialog(
        title: title,
        content: Row(
          children: [
            Icon(
              iconData,
              color: primaryWhite,
              size: 40,
            ),
            Expanded(
                child: Text(
              message,
              style: const TextStyle(color: primaryWhite),
            ))
          ],
        ),
        backgroundColor: bgColor,
        titleStyle: const TextStyle(color: primaryWhite));
    Future.delayed(Duration(seconds: 2), () {
      Get.back();
    });
  }
}
