import 'package:admin_app/customerList.dart';
import 'package:admin_app/driver_model.dart';
import 'package:admin_app/profileScreen.dart';
import 'package:admin_app/schedual.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/customerModel.dart';

class customerschedual extends StatefulWidget {
  const customerschedual(
      {Key? key,
      required this.firestore,
      required this.firebaseAuth,
      required this.firebaseStorage,
      required this.customer})
      : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  final Customermodel customer;
  @override
  State<customerschedual> createState() => _customerschedualListState();
}

class _customerschedualListState extends State<customerschedual> {
  Schedual schedual = Schedual();

  List<Schedual> customerschedualList = [];

  @override
  void initState() {
    super.initState();
    getcustomerSchadule();
  }

  Future<void> getcustomerSchadule() async {
    print(widget.customer.customerid);
    widget.firestore
        .collection('schadule')
        .doc(widget.customer.customerid)
        .collection('days')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print('1');
        setState(() {
          print(widget.customer.name);

          schedual = Schedual.fromMap(element.data());
          print(schedual.Day);
          customerschedualList.add(schedual);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Color(0xff6b88ef),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          backgroundColor: Color(0xff6b88ef),
          title: Center(
            child: Text(
              widget.customer.name!,
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
                      itemCount: customerschedualList.length,
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
                                    Text(customerschedualList[index]
                                        .Day
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
                                                Text(customerschedualList[index]
                                                    .pickupTime
                                                    .toString()), //customerList[index].pickupDriver.toString()!=null?

                                                //Text( '\n'+getpciked(customerList[index].pickupDriver.).toString())
                                                //:Text('dpname'),
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
                                                Text(customerschedualList[index]
                                                    .dropoff
                                                    .toString())
                                              ],
                                            ),
                                          ],
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

  //setState(() { driverList.add(driver);});

}
