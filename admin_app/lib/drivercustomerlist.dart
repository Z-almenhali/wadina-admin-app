import 'package:admin_app/customerModel.dart';
import 'package:admin_app/profileScreen.dart';
import 'package:admin_app/schedual.dart';
import 'package:admin_app/driver_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class driverCustomer extends StatefulWidget {
  driverCustomer({
    Key? key,
    required this.firestore,
    required this.firebaseAuth,
    required this.firebaseStorage,
    required this.driver,
  }) : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final DriverModel driver;

  @override
  State<driverCustomer> createState() => _driverCustomerState();
}

class _driverCustomerState extends State<driverCustomer> {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.green;
  }

  launchMap(String lat, String long) async {
    String mapSchema =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    print(mapSchema);
    if (!await launch(mapSchema)) throw 'Could not launch $mapSchema';
  }

  Customermodel customer = Customermodel();
  List<Customermodel> customerList = [];

  List<Customermodel> drivercustomerList = [];
  Schedual schedual = Schedual();
  List<Schedual> customerSchedual = [];
  String currentDay = DateFormat('EEEE').format(DateTime.now());
  int currentDayNumber = DateTime.now().weekday;
  void initState() {
    if (currentDayNumber == 7) {
      currentDayNumber = 1;
    } else {
      currentDayNumber++;
    }
    super.initState();
    getAssignedCustomer();
  }

  Future<void> getAssignedCustomer() async {
    User? user = widget.firebaseAuth.currentUser;
    await widget.firestore
        .collection('company')
        .doc(user!.uid)
        .collection('customer')
        .get()
        .then((value) => value.docs.forEach((element) {
              customer = Customermodel.fromMap(element.data());
              customerList.add(customer);
            }));
    for (var customer1 in customerList) {
      if (customer1.pickupDriver == widget.driver.id) {
        widget.firestore
            .collection('schadule')
            .doc(customer1.customerid)
            .collection('days')
            .doc(currentDayNumber.toString() + "" + currentDay)
            .get()
            .then((value) {
          if (value != null) {
            schedual = Schedual.fromMap(value.data());
            setState(() {
              customerSchedual.add(schedual);
            });
          }
        });
        setState(() {
          drivercustomerList.add(customer1);
        });
      } else if (customer1.dropoffDriver == widget.driver.id) {
        widget.firestore
            .collection('schadule')
            .doc(customer1.customerid)
            .collection('days')
            .doc(currentDayNumber.toString() + "" + currentDay)
            .get()
            .then((value) {
          schedual = Schedual.fromMap(value.data());
          setState(() {
            customerSchedual.add(schedual);
          });
        });
        setState(() {
          drivercustomerList.add(customer1);
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff6b88ef),
        appBar: AppBar(
          backgroundColor: Color(0xff6b88ef),
          title: Center(
            child: Text(
              "Customers List",
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => profileScreen(
                            firestore: widget.firestore,
                            firebaseAuth: widget.firebaseAuth,
                            firebaseStorage: widget.firebaseStorage)),
                  );
                },
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30.0,
                ))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(children: [
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          drivercustomerList.length & customerSchedual.length,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  dividerColor: Colors.transparent,
                                  backgroundColor: Colors.white),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: ExpansionTile(
                                  backgroundColor: Colors.white,
                                  title: Row(children: [
                                    Text(drivercustomerList[index]
                                        .name
                                        .toString()),
                                  ]),
                                  children: [
                                    Row(
                                      children: [
                                        Column(children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      26, 5, 10, 5),
                                                  child: Icon(
                                                    Icons.departure_board,
                                                    color: Color(0xff6b88ef),
                                                    size: 30.0,
                                                  ),
                                                ),
                                              ]),
                                        ]),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Pick-up time: ",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(customerSchedual[index]
                                                    .pickupTime
                                                    .toString())
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Drop-Off time: ",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(customerSchedual[index]
                                                    .dropoff
                                                    .toString()),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(26, 5, 10, 5),
                                          child: Icon(
                                            Icons.location_city,
                                            color: Color(0xff6b88ef),
                                            size: 30.0,
                                          ),
                                        ),
                                        Text("School Name: ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(drivercustomerList[index]
                                            .schoolName
                                            .toString())
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(26, 5, 10, 5),
                                          child: Icon(
                                            Icons.house,
                                            color: Color(0xff6b88ef),
                                            size: 30.0,
                                          ),
                                        ),
                                        Text("Neighborhood: ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(drivercustomerList[index]
                                            .neighbrhoods
                                            .toString())
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(26, 5, 10, 5),
                                          child: Icon(
                                            Icons.email,
                                            color: Color(0xff6b88ef),
                                            size: 30.0,
                                          ),
                                        ),
                                        Text("Email: ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(drivercustomerList[index]
                                            .email
                                            .toString())
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(26, 5, 10, 5),
                                          child: Icon(
                                            Icons.phone,
                                            color: Color(0xff6b88ef),
                                            size: 30.0,
                                          ),
                                        ),
                                        Text("Phone Number: ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(drivercustomerList[index]
                                            .phoneNumber
                                            .toString())
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            launchMap(
                                                drivercustomerList[index]
                                                    .latitude
                                                    .toString(),
                                                drivercustomerList[index]
                                                    .longitude
                                                    .toString());
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                color: Color(0xff6b88ef),
                                                size: 30.0,
                                              ),
                                              Text("Open location",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Color(0xff6b88ef))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))),
            ])));
  }
}
