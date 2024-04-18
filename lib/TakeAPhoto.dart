import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenanceservices/Profile.dart';
import 'package:maintenanceservices/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Firebase_.dart';
import 'Tools.dart';
import 'package:path/path.dart';
import 'Models/Actor.dart';
import 'Validator.dart';
import 'main.dart';



class TakeAPhoto extends StatefulWidget {
  late Actor actor;
  @override
  State<TakeAPhoto> createState() => _TakeAPhotoState(actor);

  TakeAPhoto(this.actor);
}

class _TakeAPhotoState extends State<TakeAPhoto> {
  var imagepicker = ImagePicker() ;
  var imgpicked  ;
  late File file ;
  late Actor actor ;
  _TakeAPhotoState(this.actor);
  bool isPictureTaked = false ;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  Tools tools = new Tools();
  Firebase_ firebase = new Firebase_();
  Validator validator = new Validator() ;
  String photo = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/User_icon-cp.svg/1656px-User_icon-cp.svg.png" ;
  bool check = false ;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:Text('Upload Your Personal Phtoto' , style:TextStyle(fontSize: 25),),
          backgroundColor: secColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30),),
            side: BorderSide(width: 1.0, color: Colors.white),),
          shadowColor:Colors.white,
          leading: IconButton(
            onPressed: () {
              new Tools().goToAnotherActivity(context, new signup(actor));
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: firstColor,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                SizedBox(height: 50,),
                CircleAvatar(
                  radius: 152,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundImage: getFile() ,
                    backgroundColor: Colors.white ,
                    radius: 148,
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100)
                              ),
                              child: IconButton(onPressed: (){
                                finshUploadingImage(context , "camera") ;
                              }, icon: Icon(Icons.camera_alt_outlined, color: Colors.blue , size: 30,)),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100)
                              ),
                              child: IconButton(onPressed: (){
                                finshUploadingImage(context , "gallery") ;
                              }, icon: Icon(Icons.image, color: Colors.blue , size: 30,)),
                            )
                          ]
                        )
                      ],
                    ) ,
                  ),

                ) ,
                SizedBox(height: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white ,
                    fixedSize: Size(300, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                  ),
                  onPressed: check? () {
                    setState((){
                      check = false ;
                    });
                    getSignup(context) ;
                  } : null ,
                  child: Text('SignUp' , style: TextStyle(color: firstColor),),
                ),
              ],
            ),
          ) ,
        ),
      ),
    );
  }

  finshUploadingImage(BuildContext con , String kind){
    getImage(con , kind).then((value){
      check = true ;
    });
  }

  showDialoge(context){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (sa) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // CircularProgressIndicator(backgroundColor: Colors.black,color: Colors.white,),
                  SizedBox(
                    height: 0,
                  ),
                  LinearProgressIndicator(backgroundColor: Colors.black,color: Colors.white,minHeight: 20,),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text("loading...",style: TextStyle(fontSize: 20),) ,
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Future<String> uploadImage()async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    var random = Random().nextInt(10000000);
    var nameImage = basename(imgpicked.path);
    nameImage = "$random$nameImage";
    var refStorge = FirebaseStorage.instance.ref("images/$nameImage");
    await refStorge.putFile(file);
    String url = await refStorge.getDownloadURL();
    actor.photo = url ;
    return url ;
  }

  getImage(BuildContext context , String kind) async {
    if(kind == "gallery")
      imgpicked = await imagepicker.pickImage(source: ImageSource.gallery) ;
    else
      imgpicked = await imagepicker.pickImage(source: ImageSource.camera) ;
    if(imgpicked != null){
      setState((){
        file = File(imgpicked.path);
        photo = file.path;
      });
      isPictureTaked = true ;
      AwesomeDialog(context: context , title: "error", body: Text('image picked successefully.\n\n')).show();
    }
    else{
      AwesomeDialog(context: context , title: "error", body: Text('please choose image.\n\n')).show();
    }
  }

  getSignup(context) async {
    final prefs= await SharedPreferences.getInstance();
    prefs.setString('userName',actor.name );
    prefs.setString('userId',actor.ID );
    prefs.setString('userImage',actor.photo );
    prefs.setString('userEmail',actor.email );
    prefs.setString('userPhone',actor.phone );
    uploadImage().whenComplete((){
      firebase.signup(context , actor , new Profile() ) ;
    });
  }

  getFile(){
    try{
      return Image.file(file).image;

    }catch(ex){
      return Image.asset(photo).image ;
    }
  }
}

