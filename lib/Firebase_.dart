import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/Actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'Tools.dart';
import 'main.dart';



class Firebase_{
  late UserCredential userCredential;

  signIn(context , Actor user , secondPage) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    try{
      print(user.email);
      print(user.password);
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email ,
        password: user.password ,
      );
      new Tools().showDialoge(context);
      new Tools().delay((){
        Navigator.of(context).pop();
        new Tools().goToAnotherActivity(context,secondPage);
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("userEmail", user.email);
      prefs.setString("userPassword", user.password);

      return true ;
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AwesomeDialog(context: context, title: "error", body: Text('No user found for that email.\n\n')).show();
      } else if (e.code == 'wrong-password') {
        AwesomeDialog(context: context, title: "error", body: Text('Wrong password provided for that user.\n\n')).show();
      }
    }
  }

  signup(context , Actor user , secondPage) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email ,
        password: user.password,
      );
      userCredential.user?.updateDisplayName(user.name);
      userCredential.user?.updatePhotoURL(user.photo);
      new Tools().showDialoge(context);
      new Tools().delay((){
        new Tools().disposeDialog(context);
        Navigator.pushReplacement( context , new MaterialPageRoute(builder: (context) => secondPage) );
      });
      final DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("data").child("user").child(userCredential.user!.uid);
      databaseReference.child("image").set(user.photo);
      databaseReference.child("phone").set(user.phone);
      databaseReference.child("name").set(user.name);

    } on FirebaseAuthException catch(ex){
      FirebaseStorage.instance.refFromURL(user.photo).delete();
      if(ex.code == 'weak-password'){
        AwesomeDialog(context: context, title: "error", body: Text('\tThe password provided is too weak.\n\n')).show();
      }else if(ex.code == 'email-already-in-use'){
        AwesomeDialog(context: context, title: "error", body: Text('\tThe account already exists for that email.\n\n')).show();
      }
    }
  }

  Future<String> showDialoge(context) async {
    TextEditingController _digitsController = TextEditingController() ;
    String digits = "" ;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (sa) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Container(
                height: 170 ,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text("Enter Code.\n"),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: getEditTextDecoration(),
                            controller: _digitsController ,
                            keyboardType: TextInputType.number ,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{1,6}$')),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: (){
                        digits = _digitsController.value.text ;
                      },
                      child: Text("Confirm")
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
    return digits ;
  }


  InputDecoration getEditTextDecoration() {
    return (
        new InputDecoration(
          fillColor: Colors.white,
          hintStyle: TextStyle(fontSize: 15.0, color: firstColor),
          filled: false,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: firstColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: firstColor,
              width: 2.0,
            ),
          ),
        )
    );
  }
}