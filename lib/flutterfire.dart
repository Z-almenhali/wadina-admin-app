import 'package:firebase_auth/firebase_auth.dart';

Future<bool> logIn(var email, var password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<bool> register(String email, String password) async {
  print("inside method");
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print("The password provided is too weak.");
    } else if (e.code == "email-already-in-use") {
      print("The account already exists for the eamil.");
    }
    return false;
  } catch (e) {
    print("inside catch block");
    print(e.toString());
    return false;
  }
}
