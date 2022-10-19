import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';

class DriverModel {
 
  String? Name;
  String? driverid;
  String? email;

  String? phoneNumber;
  String? destination;
  String? shiftTime;
  String? password;
  String? neighborhood;
   String? id;
   String?bus;
   String?companyid;


  DriverModel(
      {this.Name,
      
      this.email,
      this.password,
      this.driverid,
      this.phoneNumber,
      this.destination,
      this.shiftTime,
      this.neighborhood,
      this.id,
      this.bus,
      this.companyid,
 

  
      });
  //receiving data from server
  factory DriverModel.fromMap(map) {
    return DriverModel(
      Name: map['name'],
     driverid: map['NationalidIqama'],
      email: map['email'],
     password: map['password'],
      phoneNumber: map['phoneNumber'],
      destination: map['destination'],
      shiftTime: map['shift'],
     neighborhood: map ['neighbrhoods'],
     id:map['id'],
  bus: map['busNumber'],
  companyid:map['CompanyID'],

    
    );
  }
 

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'name': Name,
      'NationalidIqama': driverid,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'destination':destination,
      'shift':shiftTime,
       'neighbrhoods':neighborhood,
       'id':id,
       'busNumber':bus
       ,
       'companyID':companyid,
   
  
  
    };
    
  }
 
}
