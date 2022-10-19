import 'package:admin_app/company.dart';
import 'package:admin_app/customerModel.dart';
import 'package:admin_app/dash.dart';
import 'package:admin_app/drivercustomerlist.dart';
import 'package:admin_app/driver_model.dart';
import 'package:admin_app/driverlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:url_launcher/url_launcher.dart';

import 'editDriver.dart';

class myDriver extends StatefulWidget {
  const myDriver({
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
  State<myDriver> createState() => _myDriverState();
}

class _myDriverState extends State<myDriver> {
  final controller = TextEditingController();
  @override
  DriverModel driverinfo = DriverModel();
  late DriverModel driver1;

  List<DriverModel> infolist = [];
  late Company company;
  @override
  void initState() {
    User? user = widget.firebaseAuth.currentUser;

    widget.firestore
        .collection('company')
        .doc(user!.uid)
        .collection('driver')
        .doc(widget.driver.id.toString())
        .get()
        .then((value) {
      driverinfo = DriverModel.fromMap(value.data());

      setState(() {
        driverinfo;
      });
    });
  }

  launchMap(String lat, String long) async {
    String mapSchema =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    print(mapSchema);
    if (!await launch(mapSchema)) throw 'Could not launch $mapSchema';
  }

  @override
  Widget build(BuildContext context) {
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
                        builder: (context) => driverlist(
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
              widget.driver.Name!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(50.0),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Column(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 140,
                          width: 140,
                          child: Stack(
                            fit: StackFit.expand,
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Image.asset("assets/CameraSVg.jpg")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
              const Divider(
                height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 5, 10, 5),
                    child: Icon(
                      Icons.person,
                      color: Color(0xff6b88ef),
                      size: 20.0,
                    ),
                  ),
                  Text("Name: ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Microsoft_Phagspa')),
                  Text(driverinfo.Name.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontFamily: 'Microsoft_Phagspa')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 5, 10, 5),
                    child: Icon(
                      Icons.email,
                      color: Color(0xff6b88ef),
                      size: 20.0,
                    ),
                  ),
                  Text("Email: ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Microsoft_Phagspa')),
                  Text(driverinfo.email.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontFamily: 'Microsoft_Phagspa'))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 5, 10, 5),
                    child: Icon(
                      Icons.phone,
                      color: Color(0xff6b88ef),
                      size: 20.0,
                    ),
                  ),
                  Text("Phone Number: ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Microsoft_Phagspa')),
                  Text(driverinfo.phoneNumber.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontFamily: 'Microsoft_Phagspa')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 5, 10, 5),
                    child: Icon(
                      Icons.badge,
                      color: Color(0xff6b88ef),
                      size: 20.0,
                    ),
                  ),
                  Text("National ID / Iqama: ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Microsoft_Phagspa')),
                  Text(driverinfo.driverid.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontFamily: 'Microsoft_Phagspa')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 5, 10, 5),
                    child: Icon(
                      Icons.house,
                      color: Color(0xff6b88ef),
                      size: 20.0,
                    ),
                  ),
                  Text("Neighborhood: ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Microsoft_Phagspa')),
                  Text(driverinfo.neighborhood.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontFamily: 'Microsoft_Phagspa')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 5, 10, 5),
                    child: Icon(
                      Icons.location_city,
                      color: Color(0xff6b88ef),
                      size: 20.0,
                    ),
                  ),
                  Text("Destination: ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Microsoft_Phagspa')),
                  Text(driverinfo.destination.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontFamily: 'Microsoft_Phagspa')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 5, 10, 5),
                    child: Icon(
                      Icons.departure_board,
                      color: Color(0xff6b88ef),
                      size: 20.0,
                    ),
                  ),
                  Text("Shift: ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Microsoft_Phagspa')),
                  Text(driverinfo.shiftTime.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontFamily: 'Microsoft_Phagspa')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 5, 10, 5),
                    child: Icon(
                      Icons.directions_bus,
                      color: Color(0xff6b88ef),
                      size: 20.0,
                    ),
                  ),
                  Text("Bus: ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Microsoft_Phagspa')),
                  Text(driverinfo.bus.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontFamily: 'Microsoft_Phagspa')),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => editDriver(
                                firestore: widget.firestore,
                                firebaseAuth: widget.firebaseAuth,
                                firebaseStorage: widget.firebaseStorage,
                                driver: driverinfo)),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: Color(0xff6b88ef),
                          size: 30.0,
                        ),
                        Text("Edit Profile",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Microsoft_Phagspa',
                                fontSize: 18,
                                color: Color(0xff6b88ef))),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => driverCustomer(
                                firestore: widget.firestore,
                                firebaseAuth: widget.firebaseAuth,
                                firebaseStorage: widget.firebaseStorage,
                                driver: driverinfo)),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          color: Color(0xff6b88ef),
                          size: 30.0,
                        ),
                        Text("Student",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Microsoft_Phagspa',
                                fontSize: 18,
                                color: Color(0xff6b88ef)))
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    // => Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           studentProfile()),
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Color(0xff6b88ef),
                          size: 30.0,
                        ),
                        Text("Track",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Microsoft_Phagspa',
                                fontSize: 18,
                                color: Color(0xff6b88ef)))
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('company')
                          .doc(widget.firebaseAuth.currentUser!.uid)
                          .collection('driver')
                          .doc(widget.driver.id)
                          .delete();
                      FirebaseFirestore.instance
                          .collection('driver')
                          .doc(widget.driver.id)
                          .delete();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => driverlist(
                                firestore: widget.firestore,
                                firebaseAuth: widget.firebaseAuth,
                                firebaseStorage: widget.firebaseStorage)),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.remove_circle_outline,
                          color: Color(0xff6b88ef),
                          size: 30.0,
                        ),
                        Text("Delete Driver",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Microsoft_Phagspa',
                                fontSize: 18,
                                color: Color(0xff6b88ef)))
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}
