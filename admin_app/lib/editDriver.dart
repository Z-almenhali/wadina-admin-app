
import 'dart:io';

import 'package:admin_app/MyDriver.dart';
import 'package:admin_app/company.dart';

import 'package:admin_app/driver_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';



class editDriver extends StatefulWidget {
   const editDriver( {Key? key,
      required this.firestore,
      required this.firebaseAuth,
      required this.firebaseStorage,required this.driver,})
      : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
 final  DriverModel driver;
    
  @override


  
  
  State<editDriver> createState() => _editDriverProfileState();
}

class _editDriverProfileState extends State<editDriver> {
   DriverModel drivermodle = DriverModel();
  User? user;
final controller = TextEditingController();


 
  final ImagePicker _picker = ImagePicker();
  final Passkey = GlobalKey<FormState>();
  final Savekey = GlobalKey<FormState>();

  final _formkey = GlobalKey<FormState>();

  
    TextEditingController _emailcontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();
    TextEditingController _idcontroller = TextEditingController();
    TextEditingController _shiftcontroller = TextEditingController();
  
  @override
  void dispose()
  {
    
    super.dispose();
   
     _emailcontroller.dispose();

    _passwordcontroller.dispose();
    _namecontroller.dispose();
    _phonecontroller.dispose();
   
   
    _idcontroller.dispose();
    _shiftcontroller.dispose();

  }
  String? selectedneighbrhood;
List<String> neighbrhoods = [
'Alnaseem', 'Aljamaa','Alfihaa'
 
];
String? selecteddestination;
List<String> destination = [
  'KAU', '118 high school','24 primary school','211 primary school'
];
String? selectedtime;
List<String> shiftTime = ['7:00 AM','8:00 AM', '9:00 AM','10:00 AM','11:00 AM','12:00 PM','13:00 PM','14:00 PM','15:00 PM','16:00 PM','17:00 PM','18:00 PM'];
void initState(){
   User? user = widget.firebaseAuth.currentUser;
 widget.firestore.collection('company').doc(user!.uid).collection('driver').doc(widget.driver.id).get().then((value) => {
    drivermodle=DriverModel.fromMap(value.data())
    
  });
}

  @override

