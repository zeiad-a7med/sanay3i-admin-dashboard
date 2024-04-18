import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maintenanceservices/Profile.dart';
import 'CustomFormField.dart';
import 'Validator.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  @override
  State<VerifyPhoneNumberScreen> createState() => _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  Validator validator = new Validator() ;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController otpCode = TextEditingController();

  bool isLoading  = false ;
  bool codeIsSent = false ;
  String? verificationId;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(220, 134, 101, 1),
                Color.fromRGBO(83, 70, 102, 1)
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body:  Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_left,),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pushReplacement( context , new MaterialPageRoute(builder: (context) => new Profile()) );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child:
                    CustomFormField(
                      textInputType: TextInputType.phone ,
                      inputDecoration: getEditTextDecoration("Phone Number", Icon(Icons.phone , color: Colors.white)),
                      controller: phoneNumber ,
                      hintText: 'Phone',
                      validator: (value) {
                        if (!validator.isValidPhone(value.toString()))
                          return 'Enter valid Phone';
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child:
                    CustomFormField(
                      textInputType: TextInputType.phone ,
                      inputDecoration: getEditTextDecoration("Enter Otp", Icon(Icons.phone , color: Colors.white)),
                      controller: otpCode ,
                      hintText: 'Enter Otp',
                      enabled: codeIsSent,
                      // validator: (value) {
                      //   if (!validator.isValidPhone(value.toString()))
                      //     return 'Enter valid Phone';
                      // },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: size.height * 0.05)),
                  !isLoading ? SizedBox(
                    width: size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          await phoneSignIn(phoneNumber: "+20"+phoneNumber.text);
                        }
                      },
                      child: Text("SignIn"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(83, 70, 102, 1),
                        fixedSize: Size(150, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                    ),
                  ) : !codeIsSent ? CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 1,
                  ) : SizedBox(
                    width: size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          sendCode(otpCode.value.text, "+2"+phoneNumber.text);
                        }
                      },
                      child: Text("send code"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(83, 70, 102, 1),
                        fixedSize: Size(150, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                    ),
                  ) ,
                ],
              ),
            ),
          )
        )
      ]
    );
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout
    );
  }

  sendCode(String code , String phoneNumber)async{
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: this.verificationId.toString() , smsCode: code);
    FirebaseAuth.instance.currentUser?.updatePhoneNumber(credential);
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      this.otpCode.text = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      try{
        UserCredential credential =
        await user!.linkWithCredential(authCredential);
      }on FirebaseAuthException catch(e){
        if(e.code == 'provider-already-linked'){
          await _auth.signInWithCredential(authCredential);
        }
      }
      setState(() {
        isLoading = false;
      });

      DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("data").child("user").child(FirebaseAuth.instance.currentUser!.uid);
      databaseReference.child("phone").set(FirebaseAuth.instance.currentUser!.phoneNumber);

      Navigator.pushReplacement( context , new MaterialPageRoute(builder: (context) => new Profile()) );
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      showMessage("The phone number entered is invalid!");
    }
    else if (exception.toString().contains("Try again later."))
      AwesomeDialog(context: context , title: "error" , body: Text("Try Again After 1 minute"));
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    setState((){
      codeIsSent = true ;
    });
  }

  _onCodeTimeout(String timeout) {
    print("((: timeout = ${timeout}");
    return null;
  }

  void showMessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () async {
                Navigator.of(builderContext).pop();
              },
            )
          ],
        );
      }).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  InputDecoration getEditTextDecoration(String hint, Icon icon) {
    return (
      new InputDecoration(
        errorStyle: TextStyle(fontSize: 12.0, color: Colors.red) ,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        prefixStyle: TextStyle(fontSize: 10.0, color: Colors.black26) ,
        suffixStyle: TextStyle(fontSize: 10.0, color: Colors.black26) ,
        prefixIcon: icon ,
        fillColor: Colors.white,
        hintStyle: TextStyle(fontSize: 15.0, color: Colors.white70 ),
        filled: false,
        hintText: hint,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      )
    );
  }
}