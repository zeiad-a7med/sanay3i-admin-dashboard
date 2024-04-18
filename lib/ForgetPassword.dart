import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'CustomFormField.dart';
import 'Validator.dart';
import 'login.dart';
import 'main.dart';


class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  Validator validator = new Validator() ;
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: formstate,
              child: ListView(
                children: [
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back,),
                          color: Colors.black ,
                          onPressed: () {
                            Navigator.pushReplacement( context , new MaterialPageRoute(builder: (context) => new login()) );
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          "Reset\nthe\npassword" ,
                          style: TextStyle(
                            fontSize: 30.0,
                            color: firstColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Phudu" ,
                          ),
                        ),
                        SizedBox(width: 3,),
                        Expanded(
                          child: ClipPath(
                            clipper: RoundedDiagonalPathClipper(),
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                color: firstColor
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 60,),
                                  Expanded(child: Image.asset("images/workersicon.png" ,scale: 5,)),
                                ],
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        CustomFormField(
                          controller: _emailController,
                          icon: Icon(Icons.mail) ,
                          hintText: 'Email',
                          validator: (value) {
                            if (!validator.isValidEmail(value.toString()))
                              return 'Enter valid email';
                          },
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: firstColor,
                            fixedSize: Size(300, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            ),
                          ),
                          onPressed: () {
                            if (formstate.currentState!.validate()) {
                              resetPassword(_emailController.value.text);
                            }
                          },
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Phudu" ,
                            )
                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }

  resetPassword(String email) async {
    if(await checkIfEmailValied(email)){
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      AwesomeDialog(context: context, title: "error", body: Text('Go Check Your Inbox And Reset Your Password.\n\n' ,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          fontFamily: "Phudu" ,
        ),
      )).show();
      _emailController.text = "" ;
    }else{
      AwesomeDialog(context: context, title: "error", body: Text('use the correct email.\n\n',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          fontFamily: "Phudu" ,
        ),
      )).show();
    }
  }
  checkIfEmailValied(String email)async{
    UserCredential userCredential ;
    try{
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email ,
        password: "WRONGPASSWORD" ,
      );
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return true ;
      }else{
        return false ;
      }
    }
  }
}