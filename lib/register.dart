import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:admin_app/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget{
const RegisterScreen (
      {Key? key,
      required this.firestore,
      required this.firebaseAuth,
      required this.firebaseStorage})
      : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
    void initState()
  {
    super.initState();
  }


  final _formkey = GlobalKey<FormState>();

  TextEditingController _emailcontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();
   TextEditingController _descriptioncontroller = TextEditingController();
    TextEditingController _pricecontroller = TextEditingController();
    TextEditingController _addressontroller = TextEditingController();
 TextEditingController _contractontroller = TextEditingController();


  @override
  void dispose()
  {
    _emailcontroller.dispose();

    _passwordcontroller.dispose();
    _namecontroller.dispose();
    _phonecontroller.dispose();
    _descriptioncontroller.dispose();
    _pricecontroller.dispose();
    _addressontroller.dispose();
    _contractontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    FirebaseAuth auth=FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6b88ef),
        title: Text('Register New Company'),
      ),
      body:SingleChildScrollView(child: Container(
        padding: EdgeInsets.all(16),
        child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                
                  
                TextFormField(
                  controller: _emailcontroller,
                  decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.email),
                        labelText: 'Email *',
                      ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please Fill Email Input';
                    }
                    if(value.contains('@')==false){
                       return 'Please write correct Email format email@email.com';
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passwordcontroller,
                  obscureText: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.password),
                        labelText: 'Password *',
                      ),
                   
                  
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please Fill Password Input';
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _namecontroller,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.person),
                        labelText: 'Company Name *',
                      ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please Fill Name Input';
                    }
                  },
                ),SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _phonecontroller,
                   decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.phone),
                        labelText: 'phone Number *',
                      ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please Fill Phone Number';
                    }
                    if(value.length<10){
                        return 'Phone Number must be 10 digits';
                    }
                  },
                ),SizedBox(
                  height: 20,
                ),
                TextFormField(
                 maxLines: 6,
                  controller: _descriptioncontroller,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.description),
                        labelText: 'Description *',
                      ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please Fill description Input';
                    }
                  },
                ),SizedBox(
                  height: 20,
                ),
                 TextFormField(
                 maxLines: 6,
                  controller: _contractontroller,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.description),
                        labelText: 'Contract *',
                      ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please Fill contract Input';
                    }
                  },
                ),SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _pricecontroller,
                  decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.price_change_outlined),
                        labelText: 'Price *',
                      ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please Fill price Input';
                    }
                  },
                ),SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _addressontroller,
                  decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.pin_drop),
                        labelText: 'Address *',
                      ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please Fill Address Input';
                    }
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                RaisedButton(
                  
                  color: Color(0xff6b88ef),
                  child: Text('Sign Up',style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Microsoft_Phagspa'),),
                  onPressed: () async{
                    if(_formkey.currentState!.validate()){
                      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailcontroller.text, password: _passwordcontroller.text);

                      var user=auth.currentUser;
                      final uid= user?.uid;

                     
                      if(result != null)
                      {
                        

                   FirebaseFirestore.instance.collection('company').doc(uid).set({
                          'CompanyID':uid,
                          'email':_emailcontroller.text,
                          'name':_namecontroller.text,
                          'phone':_phonecontroller.text,
                          'description':_descriptioncontroller.text,
                          'address':_addressontroller.text,
                          'price':_pricecontroller.text,
                          'contract':_contractontroller.text,
                          'imageURL':'',
                        });
                    
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login(firestore: widget.firestore,
                        firebaseAuth: widget.firebaseAuth,
                        firebaseStorage: widget.firebaseStorage)),
                        );
                      }else{
                        print('please try later');
                      }
                    }
                  },
                )
              ],
            )
        ),
      ),
    ));
  }}