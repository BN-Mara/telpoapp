import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telpoapp/controller/route_controller.dart';
import 'package:telpoapp/model/itineraire.dart';
import 'package:telpoapp/res/colors.dart';

class RoutesScreen extends StatefulWidget {
  final int? flag;
  const RoutesScreen({super.key, this.flag});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  var routeController = Get.find<RouteController>();
  final searchController = TextEditingController();
  List<Itineraire> filteredData = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      filteredData = text.isEmpty
          ? getList()
          : getList()
              .where((item) =>
                      item.origine!
                          .toLowerCase()
                          .contains(text.toLowerCase()) ||
                      item.destination!
                          .toLowerCase()
                          .contains(text.toLowerCase()) ||
                      /*'${item.passengers!}'
                          .toLowerCase()
                          .contains(text.toLowerCase()) ||*/
                      item.startingTime!
                          .toLowerCase()
                          .contains(text.toLowerCase()) //||
                  /*item.endingTime!.toLowerCase().contains(text.toLowerCase())*/)
              .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    filteredData = getList();
    print(filteredData.length);
    //routeController.getMyRoutes();
  }

  List<Itineraire> getList() {
    switch (widget.flag) {
      case 1:
        return routeController.todayList.value;

        break;
      case 2:
        return routeController.monthList.value;

        break;
      case 3:
        return routeController.yearList.value;

        break;
      default:
        return routeController.routeList.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryColor,
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
        onPressed: (){
          print("pressed");
          Get.to(()=> const SaleScreen() );
          //Get.to(()=>const AgentsScreen());
        },
      ),*/
      appBar: AppBar(
        title: const Text("Mes Itineraires",
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
          child: Icon(Icons.arrow_back, color: primaryWhite),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Obx(() {
          print(routeController.routeList.value.length);
          return Container(
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
                child: Container(
                    child: routeController.process_route_list.isTrue
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: primaryColor,
                          ))
                        : getList().isEmpty
                            ? const Center(
                                child: Text(
                                'No Route found!!',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                                textAlign: TextAlign.left,
                              ))
                            : Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: searchController,
                                    decoration: const InputDecoration(
                                      hintText: 'Search...',
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                    ),
                                    onChanged: _onSearchTextChanged,
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columnSpacing: 20,
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: Text(
                                              'Origine',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Destination',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Nbre Passagers',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Nbre Passagers chauf.',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'StartTime',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'ArrivalTime',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ),
                                        ],
                                        rows: List.generate(filteredData.length,
                                            (index) {
                                          final item = filteredData[index];
                                          return DataRow(
                                            color: MaterialStateProperty
                                                .resolveWith((states) {
                                              if (index.isEven) {
                                                return Colors.grey
                                                    .withOpacity(0.3);
                                              } else {
                                                return Colors.white;
                                              }
                                            }),
                                            cells: [
                                              DataCell(Text(
                                                item.origine != null
                                                    ? item.origine!
                                                    : "",
                                                style: TextStyle(fontSize: 11),
                                              )),
                                              DataCell(Text(
                                                item.destination != null
                                                    ? item.destination!
                                                    : "",
                                                style: TextStyle(fontSize: 11),
                                              )),
                                              DataCell(Text(
                                                item.passengers != null
                                                    ? item.passengers.toString()
                                                    : "0",
                                                style: TextStyle(fontSize: 11),
                                              )),
                                              DataCell(Text(
                                                item.driverPassengers != null
                                                    ? item.driverPassengers
                                                        .toString()
                                                    : "0",
                                                style: TextStyle(fontSize: 11),
                                              )),
                                              DataCell(Text(
                                                item.startingTime != null
                                                    ? item.startingTime!
                                                    : "",
                                                style: TextStyle(fontSize: 11),
                                              )),
                                              DataCell(Text(
                                                item.endingTime != null
                                                    ? item.endingTime!
                                                    : "",
                                                style: TextStyle(fontSize: 11),
                                              )),
                                            ],
                                          );
                                        }),
                                      ),
                                    )),
                              ]))),
          );
        }),
      ),
    );
  }
}
