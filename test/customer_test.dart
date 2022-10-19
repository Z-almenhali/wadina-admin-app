import 'dart:io';

import 'package:admin_app/MyDriver.dart';
import 'package:admin_app/MyStudent.dart';
import 'package:admin_app/customerList.dart';
import 'package:admin_app/customerModel.dart';
import 'package:admin_app/customerSchedual.dart';
import 'package:admin_app/driver_model.dart';
import 'package:admin_app/driverlist.dart';
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


 Customermodel mockCcustomer=Customermodel.fromMap({

    'companyID': '123456789',
    'Name': 'zehar',
    'customerid': '123456787',
    'driverDropoff': '123456788',
    'driverPickup': '123456788',
    'email': 'am@gmail.com',
    'latitude': '37.421998333333335',
    'longitude': '-122.084',
    'neighbrhoods': 'Alfihaa',
    'paymentMethod': 'creditCard',
    'phoneNumber': '0551234155',
    'schoolName': '24 primary school',


 });

  await firestore
      .collection('company')
      .doc(mockCompany.CompanyID)
      .set(mockCompany.toMap());

 

  await firestore
      .collection('company')
      .doc(mockCompany.CompanyID)
      .collection('customer')
      .doc(mockCcustomer.customerid)
      .set(
    mockCcustomer.toMap()
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
    'driverPickup': '123456777',
    'email': 'am@gmail.com',
    'latitude': '37.421998333333335',
    'longitude': '-122.084',
    'neighbrhoods': 'Alfihaa',
    'paymentMethod': 'creditCard',
    'phoneNumber': '0551234155',
    'schoolName': '24 primary school',
  });


await firestore.collection('company').doc(mockCompany.CompanyID).collection('driver').doc('123456788').set({
    'NationalidIqama': '1231231239',
    'busNumber': '12',
    'companyID': '123456789',
    'destination': '118 high school',
    'email': 'f@gmail.com',
    'id': '123456788',
    'image': 'http://example.com/driver.jpg',
    'name': 'Fahad Ali',
    'neighbrhoods': 'Alfihaa',
    'password': '123123',
    'phoneNumber': '0551234125',
    'shift': '12',
  });

 
  

await firestore
      .collection('schadule')
      .doc(mockCcustomer.customerid)
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
      .doc(mockCcustomer.customerid)
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
      .doc(mockCcustomer.customerid)
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
      .doc(mockCcustomer.customerid)
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
      .doc(mockCcustomer.customerid)
      .collection('days')
      .doc('5Thursday')
      .set({
    'Day': '5Thursday',
    'active': true,
    'dropoff': '12',
    'pickup': '8',
  });
await firestore
      .collection('schadule')
      .doc('123456766')
      .collection('days')
      .doc('1Sunday')
      .set({
    'Day': '1Sunday',
    'active': 'true',
    'dropoff': '1',
    'pickup': '9',
  });

  await firestore
      .collection('schadule')
      .doc('123456766')
      .collection('days')
      .doc('2Monday')
      .set({
    'Day': '2Monday',
    'active': 'true',
    'dropoff': '1',
    'pickup': '9',
  });

  await firestore
      .collection('schadule')
      .doc('123456766')
      .collection('days')
      .doc('3Tuesday')
      .set({
    'Day': '3Tuesday',
    'active': 'true',
    'dropoff': '1',
    'pickup': '9',
  });

  await firestore
      .collection('schadule')
      .doc('123456766')
      .collection('days')
      .doc('4Wednesday')
      .set({
    'Day': '4Wednesday',
    'active': 'true',
    'dropoff': '1',
    'pickup': '9',
  });

  await firestore
      .collection('schadule')
      .doc('123456766')
      .collection('days')
      .doc('5Thursday')
      .set({
    'Day': '5Thursday',
    'active': 'true',
    'dropoff': '1',
    'pickup': '9',
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
  testWidgets('Load customer list', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: CustomerList(
                firestore: firestore,
                firebaseAuth: firebaseAuth,
                firebaseStorage: firebaseStorage)));
    await tester.pumpWidget(testWidget);

    await tester.pump(new Duration(seconds: 1));

    expect(find.text("zehar"), findsOneWidget);
    expect(find.text("sara"), findsOneWidget);

  });

 testWidgets('Load customer schedual', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: customerschedual(
                firestore: firestore,
                firebaseAuth: firebaseAuth,
                firebaseStorage: firebaseStorage,customer: mockCcustomer,)));
    await tester.pumpWidget(testWidget);

    await tester.pump(new Duration(seconds: 1));

    expect(find.text("1Sunday"), findsOneWidget);
    expect(find.text("2Monday"), findsOneWidget);
    expect(find.text("3Tuesday"), findsOneWidget);
    expect(find.text("4Wednesday"), findsOneWidget);
    expect(find.text("5Thursday"), findsOneWidget);
    
    

  });

  testWidgets('Load customer profile', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: studentProfile(
                firestore: firestore,
                firebaseAuth: firebaseAuth,
                firebaseStorage: firebaseStorage,customer: mockCcustomer,)));
    await tester.pumpWidget(testWidget);

    await tester.pump(new Duration(seconds: 1));

    expect(find.text("zehar"),findsWidgets);
    expect(find.text("am@gmail.com"), findsOneWidget);
    expect(find.text("Alfihaa"),findsOneWidget);
    expect(find.text("creditCard"), findsOneWidget);
    expect(find.text("0551234155"),findsOneWidget);
    expect(find.text("24 primary school"), findsOneWidget);
   
    

  });
  

  
}
