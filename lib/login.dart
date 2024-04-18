import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:maintenanceservices/Models/Actor.dart';
import 'package:maintenanceservices/Part2/Home.dart';
import 'package:maintenanceservices/Profile.dart';
import 'package:maintenanceservices/Validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ForgetPassword.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:maintenanceservices/signup.dart';
import 'CustomFormField.dart';
import 'Firebase_.dart';
import 'Tools.dart';
import 'main.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  bool secure = true ;
  Icon icon = Icon(Icons.remove_red_eye_rounded);
  Tools tools = new Tools();
  Firebase_ firebase = new Firebase_();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  Validator validator = new Validator() ;
  @override
  Widget build(BuildContext context) {
    Actor actor = new Actor() ;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: formstate,
                child: ListView(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Already\nhave an\nAccount?" ,
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
                          CustomFormField(
                            iconButton: IconButton(
                              icon: secure? Icon(Icons.remove_red_eye_outlined) : Icon(Icons.remove_red_eye_rounded) ,
                              onPressed: () {
                                if(secure){
                                  setState(() {
                                    secure = false ;
                                  });
                                }
                                else{
                                  setState(() {
                                    secure = true ;
                                  });
                                }
                              }
                            ),
                            controller: _passwordController,
                            icon: Icon(Icons.key) ,
                            textInputType: TextInputType.visiblePassword ,
                            hintText: 'Password',
                            obscureText : secure ,
                            validator: (value) {
                              if (!validator.isValidPassword(value.toString()))
                                return 'Enter valid Password';
                            },
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                            child: InkWell(
                              onTap: () {
                                new Tools().goToAnotherActivity(context, new ForgetPassword());
                              },
                              child: Text(
                                "Forget your password ?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Phudu" ,
                                ),
                              ),
                            ),
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
                                getSignIn();
                              }
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Phudu" ,
                              )
                            ),
                          ),
                          Center(child: tools.check(context, new signup(actor) , "Create Account")),
                          Center(
                              child: GestureDetector(
                                child: Text("Contact Us" ,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Phudu" ,
                                      color: Colors.blue
                                  ),
                                ),
                                onTap: () {
                                  ContactUsDialog(context);
                                },
                              )
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

  getSignIn() async {
    Actor actor = new Actor()  ;
    actor.email = _emailController.value.text ;
    actor.password = _passwordController.value.text ;
    final prefs= await SharedPreferences.getInstance();
    prefs.setString("userEmail", actor.email);
    prefs.setString("userPassword", actor.password);
    firebase.signIn(context, actor , new HomePage() );
  }

  signOut()async {
    await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser
        ?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
  }
  // Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //
  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }


  ContactUsDialog(BuildContext context ){
    return showDialog(context: context , builder: (context) {
      return AlertDialog(
        actionsPadding: EdgeInsets.all(10),
        scrollable: true,
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius:50,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("images/workersicon.png"),
              ),
              SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color:Colors.black,width: 2 ),
                  ),
                  hintText: 'Name',
                  //errorText: error ? 'please enter Your Name' : null,
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color:Colors.black,width: 2 )
                    ),
                    hintText: 'PhoneNumber',
                    prefixIcon: Icon(Icons.phone),
                    filled: true,
                    fillColor: Colors.white
                ),
              ),
              SizedBox(height: 15),

              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color:Colors.black,width: 2 )
                  ),
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter message';
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  //labelText: 'Enter Message',
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Message',
                  border: InputBorder.none,
                ),
                maxLines: 7, // <-- SEE HERE
              ),
              SizedBox(height: 30),
              MaterialButton(
                onPressed: (){
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                minWidth:double.infinity,
                color: secColor,
                child: Text('SUBMIT',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18),),
              ),
              IconButton(onPressed: (){
                showDialog(
                  context: context, builder: (Context){
                  return AlertDialog(
                      backgroundColor: Colors.white,
                      content: Column(
                          children: [
                            Container(
                              child: Text("Contact Information",style: TextStyle(fontStyle:FontStyle.italic,fontSize: 25,),),
                              decoration: BoxDecoration(
                                color: firstColor,
                                border: Border.all(width: 2,color: Colors.black38),
                              ),
                            ),
                            SizedBox(height: 50),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.fmd_good,color: secColor),
                                SizedBox(width: 20),
                                Text('7 st Mostafa elnahas, Cairo',style: TextStyle(fontSize: 15)),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.phone,color: secColor),
                                SizedBox(width: 20),
                                Text('01156366044',style: TextStyle(fontSize: 15)),

                              ],
                            ),
                            SizedBox(height: 20),

                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.email,color: secColor),
                                SizedBox(width: 20),
                                Text('Saiedmeligy83@gmail.com',style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ]
                      )
                  );
                },
                );
              }, icon: Icon(Icons.help),color: Colors.white,)
            ],
          ),
        ),
        backgroundColor: firstColor,
        alignment: Alignment.center,
      );
    });
  }
}


