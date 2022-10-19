import 'package:admin_app/add_driver.dart';

import 'package:admin_app/customerModel.dart';
import 'package:admin_app/MyDriver.dart';
import 'package:admin_app/dash.dart';
import 'package:admin_app/drivercustomerlist.dart';
import 'package:admin_app/driver_model.dart';
import 'package:admin_app/profileScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'company.dart';
import 'location_tracking.dart';
import 'login.dart';

class driverlist extends StatefulWidget {
  @override
  const driverlist(
      {Key? key,
      required this.firestore,
      required this.firebaseAuth,
      required this.firebaseStorage})
      : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  _driversScreenState createState() => _driversScreenState();
}

class _driversScreenState extends State<driverlist> {
  @override
  DriverModel driver = DriverModel();
  List<DriverModel> driverList = [];

  @override
  void initState() {
    super.initState();
    getdriver();
  }

  Future<void> getdriver() async {
    // Check for the day
    //
    User? user = widget.firebaseAuth.currentUser;
    widget.firestore
        .collection('company')
        .doc(user!.uid)
        .collection('driver')
        .orderBy('name')
        .get()
        .then((value) {
      value.docs.forEach(
        (element) {
          setState(() {
            driver = DriverModel.fromMap(element.data());
            driverList.add(driver);
          });
          print(driver.Name);
        },
      );
      //setState(() { driverList.add(driver);});
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    print(driverList.length);
    return Scaffold(
        backgroundColor: Color(0xff6b88ef),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashboardScreen(
                            firestore: widget.firestore,
                            firebaseAuth: widget.firebaseAuth,
                            firebaseStorage: widget.firebaseStorage)),
                  );
                },
              );
            },
          ),
          backgroundColor: Color(0xff6b88ef),
          title: Center(
            child: Text(
              "Drivers List",
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => profileScreen(
                              firestore: widget.firestore,
                              firebaseAuth: widget.firebaseAuth,
                              firebaseStorage: widget.firebaseStorage)));
                  // Navigator.push(context, new MaterialPageRoute(builder: (context) => myDriver(  driverList[index],)));
                  // );
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
                  child: RefreshIndicator(
                      onRefresh: () {
                        driverList = [];

                        getdriver();
                        return Future.value();
                      },
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: driverList.length,
                          itemBuilder: (context, index) => Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 10, 30, 10),
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
                                        Text(driverList[index].Name.toString()),
                                      ]),
                                      children: [
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
                                                Icons.badge,
                                                color: Color(0xff6b88ef),
                                                size: 30.0,
                                              ),
                                            ),
                                            Text("National ID / Iqama: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(driverList[index]
                                                .driverid
                                                .toString()),
                                          ],
                                        ),
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
                                                Icons.phone,
                                                color: Color(0xff6b88ef),
                                                size: 30.0,
                                              ),
                                            ),
                                            Text("Phone Number: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(driverList[index]
                                                .phoneNumber
                                                .toString()),
                                          ],
                                        ),
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
                                                Icons.email,
                                                color: Color(0xff6b88ef),
                                                size: 30.0,
                                              ),
                                            ),
                                            Text("Email: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(driverList[index]
                                                .email
                                                .toString()),
                                          ],
                                        ),
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
                                                Icons.house,
                                                color: Color(0xff6b88ef),
                                                size: 30.0,
                                              ),
                                            ),
                                            Text("Neighborhood: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(driverList[index]
                                                .neighborhood
                                                .toString()),
                                          ],
                                        ),
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
                                                Icons.location_city,
                                                color: Color(0xff6b88ef),
                                                size: 30.0,
                                              ),
                                            ),
                                            Text("Destination: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(driverList[index]
                                                .destination
                                                .toString()),
                                          ],
                                        ),
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
                                            Text("Shift: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(driverList[index]
                                                .shiftTime
                                                .toString()),
                                          ],
                                        ),
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
                                                Icons.directions_bus,
                                                color: Color(0xff6b88ef),
                                                size: 30.0,
                                              ),
                                            ),
                                            Text("Bus: ",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(driverList[index]
                                                .bus
                                                .toString()),
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
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => myDriver(
                                                          firestore:
                                                              widget.firestore,
                                                          firebaseAuth: widget
                                                              .firebaseAuth,
                                                          firebaseStorage: widget
                                                              .firebaseStorage,
                                                          driver: driverList[
                                                              index])),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.person,
                                                    color: Color(0xff6b88ef),
                                                    size: 20.0,
                                                  ),
                                                  Text("Profile",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                              0xff6b88ef))),
                                                ],
                                              ),
                                            ),
                                            OutlinedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          driverCustomer(
                                                              firestore: widget
                                                                  .firestore,
                                                              firebaseAuth: widget
                                                                  .firebaseAuth,
                                                              firebaseStorage:
                                                                  widget
                                                                      .firebaseStorage,
                                                              driver:
                                                                  driverList[
                                                                      index])),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.people,
                                                    color: Color(0xff6b88ef),
                                                    size: 20.0,
                                                  ),
                                                  Text("Student",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                              0xff6b88ef))),
                                                ],
                                              ),
                                            ),
                                            OutlinedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LocationTracking(
                                                              firestore: widget
                                                                  .firestore,
                                                              firebaseAuth: widget
                                                                  .firebaseAuth,
                                                              firebaseStorage:
                                                                  widget
                                                                      .firebaseStorage)),
                                                );
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
                                                    size: 20.0,
                                                  ),
                                                  Text("Track",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                              0xff6b88ef))),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )))),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                padding: EdgeInsets.only(bottom: 30.0),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddDriver(
                              firestore: widget.firestore,
                              firebaseAuth: widget.firebaseAuth,
                              firebaseStorage: widget.firebaseStorage)),
                    );
                  },
                  child: Icon(Icons.add, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(15),
                    primary: Color(0xfffedb5b), // <-- Button color
                    onPrimary: Color(0xfffff15c), // <-- Splash color
                  ),
                ),
              ),
            ])));
  }
}
