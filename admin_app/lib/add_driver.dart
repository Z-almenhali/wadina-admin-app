



import 'package:admin_app/company.dart';
import 'package:admin_app/driverlist.dart';
import 'package:admin_app/driver_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login.dart';


class AddDriver extends StatefulWidget{
  
     AddDriver(
      {Key? key,
      required this.firestore,
      required this.firebaseAuth,
      required this.firebaseStorage})
      : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  @override
  _AddDriverState createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
 
final ImagePicker _picker = ImagePicker();
 FirebaseStorage storage = FirebaseStorage.instance;
  


  List<String> neighborhood = ['Alnaseem', 'Aljamaa','Alfihaa'];
  String neighborhooddropdownvalue = 'Alnaseem';
  List<String> destination = ['KAU', '118 high school','24 primary school','211 primary school'];
  String destinationdropdownvalue = 'KAU';
  List<String> shifttime = ['7:00 AM','8:00 AM', '9:00 AM','10:00 AM','11:00 AM','12:00 PM','13:00 PM','14:00 PM','15:00 PM','16:00 PM','17:00 PM','18:00 PM'];
  String shiftdropdownvalue = '7:00 AM';
  
   List<String>buslist=[];
 User? user=FirebaseAuth.instance.currentUser;
  void initState()
  {
    super.initState();
   
       

    

  }

  final _formkey = GlobalKey<FormState>();


    TextEditingController _emailcontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();
    TextEditingController _idcontroller = TextEditingController();
   TextEditingController _shiftcontroller=TextEditingController();
   
  @override
  void dispose()
  {
    

   
     _emailcontroller.dispose();
    
    _passwordcontroller.dispose();
    _namecontroller.dispose();
    _phonecontroller.dispose();
   
   
    _idcontroller.dispose();

    super.dispose();
  }

