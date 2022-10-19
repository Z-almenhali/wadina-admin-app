import 'package:admin_app/MyStudent.dart';
import 'package:admin_app/customerModel.dart';
import 'package:admin_app/dash.dart';
import 'package:admin_app/driver_model.dart';
import 'package:admin_app/driverlist.dart';
import 'package:admin_app/profileScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'company.dart';
import 'schedual.dart';
import 'package:admin_app/customerSchedual.dart';

class CustomerList extends StatefulWidget {
  const CustomerList(
      {Key? key,
      required this.firestore,
      required this.firebaseAuth,
      required this.firebaseStorage})
      : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  Customermodel customer = Customermodel();
  List<Customermodel> customerList = [];
  Schedual schedual = Schedual();

  List<Schedual> customerschedualList = [];

  @override
  void initState() {
    super.initState();
    getCustomers();
  }

  Future<void> getCustomers() async {
    User? user = widget.firebaseAuth.currentUser;

    widget.firestore
        .collection('company')
        .doc(user!.uid)
        .collection('customer')
        .get()
        .then(
      (value) {
        value.docs.forEach((element) {
          customer = Customermodel.fromMap(element.data());
          setState(() {
            customerList.add(customer);
          });
        });
      },
    );

    return;
  }

  launchMap(String lat, String long) async {
    String mapSchema =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    print(mapSchema);
    if (!await launch(mapSchema)) throw 'Could not launch $mapSchema';
  }

  @override
  Widget build(BuildContext context) {
    // print(customerschedualList.length);
    return Scaffold(
        backgroundColor: Color(0xff6b88ef),
        appBar: AppBar(
          backgroundColor: Color(0xff6b88ef),
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
                child: RefreshIndicator(
                    onRefresh: () async {
                      customerList = [];

                      await getCustomers();
                      return Future.value();
                    },
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: customerList.length,
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
                                      Text(customerList[index].name.toString()),
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
                                              Icons.location_city,
                                              color: Color(0xff6b88ef),
                                              size: 30.0,
                                            ),
                                          ),
                                          Text("School Name: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(customerList[index]
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
                                                  fontWeight: FontWeight.bold)),
                                          Text(customerList[index]
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
                                                  fontWeight: FontWeight.bold)),
                                          Text(customerList[index]
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
                                                  fontWeight: FontWeight.bold)),
                                          Text(customerList[index]
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
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        studentProfile(
                                                            firestore: widget
                                                                .firestore,
                                                            firebaseAuth: widget
                                                                .firebaseAuth,
                                                            firebaseStorage: widget
                                                                .firebaseStorage,
                                                            customer:
                                                                customerList[
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
                                                        color:
                                                            Color(0xff6b88ef))),
                                              ],
                                            ),
                                          ),
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        customerschedual(
                                                            firestore: widget
                                                                .firestore,
                                                            firebaseAuth: widget
                                                                .firebaseAuth,
                                                            firebaseStorage: widget
                                                                .firebaseStorage,
                                                            customer:
                                                                customerList[
                                                                    index])),
                                              );
                                            },
                                            // => Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       builder: (context) =>
                                            //           studentProfile()),
                                            // ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.schedule,
                                                  color: Color(0xff6b88ef),
                                                  size: 20.0,
                                                ),
                                                Text("Schedual",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff6b88ef))),
                                              ],
                                            ),
                                          ),
                                          OutlinedButton(
                                            onPressed: () {
                                              launchMap(
                                                  customerList[index]
                                                      .latitude
                                                      .toString(),
                                                  customerList[index]
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
                                                  size: 20.0,
                                                ),
                                                Text("location",
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
              )
            ])));
  }
}
