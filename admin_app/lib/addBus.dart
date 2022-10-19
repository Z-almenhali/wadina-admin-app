import 'package:admin_app/profileScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'busPage.dart';

class addBusForm extends StatefulWidget {
  const addBusForm(
      {Key? key,
      required this.firestore,
      required this.firebaseAuth,
      required this.firebaseStorage})
      : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  @override
  State<addBusForm> createState() => _addBusState();
}

class _addBusState extends State<addBusForm> {
  @override
  User? user = FirebaseAuth.instance.currentUser;

  void initState() {
    super.initState();
  }

  final _formkey = GlobalKey<FormState>();

  TextEditingController _platenumbercontroller = TextEditingController();
  TextEditingController _busnumbercontroller = TextEditingController();

  @override
  void dispose() {
    _platenumbercontroller.dispose();
    _busnumbercontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => busListWidget(
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
              "New Bus",
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
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
                child: Column(
              children: <Widget>[
                SizedBox(width: 20),
                //لمن تضيفي باص احرصي انو رقم اللوحة اربعة ارقام اول شي بعدين اربعة حروف
                TextFormField(
                    style: TextStyle(fontSize: 18),
                    controller: _platenumbercontroller,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Bus Plate Number '),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Bus Plate Number Number';
                      }
                      return null;
                    }),
                SizedBox(width: 20),
                //اتأكدي انو رقم الباص مو موجود من قبل
                TextFormField(
                    controller: _busnumbercontroller,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Bus Number'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Bus Number';
                      }
                      return null;
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                primary: Colors.yellow,
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            child: const Text('CANCEL',
                                style: TextStyle(fontSize: 18)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => busListWidget(
                                        firestore: widget.firestore,
                                        firebaseAuth: widget.firebaseAuth,
                                        firebaseStorage:
                                            widget.firebaseStorage)),
                              );
                            })),
                    SizedBox(height: 20),
                    SizedBox(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                primary: Colors.yellow,
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            child: const Text('ADD',
                                style: TextStyle(fontSize: 18)),
                            onPressed: () {
                              addBusFB();
                            }))
                  ],
                )
              ],
            ))));
  }

  void addBusFB() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final uid = user?.uid;
    final newBusRef = firebaseFirestore
        .collection('company')
        .doc(uid)
        .collection('bus')
        .doc();
    final busData = <String, dynamic>{
      'busNumber': _busnumbercontroller.text,
      'busPlate': _platenumbercontroller.text
    };

    print(uid.toString());
    print(_busnumbercontroller.text);
    newBusRef
        .set(busData)
        .then((value) => debugPrint("Bus Added"))
        .catchError((onError) => debugPrint("Failed to add user: $onError "));
    print('done');
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => busListWidget(
                firestore: widget.firestore,
                firebaseAuth: widget.firebaseAuth,
                firebaseStorage: widget.firebaseStorage)));
  }
}
