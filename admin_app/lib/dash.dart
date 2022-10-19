import 'package:admin_app/Customermodel.dart';
import 'package:admin_app/company.dart';

import 'package:admin_app/driver_model.dart';
import 'package:admin_app/profileScreen.dart';
import 'package:admin_app/schedual.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_driver.dart';

import 'busPage.dart';
import 'customerList.dart';
import 'login.dart';
import 'driverlist.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen(
      {Key? key,
      required this.firestore,
      required this.firebaseAuth,
      required this.firebaseStorage})
      : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  @override
  _DashboardScreen createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen> {
  late Size size;

  Customermodel customer = Customermodel();
  List<Customermodel> customerList = [];
  Schedual schedual = Schedual();
  List<Schedual> schedualList = [];
  DriverModel driver = DriverModel();
  List<DriverModel> driversList = [];
  String currentDay = DateFormat('EEEE').format(DateTime.now());
  int currentDayNumber = DateTime.now().weekday;

  void initState() {
    if (currentDayNumber == 7) {
      currentDayNumber = 1;
    } else {
      currentDayNumber++;
    }
    User? user = widget.firebaseAuth.currentUser;
    setState(() {
      assingCustomersToDriver();
    });
  }

  Widget build(BuildContext context) {
    User? user = widget.firebaseAuth.currentUser;
    size = MediaQuery.of(context).size;
    return Scaffold(
      //drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xff6b88ef),
        title: Text(
          "Home",
          textAlign: TextAlign.center,
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
      body: Stack(
        children: <Widget>[
          Container(
            color: Color(0xff6b88ef),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: GridView.count(
                crossAxisCount: 2,
                children: <Widget>[
                  createGridItem(0),
                  createGridItem(1),
                  createGridItem(2),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget createGridItem(int position) {
    var color = Color(0xfffedb5b);
    var icondata = Icons.add;
    var iconText = '';

    switch (position) {
      case 0:
        icondata = Icons.ballot; //customer icon
        iconText = 'Customer';
        break;
      case 1:
        icondata = Icons.badge; //driver icon
        iconText = 'Driver';
        break;
      case 2:
        icondata = Icons.airport_shuttle; //bus icon
        iconText = 'Bus';
        break;
    }

    return Builder(builder: (context) {
      return Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10, bottom: 9, top: 9),
        child: Card(
          elevation: 10,
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: InkWell(
            onTap: () //use this to navigate to another interface
                {
              switch (iconText) {
                case 'Customer':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerList(
                            firestore: widget.firestore,
                            firebaseAuth: widget.firebaseAuth,
                            firebaseStorage: widget.firebaseStorage)),
                  );
                  break;
                case 'Driver':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => driverlist(
                            firestore: widget.firestore,
                            firebaseAuth: widget.firebaseAuth,
                            firebaseStorage: widget.firebaseStorage)),
                  );
                  break;
                case 'Bus':
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => busListWidget(
                              firestore: widget.firestore,
                              firebaseAuth: widget.firebaseAuth,
                              firebaseStorage: widget.firebaseStorage)));
                  break;
              }
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    icondata,
                    size: 50,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      iconText,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> assingCustomersToDriver() async {
    await FirebaseFirestore.instance
        .collection('company')
        .doc(widget.firebaseAuth.currentUser!.uid)
        .collection('driver')
        .get()
        .then((value) => value.docs.forEach((element) {
              setState(() {
                driver = DriverModel.fromMap(element.data());
                driversList.add(driver);
              });
            }));

    await FirebaseFirestore.instance
        .collection('company')
        .doc(widget.firebaseAuth.currentUser!.uid)
        .collection('customer')
        .get()
        .then((value) => value.docs.forEach((element) {
              customer = Customermodel.fromMap(element.data());
              setState(() {
                customerList.add(customer);
              });
            }));

    for (DriverModel driver1 in driversList) {
      for (var customer1 in customerList) {
        if (customer1.schoolName == driver1.destination) {
          if (driver1.neighborhood == customer1.neighbrhoods) {
            try {
              FirebaseFirestore.instance
                  .collection('schadule')
                  .doc(customer1.customerid)
                  .collection('days')
                  .doc(currentDayNumber.toString() + "" + currentDay)
                  .get()
                  .then((value) {
                if (value.data() != null) {
                  setState(() {
                    schedual = Schedual.fromMap(value.data());
                  });
                  if (schedual.active == true) {
                    print(customer1.name);
                    if (driver1.shiftTime == schedual.pickupTime) {
                      FirebaseFirestore.instance
                          .collection('company')
                          .doc(widget.firebaseAuth.currentUser!.uid)
                          .collection('customer')
                          .doc(customer1.customerid)
                          .update({'driverPickup': driver1.id.toString()});
                    }

                    if (driver1.shiftTime == schedual.dropoff) {
                      FirebaseFirestore.instance
                          .collection('company')
                          .doc(widget.firebaseAuth.currentUser!.uid)
                          .collection('customer')
                          .doc(customer1.customerid)
                          .update({'driverDropoff': driver1.id.toString()});
                    }
                  }
                }
              }).catchError((erro) {
                print('test is ' + erro.toString());
              });
            } catch (error) {
              print("the error is" + error.toString());
            }
          }
        }
      }
    }
  }
}
