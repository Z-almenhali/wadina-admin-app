import 'package:admin_app/profileScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'addBus.dart';
import 'bus.dart';
import 'dash.dart';
import 'driver_model.dart';

class busListWidget extends StatefulWidget {
  const busListWidget(
      {Key? key,
      required this.firestore,
      required this.firebaseAuth,
      required this.firebaseStorage})
      : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  @override
  _busListWidgetState createState() => _busListWidgetState();
}

class _busListWidgetState extends State<busListWidget> {
  @override
  User? user = FirebaseAuth.instance.currentUser;
  Bus bus = Bus();
  List<Bus> busList = [];
  DriverModel driver = DriverModel();
  List<DriverModel> driverList = [];
  final List<String> nameList = [];
  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  String? _btnSelectecVal;
  int check = 0;

  void initState() {
    super.initState();
    getBuses();
    getdriver();
    print('in initState');
  }

  Future<void> getBuses() async {
    FirebaseFirestore.instance
        .collection('company')
        .doc(user!.uid)
        .collection('bus')
        .get()
        .then((value) {
      value.docs.forEach(
        (element) {
          print('CHECK check 123');

          bus = Bus.fromMap(element.data());
          print(bus.busNumber);
          setState(() {
            busList.add(bus);
          });
        },
      );
    });
    print('at the end of getBus method');
    return;
  }

  Future<void> getdriver() async {
    FirebaseFirestore.instance
        .collection('company')
        .doc(user!.uid)
        .collection('driver')
        .get()
        .then((value) {
      value.docs.forEach(
        (element) {
          print('2345');
          driver = DriverModel.fromMap(element.data());
          print(driver.Name);
          setState(() {
            driverList.add(driver);
          });
        },
      );
    });
    print('at the end of getDriver method');
    return;
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
              "Buses List",
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
                onRefresh: () {
                  busList = [];
                  getBuses();
                  getdriver();
                  check = 0;
                  return Future.value();
                },
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: busList.length,
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
                                  Text("Bus "),
                                  Text(busList[index].busNumber.toString()),
                                ]),
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(26, 5, 10, 5),
                                        child: Icon(
                                          Icons.calendar_view_day_outlined,
                                          color: Color(0xff6b88ef),
                                          size: 30.0,
                                        ),
                                      ),
                                      Text("Plate Number: ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(busList[index].busPlate.toString())
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(26, 5, 10, 5),
                                        child: Icon(
                                          Icons.person,
                                          color: Color(0xff6b88ef),
                                          size: 30.0,
                                        ),
                                      ),
                                      Text("Assigned driver: ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(getAssignedDriver(
                                          busList[index].busNumber.toString()))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(26, 5, 10, 5),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 30.0,
                                        ),
                                      ),
                                      //add driver menu code
                                      Text("Assign New Driver: ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      DropdownButton(
                                          value: _btnSelectecVal,
                                          hint: Text("Choose driver"),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() =>
                                                  _btnSelectecVal = newValue);
                                            }
                                          },
                                          items: getItems())
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          print('before updateDriver method');
                                          print(busList[index]
                                              .busNumber
                                              .toString());
                                          updateDriver(busList[index]
                                              .busNumber
                                              .toString());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text("Done",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff6b88ef))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
              )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                padding: EdgeInsets.only(bottom: 30.0),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => addBusForm(
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

  List<DropdownMenuItem<String>> getItems() {
    print(driverList.length);
    print(nameList.length);
    if (check == 0) {
      for (int i = 0; i < driverList.length; i++) {
        nameList.add(driverList[i].Name.toString());
      }
      print(nameList.length);
      _dropDownMenuItems = nameList
          .map(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: new SizedBox(width: 100.0, child: Text(value)),
            ),
          )
          .toList();
      check = 1;
    }
    print("inside getItems!!!!!!!!!!");
    return _dropDownMenuItems;
  }

  String getAssignedDriver(String busNum) {
    print('attempt to get driver');
    print(driverList.length);
    for (int i = 0; i < driverList.length; i++) {
      print('inside loop');
      if (driverList[i].bus.toString() == busNum) {
        print('inside if');
        print(driverList[i].Name.toString());
        return driverList[i].Name.toString();
      }
    }

    return "No Driver Assigned";
  }

  void updateDriver(String busNum) async {
    print('inside updateDriver method');
    String? driveruid;
    for (int i = 0; i < driverList.length; i++) {
      print('inside for');
      print('driver $i');
      print(driverList[i].Name.toString());
      if (driverList[i].Name.toString() == _btnSelectecVal.toString()) {
        print('inside if');
        print(driverList[i].Name.toString());
        print(_btnSelectecVal.toString());
        driveruid = driverList[i].id.toString();
        print('driver id $driveruid');

        FirebaseFirestore.instance
            .collection('company')
            .doc(user!.uid)
            .collection('driver')
            .doc(driveruid)
            .update({"busNumber": busNum}).whenComplete(() async {
          print("Completed");
        }).catchError((e) => print(e));
      }
    }

    print('at the end of updateDriver method');
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => busListWidget(
                firestore: widget.firestore,
                firebaseAuth: widget.firebaseAuth,
                firebaseStorage: widget.firebaseStorage)));
  }
}
