import 'dart:io';

import 'package:admin_app/MyDriver.dart';
import 'package:admin_app/MyStudent.dart';
import 'package:admin_app/add_driver.dart';
import 'package:admin_app/customerList.dart';
import 'package:admin_app/customerModel.dart';
import 'package:admin_app/customerSchedual.dart';
import 'package:admin_app/driver_model.dart';
import 'package:admin_app/drivercustomerlist.dart';
import 'package:admin_app/driverlist.dart';
import 'package:admin_app/editDriver.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:admin_app/editProfile.dart';
import 'package:admin_app/company.dart';
import 'package:admin_app/profileScreen.dart';

void main() async {
  // Used to get rid of the 400 error (because of NetworkImage)
  setUpAll(() => HttpOverrides.global = null);

  final firestore = FakeFirebaseFirestore();

  Company mockCompany = Company.fromMap({
    'CompanyID': '123456789',
    'address': 'Alnassem',
    'contract': 'contract',
    'description': 'description',
    'email': 'wosol@gmail.com',
    'imageURL': 'http://example.com/bus.jpg',
    'name': 'wosol',
    'phoneNumber': '0555555555',
    'price': '123.4',
    'rate': '5',
    'registerStatus': false,
  });

DriverModel mockCDriver=DriverModel.fromMap({

    'NationalidIqama': '1231231239',
    'busNumber': '19',
    'companyID': '123456789',
    'destination': '118 high school',
    'email': 'f@gmail.com',
    'id': '123456788',
    'name': 'Fahad Ali',
    'neighbrhoods': 'Alfihaa',
    'password': '123123',
    'phoneNumber': '0551234125',
    'shift': '8',


 });


  await firestore
      .collection('company')
      .doc(mockCompany.CompanyID)
      .set(mockCompany.toMap());

 

  
  
  await firestore
      .collection('company')
      .doc(mockCompany.CompanyID)
      .collection('driver')
      .doc(mockCDriver.id)
      .set(
    mockCDriver.toMap()
  );
   await firestore
      .collection('company')
      .doc(mockCompany.CompanyID)
      .collection('customer')
      .doc('123456687')
      .set({
    'companyID': '123456789',
    'Name': 'sara',
    'customerid': '123456687',
    'driverDropoff': '123456777',
    'driverPickup': mockCDriver.id,
    'email': 'am@gmail.com',
    'latitude': '37.421998333333335',
    'longitude': '-122.084',
    'neighbrhoods': 'Alfihaa',
    'paymentMethod': 'creditCard',
    'phoneNumber': '0551234155',
    'schoolName': '24 primary school',
  });




 
  

await firestore
      .collection('schadule')
      .doc('123456687')
      .collection('days')
      .doc('1Sunday')
      .set({
    'Day': '1Sunday',
    'active': true,
    'dropoff': '12',
    'pickup': '8',
  });

  await firestore
      .collection('schadule')
      .doc('123456687')
      .collection('days')
      .doc('2Monday')
      .set({
    'Day': '2Monday',
    'active': true,
    'dropoff': '12',
    'pickup': '8',
  });

  await firestore
      .collection('schadule')
      .doc('123456687')
      .collection('days')
      .doc('3Tuesday')
      .set({
    'Day': '3Tuesday',
    'active': true,
    'dropoff': '12',
    'pickup': '8',
  });

  await firestore
      .collection('schadule')
      .doc('123456687')
      .collection('days')
      .doc('4Wednesday')
      .set({
    'Day': '4Wednesday',
    'active': true,
    'dropoff': '12',
    'pickup': '8',
  });

  await firestore
      .collection('schadule')
      .doc('123456687')
      .collection('days')
      .doc('5Thursday')
      .set({
    'Day': '5Thursday',
    'active': true,
    'dropoff': '12',
    'pickup': '8',
  });

 

  // Creating a mock user
  final user = MockUser(
    isAnonymous: false,
    uid: '123456789',
    email: 'wosol@gmail.com',
    displayName: 'wosol',
  );
  // making the firebase auth with the mock user signed in
  final firebaseAuth = MockFirebaseAuth(signedIn: true, mockUser: user);

  final firebaseStorage = MockFirebaseStorage();

  // Load profile screen
 testWidgets('Load driver list', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: driverlist(
                firestore: firestore,
                firebaseAuth: firebaseAuth,
                firebaseStorage: firebaseStorage)));
    await tester.pumpWidget(testWidget);

    await tester.pump(new Duration(seconds: 1));

    expect(find.text("Fahad Ali"), findsOneWidget);
    expect(find.text("Saad Mohammed"), findsNothing);

  });
 

  testWidgets('Load driver profile', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: myDriver(
                firestore: firestore,
                firebaseAuth: firebaseAuth,
                firebaseStorage: firebaseStorage,driver:mockCDriver,)));
    await tester.pumpWidget(testWidget);

    await tester.pump(new Duration(seconds: 1));

    expect(find.text("Fahad Ali"),findsWidgets);
    expect(find.text("f@gmail.com"), findsOneWidget);
    expect(find.text("Alfihaa"),findsOneWidget);
    expect(find.text("1231231239"), findsOneWidget);
    expect(find.text("0551234125"),findsOneWidget);
    expect(find.text("118 high school"), findsOneWidget);

  });

    testWidgets('Load driver customerlist', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: driverCustomer(
                firestore: firestore,
                firebaseAuth: firebaseAuth,
                firebaseStorage: firebaseStorage,driver:mockCDriver,)));
    await tester.pumpWidget(testWidget);

    await tester.pump(new Duration(seconds: 1));

    expect(find.text("sara"),findsOneWidget);
     expect(find.text("nouf"),findsNothing);


  });

 
  
 testWidgets('edit driver', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: editDriver(
                firestore: firestore,
                firebaseAuth: firebaseAuth,
                firebaseStorage: firebaseStorage,driver: mockCDriver,)));
    await tester.pumpWidget(testWidget);
    await tester.pump(new Duration(seconds: 1));
    await tester.enterText(find.byKey(const ValueKey('NameKey')), 'Ahmad Ali');
    await tester.pump(new Duration(microseconds: 500));
    await tester.enterText(find.byKey(const ValueKey('PhoneKey')), '0586543276');
    await tester.pump(new Duration(microseconds: 500));
     await tester.tap(find.byType(IconButton));
    await tester.pump(new Duration(microseconds: 500));
    firestore
        .collection("company")
        .doc(mockCompany.CompanyID).collection('driver').doc(mockCDriver.id)
        .get()
        .then((value) {
      expect(value.data()!['phoneNumber'], "0586543276");
      expect(value.data()!['name'], "Ahmad Ali");
    });
  });
  
}
