import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:latlong2/latlong.dart';
//import 'package:nb_utils/nb_utils.dart';
//import 'package:nb_utils/nb_utils.dart';
//import 'package:nb_utils/nb_utils.dart';
import 'package:telpoapp/api/route.dart';
import 'package:telpoapp/api/vehicle.dart';
import 'package:telpoapp/controller/auth_controller.dart';
import 'package:telpoapp/controller/check_route.dart';
import 'package:telpoapp/controller/location_controller.dart';
import 'package:telpoapp/model/card_paid.dart';
import 'package:telpoapp/model/client_card.dart';
import 'package:telpoapp/model/itineraire.dart';
import 'package:telpoapp/model/line.dart';
import 'package:telpoapp/model/my_card_info.dart';
import 'package:telpoapp/model/place.dart';
import 'package:telpoapp/model/ticket_price.dart';
import 'package:telpoapp/model/vehicle.dart';
import 'package:telpoapp/res/colors.dart';
import 'package:telpoapp/res/strings.dart';
import 'package:telpoapp/screens/routesScreen.dart';
import 'package:telpoapp/utils/utilities.dart';
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
  //var ticketPrices = <TicketPrice>[].obs;
  //var ticketPrice = Rxn<TicketPrice>();
  var playerSuccess = AudioPlayer();
  var playerFail = AudioPlayer();
  var currentCardPayList = <CardPay>[].obs;
  var line = Rxn<Line>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //getPlaces();
    getCards();
    initPlayer();
  }

  initPlayer() async {
    print("====== Initialize Bip Player ======");
    await playerSuccess.setAsset('assets/images/valid.mp3');
    await playerFail.setAsset('assets/images/invalid.mp3');
    print("====== End Initialize Bip Player ======");
  }

  @override
  onReady() async {
    //getPlaces();
    //getCards();
  }
  @override
  onDispose() {
    playerSuccess.dispose();
    playerFail.dispose();
    super.dispose();
  }

  getPlaces(String regionId) async {
    process_places.value = true;
    print("======= Getting Places region ${regionId} ======");
    Place.placesfromJson(GetStorage().read(PLACES_KEY));
    //RouteApi.getPlaces().then((value) async {
    places.value = await Place.placesfromJson(GetStorage()
        .read(PLACES_KEY)); //await Place.placesfromJson(value.data);
    places.value =
        places.value.where((element) => element.line == regionId).toList();

    destPlaces.value.clear();

    destPlaces.value = places.value;

    var cLoc = await Get.find<LocationController>().getCurrentPosition();

    departPlaces.clear();
    //departure places in 1km from current position
    places.value.forEach((element) {
      double d = getDistanceList(LatLng(cLoc.latitude, cLoc.longitude),
          LatLng(element.latitude!, element.longitude!));
      print(
          "======= Distance between ${cLoc.latitude},${cLoc.longitude} and ${element.latitude!},${element.longitude!} is $d Km");
      if (d <= AppUtils.distanceFromDeparture) {
        print("====== Added ${element.name}");
        departPlaces.value.add(element);
      }
    });

    print(
        "======= end Getting Places region $regionId :: ${places.length} ======");
    process_places.value = false;
    //}).onError((DioException error, stackTrace) {
    // print('error get Places: ${error.response!.data}');
    // process_places.value = false;
    //}).whenComplete(() {
    // process_places.value = false;
    //});
  }

  getTicketPrices() async {
    print("====== getting prices ======");
    //print(auth.vehicle.value);
    //print(auth.vehicle.value!.region!.replaceAll("/api/regions/", ""));
    print(auth.vehicle.value!.toJson());
    /*RouteApi.getTicketPrice(
            auth.vehicle.value!.region!.replaceAll("/api/regions/", ""))
        .then((value) async {
      //ticketPrice.value = await TicketPrice.ticketsfromJson(value.data);
      ticketPrice.value = TicketPrice.fromJson(value.data);
      Future.delayed(Duration(seconds: 60), getTicketPrices);
    }).onError((DioException error, stackTrace) {
      print("getprices errror");
      print("${error.response!.data}");
      Future.delayed(Duration(seconds: 60), getTicketPrices);
    }).whenComplete(() {});*/
  }

  replaceRegion(String r) {
    r.replaceAll("/api/regions/", "");
  }

  getCards() async {
    if (auth.user.value != null && auth.user.value!.roles!.contains(CONVEYOR)) {
      print("===== loads cards =======");
      process_get_cards.value = true;
      RouteApi.getCards().then((value) async {
        cardList.value = await ClientCard.ClientCardsfromJson(value.data);

        process_get_cards.value = false;
        print("===== End loads cards ${cardList.value.length} =======");
        Future.delayed(Duration(seconds: 5), getCards);
      }).onError((DioException error, stackTrace) {
        print('====== error get cardList: ${error.response!.data} ======');
        process_get_cards.value = false;
        Future.delayed(Duration(seconds: 5), getCards);
      }).whenComplete(() {
        process_get_cards.value = false;
      });
    } else {
      Future.delayed(Duration(seconds: 5), getCards);
    }
  }

  setCurrentRoute() async {
    if (!locationController.isEnabled.value) {
      process_create_route.value = false;
      popSnackError(
          message: "Veuillez activer le service de localisation et réessayer.");
      return;
    }
    try {
      print("====== new route ======");
      process_create_route.value = true;
      var pose = await locationController.getCurrentPosition();
      print("${pose}");
      var itineraire = Itineraire(
          conveyor: "/api/users/${auth.user.value!.id}", //auth.user.value!.id,
          origine: fromContrl.value,
          destination: toContrl.value,
          startLat: pose.latitude,
          startLng: pose.longitude,
          startingTime: DateTime.now().toIso8601String(),
          deviceId: GetStorage().read(DEVICE_ID),
          isActive: true,
          vehicle: '/api/vehicles/${auth.vehicle.value!.id!}',
          passengers: int.parse(passangenrContrl.value.text),
          ticketPrice: auth.line.value!.ticketPrice,
          status: ONGOING_STATE,
          paymentType: auth.line.value!.paymentType,
          line: "/api/lines/${auth.line.value!.id}");
      //print(itineraire.toJson());
      //activeRoute.value = itineraire;
      //process_create_route.value = false;
      //Get.back();

      RouteApi.postCurrentRoute(itineraire.toJson()).then((value) {
        activeRoute.value = Itineraire.fromJson(value.data);
        process_create_route.value = false;
        print(
            "====== end new route activeRoute ${activeRoute.value!.id} ======");
        //start active route
      }).onError((DioException error, stackTrace) {
        process_create_route.value = false;
        print("====== route:${error.response!.data} ======");
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
    print("====== ending route: ${activeRoute.value!.id} ======");
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
      //destPlaces.value = getPlaceByName(activeRoute.value!.destination!);
      activeRoute.value = null;
      process_route_end.value = false;
      print("====== End ending route: ${value.data} ======");
      clearForm();
      currentCardPayList.value.clear();
    }).onError((DioException error, stackTrace) {
      print("update: ${error.response!.data}");
      process_route.value = false;
    });
  }

  List<Place> getPlaceByName(String name) {
    if (places.value != null && places.value.length > 0) {
      return places.value.where((element) => element.name == name).toList();
    } else {
      return [];
    }
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
    print("====== Getting My Routes ======");
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
      todayAmount.value = 0;

      todayList.value.forEach((element) {
        if (element.driverPassengers != null) {
          todayPassengers.value =
              todayPassengers.value + element.driverPassengers!;
          todayAmount.value = todayAmount.value +
              (element.driverPassengers! * element.ticketPrice!);
        }
      });
      todayRoutes.value = todayList.value.length;
      /*todayAmount.value =
          todayPassengers.value * ticketPrice.value!.price!.toDouble();*/
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
      print(
          "====== End Getting My Routes todayList ${todayList.value.length}======");
      process_route_list.value = false;
    }).onError((DioException error, stackTrace) {
      print("====== Getting My Routes Error ======");
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
    print("====== ${nfcUid} ======");
    print("====== ${cardList.length} ========");

    paying_process.value = true;
    /*var cardPaid = currentCardPayList.value
        .firstWhereOrNull((element) => element.uid == nfcUid);*/
    /*if (cardPaid == null) {
      currentCardPayList
          .add(CardPay(uid: nfcUid, time: DateTime.now(), count: 1));
    } else {
      //var dif = cardPaid.checkTime(DateTime.now());
      if (dif < 60) {
        popSnackWarning(
            title: "Information!",
            message: "Reesayez apres  ${(60 - dif)} secondes");
        paying_process.value = false;
        return;
      } else {
        currentCardPayList.value
            .firstWhereOrNull((element) => element.uid == nfcUid)!
            .update();
      }
    }*/
    Map<String, dynamic> card = {
      "uid": nfcUid,
      "amount": auth.line.value!.ticketPrice ?? 0,
      "routeId": activeRoute.value!.id
    };
    var index = cardList.value.indexWhere((element) => element.uid == nfcUid);
    var c = 0.0;
    if (index > -1) {
      if (!cardList[index].isActive!) {
        await playFailSound();
        PaymentAlert("Erreur!", "Carte désactivée", Icons.cancel, errorColor);

        // player.play();
        paying_process.value = false;
        auth.sendDataToAndroidOut();
        return;
      }
      if (auth.line.value!.paymentType == PAYMENT_TYPE.last) {
        if (!cardList[index].isSubscribed!) {
          await playFailSound();

          PaymentAlert("Erreur!", "Échec de la souscription...", Icons.cancel,
              errorColor);

          paying_process.value = false;
          auth.sendDataToAndroidOut();
          return;
        }
      } else {
        var c = cardList[index].balance! - auth.line.value!.ticketPrice!;
        if (cardList[index].uid == null) {
          //player2.setLoopMode(LoopMode.off);
          await playFailSound();
          PaymentAlert(
              "Erreur!", "Carte désactivée...", Icons.cancel, errorColor);

          // player.play();
          paying_process.value = false;
          auth.sendDataToAndroidOut();

          return;
        }
        if (c < 0) {
          //getCards();
          await playFailSound();

          PaymentAlert(
              "Erreur!", "Balance insufisante...", Icons.cancel, errorColor);

          paying_process.value = false;
          auth.sendDataToAndroidOut();
          return;
        }
      }
      addPassengers("1");
      //player.setLoopMode(LoopMode.off);
      cardList[index].balance = c;
      cardList[index].updatedAt = DateTime.now().toIso8601String();
      await playSuccessSound();
      PaymentAlert("Félicitations!", "Paiement accepté.", Icons.check_circle,
          successColor);

      RouteApi.postCardPay(card).then((value) async {
        //paying_process.value = false;
        //getCards();

        auth.sendDataToAndroidOut();
        paying_process.value = false;

        //addPassengers("1");
        //player.setLoopMode(LoopMode.off);
        //await player.setAsset('assets/images/valid.mp3');
        //player.play();
      }).onError((DioException error, stackTrace) async {
        paying_process.value = false;
        auth.sendDataToAndroidOut();
        print("error: ${error.response!.data}");
        //To Do: Log error and Payment to File so that it will retry later,
        //player2.setLoopMode(LoopMode.off);
        //await player2.setAsset('assets/images/invalid.mp3');
        //player2.play();
      }).whenComplete(() {
        paying_process.value = false;
      });
    } else {
      await playFailSound();
      await PaymentAlert(
          "Erreur!", "Carte invalide...", Icons.cancel, errorColor);
      //getCards();

      //auth.sendDataToAndroidOut();
      paying_process.value = false;

      return;
    }
  }

  Future<void> playSuccessSound() async {
    await playerSuccess.play();
    await playerSuccess.stop();
    initPlayer();
    //await playerSuccess.dispose();
  }

  Future<void> playFailSound() async {
    await playerFail.play();
    await playerFail.stop();
    initPlayer();
    //await playerFail.dispose();
  }

  clearForm() {
    fromContrl.value = "";
    passangenrContrl.value.clear();
    passangenrContrl.value.text = "";

    toContrl.value = "";
    getPlaces(auth.vehicle.value!.line!);
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
      auth.sendDataToAndroidOut();
    });
  }

  double getDistanceList(LatLng currentPos, LatLng nearPos) {
    var distance = new Distance();
    var km = distance.as(LengthUnit.Kilometer, currentPos, nearPos);
    return km;
  }
}
