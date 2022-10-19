import 'dart:io';

import 'package:admin_app/company.dart';
import 'package:admin_app/customerList.dart';
import 'package:admin_app/customerModel.dart';
import 'package:admin_app/driver_model.dart';
import 'package:admin_app/drivercustomerlist.dart';
import 'package:admin_app/schedual.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'customerSchedual.dart';





class studentProfile extends StatefulWidget {
 

  const studentProfile(
     
      {Key? key,
      required this.firestore,
      required this.firebaseAuth,
      required this.firebaseStorage,required this.customer,})
      : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
 final  Customermodel customer;

  @override
  State<studentProfile> createState() => _studentProfileState();
}

class _studentProfileState extends State<studentProfile> {
  Customermodel customermodel=Customermodel();
 
  

  void initState (){
    setState(() {
      widget.customer.customerid;
    });
    User? user=widget.firebaseAuth.currentUser;
    widget.firestore.collection('company').doc(user!.uid).collection('customer').doc(widget.customer.customerid).get().then((value){
   
      setState(() {
     customermodel=Customermodel.fromMap(value.data());
   
   
            
            
       
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
      backgroundColor: Color.fromARGB(255, 243, 244, 246),
        appBar: AppBar(
         
         backgroundColor: Color(0xff6b88ef),
         title: Center(
              child: Text(
                widget.customer.name!,
                textAlign: TextAlign.center,
              ),
            ),
        ),
        body:SingleChildScrollView(child: Container(
          
         

         padding:  const EdgeInsets.fromLTRB(30, 10, 30, 10),
          
          child: Column(children: [
          SizedBox(height: 70,),
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
                                              Icons.person,
                                              color: Color(0xff6b88ef),
                                              size: 20.0,
                                            ),
                                          ),
                                          Text("Name: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'Microsoft_Phagspa')),
                                          Text(customermodel.name.toString(),style: const TextStyle(
                                                  fontSize: 18,fontFamily: 'Microsoft_Phagspa')),
                                        ],
                                      ),SizedBox(height: 20,), Row(
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
                                              size: 20.0,
                                            ),
                                          ),
                                          Text("Email: ",
                                              style: const TextStyle(
                                                 fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'Microsoft_Phagspa')),
                                          Text(customermodel.email
                                      .toString(),style: const TextStyle(
                                              fontSize: 18,fontFamily: 'Microsoft_Phagspa'))
                                        ],
                                      ),SizedBox(height: 20,),  Row(
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
                                              size: 20.0,
                                            ),
                                          ),
                                          Text("Phone Number: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'Microsoft_Phagspa')),
                                          Text(customermodel.phoneNumber.toString(), style: const TextStyle(
                                                  fontSize: 18,fontFamily: 'Microsoft_Phagspa')),
                                        ],
                                      ), SizedBox(height: 20,),Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                26, 5, 10, 5),
                                            child: Icon(
                                              Icons.payment,
                                              color: Color(0xff6b88ef),
                                              size: 20.0,
                                            ),
                                          ),
                                          Text("Payment method: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'Microsoft_Phagspa')),
                                          Text(customermodel.paymentMethod
                                      .toString(), style: const TextStyle(
                                                 fontSize: 18,fontFamily: 'Microsoft_Phagspa')),
                                        ],
                                      ), SizedBox(height: 20,),Row(
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
                                              size: 20.0,
                                            ),
                                          ),
                                          Text("Neighborhood: ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,fontSize: 18,fontFamily: 'Microsoft_Phagspa')),
                                          Text(customermodel.neighbrhoods
                                    
                                      .toString(), style: const TextStyle(
                                                  fontSize: 18,fontFamily: 'Microsoft_Phagspa')),
                                        ],
                                      ),SizedBox(height: 20,),
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
                                              size: 20.0,
                                            ),
                                          ),
                                          Text("Destination: ",
                                               style: const TextStyle(
                                                 fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Microsoft_Phagspa')),
                                          Text(customermodel.schoolName
                                      .toString(), style: const TextStyle(
                                                 fontSize: 18,fontFamily: 'Microsoft_Phagspa')),
                                        ],
                                      ),SizedBox(height: 20,),Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          OutlinedButton(
                                            onPressed: () {  Navigator.push( context,  MaterialPageRoute(builder: (context) =>   customerschedual( firestore: widget.firestore,
                        firebaseAuth: widget.firebaseAuth,
                        firebaseStorage: widget.firebaseStorage,customer:customermodel)),);},
                                          
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.schedule,
                                                  color: Color(0xff6b88ef),
                                                  size: 20.0,
                                                ),
                                                Text('Schedual',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,fontFamily:'Microsoft_Phagspa',fontSize:18 ,
                                                        color:
                                                            Color(0xff6b88ef))),
                                              ],
                                            ), style: OutlinedButton.styleFrom(
    side: BorderSide(width: 5.0, color: Colors.blue)),
                                          ),
                                          OutlinedButton(
                                            onPressed: () {  launchMap(customermodel.latitude.toString(), widget.customer.longitude.toString());},
                                           
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                            FontWeight.bold,fontFamily:'Microsoft_Phagspa',fontSize:18 ,
                                                        color:
                                                            Color(0xff6b88ef)))
                                              ],
                                            ), style: OutlinedButton.styleFrom(
    side: BorderSide(width: 5.0, color: Colors.blue)),
                                          ), 
                                          OutlinedButton(
                                            onPressed: () { 
                                              FirebaseFirestore.instance.collection('company').doc(widget.firebaseAuth.currentUser!.uid).collection('customer').doc(widget.customer.customerid).delete();
                                              
                                               Navigator.push( context,  MaterialPageRoute(builder: (context) =>   CustomerList( firestore: widget.firestore,
                        firebaseAuth: widget.firebaseAuth,
                        firebaseStorage: widget.firebaseStorage)),);},
                                             
                                            
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Color(0xff6b88ef),
                                                  size: 20.0,
                                                ),
                                                Text("Delete Customer",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,fontFamily:'Microsoft_Phagspa',fontSize:18 ,
                                                        color:
                                                            Color(0xff6b88ef)))
                                              ],
                                            ), style: OutlinedButton.styleFrom(
    side: BorderSide(width: 5.0, color: Colors.blue)),
                                          ),
                                        ],
                                      ),
                                     
                  
                                     
                                      
            
   
          ]),
        ),));
  }
  }