 Company company=Company();
 
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
     
       
         backgroundColor: Color(0xff6b88ef),
            title: Center(
              child: Text(
                "New Driver",
                textAlign: TextAlign.center,
              ),
            ),
      ),
      body:SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
             SizedBox(
                      height: 140,
                      width: 140,
                      child: Stack(
                        fit: StackFit.expand,
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child:   Image.asset(
                                        "assets/CameraSVg.jpg")
                            ),
                          
                        ],
                      ),
                    ),   const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),

              TextFormField(
                controller: _namecontroller,
             style: TextStyle(color: Colors.black,fontSize:18),
             decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.person),
                      labelText: 'Name *',
                    ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please Fill Driver name';
                  }
                  // return 'Valid Name';
                },
              ), 
              TextFormField( style: TextStyle(fontSize:18),
            controller: _phonecontroller,
           
           decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.phone),
                      labelText: 'Phone Number *',
                    ),
            
            validator: (value) {
               if (value!.isEmpty) {
                return 'Please enter Phone Number';
              }
              if(value.length<10){
                return 'Phone Number must be 10 digits ';
              }
              
              return null;
            }
          ),
          SizedBox(width: 20), TextFormField(
            controller: _idcontroller,
             style: TextStyle(fontSize:18),
           
           decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.person_pin_sharp),
                      labelText: 'National ID/Iqama *',
                    ),
          
            validator: (value) {
               if (value!.isEmpty) {
                return 'Please enter Driver Iqama or National ID';
              }
              if(value.length<10){
                return 'id must be 10 digits';
              }
              return null;
            }
          ),
          SizedBox(width: 20),
          TextFormField(
            controller: _emailcontroller,
             style: TextStyle(fontSize:18),
             decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.email_outlined),
                      labelText: 'Email *',
                    ),
           
           
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Driver Email';
              }
              if(value.contains('@')==false){
                return ' Email format email@email.com';
              }
              return null;
            }
          ),
          SizedBox(width: 20),
          TextFormField(
            controller: _passwordcontroller,
             style: TextStyle(fontSize:18),
            obscureText: true,
            decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.password),
                      labelText: 'Password *',
                    ),
          
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            }
          ),ButtonTheme(
  alignedDropdown: true,
  
  child:   DropdownButtonFormField<String>(
            
         
            decoration: InputDecoration(icon: Icon(Icons.location_city),labelText: 'Select Destination',labelStyle: TextStyle(fontSize: 18),border:UnderlineInputBorder(),filled: true),
            items: destination.map((value) {
              return DropdownMenuItem<String>(
                  child: Text(value), value: value);
            }).toList(),
            value: destinationdropdownvalue,
            onChanged: (destinationnewValue) {
              setState(() {
                destinationdropdownvalue = destinationnewValue!;
              });
            },
          ),),         SizedBox(width: 20),  SizedBox(width: 20,) ,ButtonTheme(
  alignedDropdown: true,
  
  child:   DropdownButtonFormField<String>(
            
          
            decoration: InputDecoration(icon:Icon(Icons.house),labelText: 'Select Nighbrhood',labelStyle: TextStyle(fontSize: 18),border:UnderlineInputBorder(),filled: true),
            items: neighborhood.map((value) {
              return DropdownMenuItem<String>(
                  child: Text(value), value: value);
            }).toList(),
            value: neighborhooddropdownvalue,
            onChanged: (neighborhoodnewValue) {
              setState(() {
                neighborhooddropdownvalue = neighborhoodnewValue!;
              });
            },
          ),),
             SizedBox(width: 20),  SizedBox(width: 20,) ,ButtonTheme(
  alignedDropdown: true,
  
  child:   DropdownButtonFormField<String>(
            
          
            decoration: InputDecoration(icon:Icon(Icons.schedule),labelText: 'Shift time',labelStyle: TextStyle(fontSize: 18),border:UnderlineInputBorder(),filled: true),
            items: shifttime.map((value) {
              return DropdownMenuItem<String>(
                  child: Text(value), value: value);
            }).toList(),
            value: shiftdropdownvalue,
            onChanged: (shiftnewValue) {
              setState(() {
                shiftdropdownvalue = shiftnewValue!;
              });
            },
          ),),
              SizedBox(
                height: 20,
              ),
              OutlinedButton(
                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  color: Colors.blue,
                                                  size: 20.0,
                                                ),
                                                Text("ADD Driver",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                             FontWeight.bold,fontFamily:'Microsoft_Phagspa',fontSize:18 ,
                                                           
                                                        color:
                                                            Colors.blue ,
                                                            )),
                                              ],
                                            ),
               style: OutlinedButton.styleFrom(
    side: BorderSide(width: 5.0, color: Colors.blue)),
                onPressed: () async{
                  if(_formkey.currentState!.validate()){

                                         
                    
                       addNewDriver(_emailcontroller.text,_passwordcontroller.text);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => driverlist( firestore: widget.firestore,
                        firebaseAuth: widget.firebaseAuth,
                        firebaseStorage: widget.firebaseStorage) ) );
                     
                  
                 
                   
                  }
                },
              ),
             
              
            ],
          ),
        ),
      ),
    );
    
    
  }

  
   void addNewDriver(String email,String pass) async {
     

    FirebaseApp secondaryApp = await Firebase.initializeApp(
  name: 'SecondaryApp',
  options: Firebase.app().options,
);

try {
    final User? user1 = ( await FirebaseAuth.instanceFor(app: secondaryApp).createUserWithEmailAndPassword(email: email, password: pass,
                     )).user;
 

    DriverModel drivermodel = DriverModel();
    drivermodel.email = email;
    drivermodel.Name = _namecontroller.text;
    drivermodel.id = user1!.uid;
    drivermodel.phoneNumber = _phonecontroller.text;
    drivermodel.driverid = _idcontroller.text;
    drivermodel.password=_passwordcontroller.text;
    drivermodel.companyid=user!.uid;
    drivermodel.destination=destinationdropdownvalue;
    drivermodel.shiftTime=shiftdropdownvalue;
    drivermodel.neighborhood= neighborhooddropdownvalue;

     FirebaseFirestore.instance
        .collection("driver")
        .doc(user1.uid)
        .set(drivermodel.toMap());
     FirebaseFirestore.instance.collection('company').where('CompanyID',isEqualTo: user!.uid).get().then((value) 
       {value.docs.forEach((element){
         FirebaseFirestore.instance.collection('company').doc(element.id).collection('driver').doc(user1.uid).set(
           drivermodel.toMap()
                          );
                        });});
           
  if (user1.uid == null) throw 'An error occured. Please try again.';

} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    print('An account already exists for this email.');
  }
} catch (e) {
   print('An error occured. Please try again.');
}

// after creating the account, delete the secondary app as below:
await secondaryApp.delete();
       

    
    
  }

  
  
  

 
 }