  Widget build(BuildContext context) {

    
if(destination.contains(widget.driver.destination)){
  selecteddestination=widget.driver.destination;
}
if(neighbrhoods.contains(widget.driver.neighborhood)){
  selectedneighbrhood=widget.driver.neighborhood;
}
if(shiftTime.contains(widget.driver.shiftTime)){
  selectedtime=widget.driver.shiftTime;
}

    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
                widget.driver.Name!,
                textAlign: TextAlign.center,
              ),
            ),
           backgroundColor: Color(0xff6b88ef),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.check,
                  color: Color.fromARGB(255, 0, 255, 8),
                  size: 28,
                ),
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (Savekey.currentState!.validate()) {
                    Savekey.currentState!.save();
                    // use the information provided
                   updateDriverProfile();
                   setState(() {
                     drivermodle;
                   });
                   Navigator.push( context,  MaterialPageRoute(builder: (context) =>   myDriver( firestore: widget.firestore,
                        firebaseAuth: widget.firebaseAuth,
                        firebaseStorage: widget.firebaseStorage,driver: drivermodle,)),);
                  }
                }),
          ],
            
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(7.0),
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
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child:   Image.asset(
                                        "assets/CameraSVg.jpg")
                            ),
                          
                        ],
                      ),)
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
            //  al hala the
            const SizedBox(height: 24.0),
            SizedBox(
              height: 500,
              width: 500,
              child: Form(
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                key: Savekey,
                child: ListView(children: <Widget>[
                  TextFormField(
                   key: const ValueKey('NameKey'),
                    initialValue: widget.driver.Name.toString(),
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.person),
                      labelText: 'Name *',
                    ),
                    //----------validation---------
                    validator: (value) {
                      if (value != null && value.length < 3) {
                        return 'Enter at least 3 characters';
                      } else {
                        return null; // form is valid
                      }
                    },
                    onSaved: (String? value) {
                   // widget.driver.Name = value;
                      _namecontroller.text=value.toString();
                    },
                  ),
                  TextFormField(
                     key: const ValueKey('emailKey'),
                    initialValue: widget.driver.email.toString(),
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.email_outlined),
                      labelText: 'Email *',
                    ),
                    //----------validation---------
                    validator: (value) {
                      if (value != null && value.length < 3) {
                        return 'Enter at least 3 characters';
                      } else {
                        return null; // form is valid
                      }
                    },
                    onSaved: (String? value) {
                    widget.driver.email = value;
                      _emailcontroller.text=value.toString();
                    },
                  ),
                   TextFormField(
                      key: const ValueKey('PhoneKey'),
                    initialValue: widget.driver.phoneNumber.toString(),
                    maxLength: 10,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.phone),
                      labelText: 'Phone Number *',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value != null && !isNumeric(value)) {
                        return 'Only digit allowed';
                      } else if (value != null && value.length < 10) {
                        return 'Phone number must be 10 numbers';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (String? value) {
                      widget.driver.phoneNumber = value;
                      _phonecontroller.text=value.toString();
                    },
                  ),
                  const SizedBox(height: 24.0),
                 

                  //
               

                
                  const SizedBox(height: 15.0),
                  TextFormField(
                     key: const ValueKey('NationalorIqamaKey'),
                    initialValue: '${widget.driver.driverid}',
                      //controller: _idcontroller,
                   maxLength: 10,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.person_pin_sharp),
                      labelText: 'National ID/Iqama *',
                    ),
                    keyboardType: TextInputType.phone,
                validator: (value) {
                      if (value != null && !isNumeric(value)) {
                        return 'Only digit allowed';
                      } else if (value != null && value.length < 10) {
                        return 'Id/Iqama number must be 10 numbers';
                      } else {
                        return null; // form is valid
                      }
                    },
                   onSaved: (String? value) {
                      widget.driver.driverid = value;
                      _idcontroller.text=value.toString();
                    },
                  ),
              
                  InputDecorator(
                    key: const ValueKey('DestinationKey'),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.location_city),
                     
                      
                    ),child: DropdownButtonHideUnderline(child: DropdownButton2(
                     hint: Text(
                    '${widget.driver.neighborhood}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme
                                  .of(context)
                                  .hintColor,
                        ),),items: neighbrhoods
                              .map((item) =>
                              DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                              .toList(),
                      value: selectedneighbrhood,
                      onChanged: (value) {
                        setState(() {
                          selectedneighbrhood = value as String;
                          widget.driver.neighborhood=selectedneighbrhood;
                        });
                      },
                      buttonHeight: 40,
                      buttonWidth: 140,
                      itemHeight: 40,
                    ),

                    )
                    
                   
                    ,
                   
                    // ],
                  ), InputDecorator(
                   key: const ValueKey('DestinationKey'),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.school_outlined)
                     
                      
                    ),child: DropdownButtonHideUnderline(child: DropdownButton2(
                     hint: Text(
                    '${widget.driver.destination}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme
                                  .of(context)
                                  .hintColor,
                        ),),items: destination
                              .map((items2) =>
                              DropdownMenuItem<String>(
                                value: items2,
                                child: Text(
                                  items2,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                              .toList(),
                      value: selecteddestination,
                      onChanged: (value) {
                        setState(() {
                          selecteddestination = value as String;
                          widget.driver.destination=selecteddestination;
                        });
                      },
                      buttonHeight: 40,
                      buttonWidth: 140,
                      itemHeight: 40,
                    ),

                    )
                    
                   
                    ,
                   
                    // ],
                  ),InputDecorator(
                   key: const ValueKey('shiftKey'),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.schedule)
                     
                      
                    ),child: DropdownButtonHideUnderline(child: DropdownButton2(
                     hint: Text(
                    '${widget.driver.shiftTime}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme
                                  .of(context)
                                  .hintColor,
                        ),),items: shiftTime
                              .map((items3) =>
                              DropdownMenuItem<String>(
                                value: items3,
                                child: Text(
                                  items3,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                              .toList(),
                      value: selectedtime,
                      onChanged: (value) {
                        setState(() {
                          selectedtime = value as String;
                          widget.driver.shiftTime=selectedtime;
                        });
                      },
                      buttonHeight: 40,
                      buttonWidth: 140,
                      itemHeight: 40,
                    ),

                    )
                    
                   
                    ,
                   
                    // ],
                  ),
                    
                    // ],
                  SizedBox(height: 10,),
                
                  const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
             
              
                ]),
              ),
            ),
          ]),
        ));
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }



  Padding _buildBottomSheet(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Padding(
      padding: mediaQueryData.viewInsets,
      child: Container(
        padding: const EdgeInsets.all(18.0),
        height: 350,
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: Passkey,
          child: SizedBox(
            height: 100,
            width: 100,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                const ListTile(title: Text('Edit password')),
                // "Password" form.

                PasswordField(
                  labelText: 'Curent Password *',
                  onFieldSubmitted: (String value) {
                    // setState(() {
                    //   this._password = value;
                    // });
                  },
                  //----------validation---------
                  validator: (value) {
                    if (value != null && value.length < 8) {
                      return 'Password must have at least 8 characters';
                    } else {
                      return null; // form is valid
                    }
                  },
                ),

                const SizedBox(height: 24.0),
                PasswordField(
                  labelText: 'New password *',
                  onFieldSubmitted: (String value) {
                    // setState(() {
                    //   this._password = value;
                    // });
                  },
                  validator: (value) {
                    if (value != null && value.length < 8) {
                      return 'Password must have at least 8 characters';
                    } else {
                      return null; // form is valid
                    }
                  },
                ),

                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        // side: BorderSide(width: 2, color: Colors.grey),
                      ),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (Passkey.currentState!.validate()) {
                          
                              
                             FirebaseFirestore.instance.collection('driver').doc(user!.uid).collection("driverF").doc().set({
                                 'email':_emailcontroller.text,
                            'name':_namecontroller.text,
                            'phone':_phonecontroller.text,
                           'password':_passwordcontroller.text,
                            'Nationalid/iqama':_idcontroller.text,
                              }).then((value){
                                print('record updated successflly');
                              });
                            }
  
                          // use the information provided
                        },
                      
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Save",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  

  void updateDriverProfile() async {
    User? user = widget.firebaseAuth.currentUser;
   
    if (_emailcontroller.text.isEmpty && drivermodle.email == _emailcontroller.text) {
      
        drivermodle.email = _emailcontroller.text;
      

       widget.firestore
          .collection("company")
          .doc(user!.uid).collection('driver').doc(widget.driver.id)
          .update({'email': drivermodle.email});
          widget.firestore.collection('driver').doc(widget.driver.id).update({
            'email':drivermodle.email
          });
    }

    if (!_namecontroller.text.isEmpty &&
        drivermodle.Name != _namecontroller.text) {
      
        drivermodle.Name = _namecontroller.text;
      

      widget.firestore
          .collection("company")
          .doc(user!.uid).collection('driver').doc(widget.driver.id)
          .update({'name': drivermodle.Name});
          widget.firestore
        .collection('driver').doc(widget.driver.id)
          .update({'name': drivermodle.Name});
    }
    if (!_phonecontroller.text.isEmpty &&
        drivermodle.phoneNumber != _phonecontroller.text) {
     
        drivermodle.phoneNumber = _phonecontroller.text;
    

    widget.firestore
          .collection("company")
          .doc(user!.uid).collection('driver').doc(widget.driver.id)
          .update({'phoneNumber': drivermodle.phoneNumber});
          widget.firestore
          .collection("driver")
          .doc(widget.driver.id)
          .update({'phoneNumber': drivermodle.phoneNumber});
    }
    if (!_idcontroller.text.isEmpty &&
        drivermodle.driverid != _idcontroller.text) {
     
        drivermodle.driverid = _idcontroller.text;
      

      widget.firestore
          .collection("company")
          .doc(user!.uid).collection('driver').doc(widget.driver.id)
          .update({'NationalidIqama': drivermodle.driverid});
         widget.firestore
         .collection('driver').doc(widget.driver.id)
          .update({'NationalidIiqama': drivermodle.driverid});
    } 
    if ( drivermodle.destination != selecteddestination.toString()) {
      
        drivermodle.destination = selecteddestination;
      

      widget.firestore
          .collection("company")
          .doc(user!.uid).collection('driver').doc(widget.driver.id)
          .update({'destination': drivermodle.destination});
          widget.firestore
          .collection('driver').doc(widget.driver.id)
          .update({'destination': drivermodle.destination});
    }
    if (
        drivermodle.neighborhood != selectedneighbrhood) {
      
        drivermodle.neighborhood = selectedneighbrhood;
      

       widget.firestore
          .collection("company")
          .doc(user!.uid).collection('driver').doc(widget.driver.id)
          .update({'neighbrhoods': drivermodle.neighborhood});
           widget.firestore
          .collection('driver').doc(widget.driver.id)
          .update({'neighbrhoods': drivermodle.neighborhood});
    }
    if (
        drivermodle.shiftTime != selectedtime) {
      
        drivermodle.shiftTime = selectedtime;
      

       widget.firestore
          .collection("company")
          .doc(user!.uid).collection('driver').doc(widget.driver.id)
          .update({'shift': drivermodle.shiftTime});
           widget.firestore
          .collection('driver').doc(widget.driver.id)
          .update({'shift': drivermodle.shiftTime});
    }
  }
  
 
}


class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      // maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
