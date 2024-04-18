import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maintenanceservices/Part2/Home.dart';
import 'package:maintenanceservices/Part2/myorders.dart';
import 'package:maintenanceservices/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Mycolors.dart';
import '../Tools.dart';
import '../login.dart';
import '../cards/cateogrycard.dart';
import '../Models/Cateogry.dart';
import '../main.dart';
import 'notifys.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // MyColors mycolors=new MyColors();

  List<String>imagesOfCarousel = [] ;
  dynamic name="ac";
  List<Cateogry> cateogries = [];
  bool check = true ;
  int index=0;
  double heightOfGrid=0.0;
  int startNotifications=0;
  int notify=0;
  listenNotifications() async {
    ConnectivityResult r = await Connectivity().checkConnectivity();
    if (r == ConnectivityResult.none) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Check Your Connection!',style: TextStyle(fontSize: 15),),
            actions: <Widget>[
              TextButton(
                child: const Text('try again'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {

                  });
                },
              ),
            ],
          );
        },
      );
    }else{
      final mainRef=FirebaseDatabase.instance.ref('data/user/${FirebaseAuth.instance.currentUser?.uid}/notifications');
      mainRef.onValue.listen((DatabaseEvent event) {
        dynamic values = event.snapshot.value;
        if(values!=null){
          notify=values.length;
        }
        setState(() {
          startNotifications=1;
        });
      });

      mainRef.onChildChanged.listen((DatabaseEvent event) {
        dynamic values = event.snapshot.value;
        if(values!=null){
          notify=values.length;
        }
        setState(() {
          startNotifications=1;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final String assetName = 'images/skill.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
    );
    print("sdfsdfsdfds home");
    if(startNotifications==0){
      listenNotifications();
    }
    if(check){
      readyHome();
    }
    // getValueFromDatabase("data/category/ac");
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInBack,
          index: index,
          color: firstColor,
          height: 55,
          items: <Widget>[
            Icon(Icons.home , size: 30,color: Colors.white,),
            Icon(Icons.list, size: 30,color: Colors.white,),
            (notify!=0)?Badge(
              badgeContent: Text('${notify}'),
              child: Icon(Icons.notifications, size: 30,color: Colors.white,),
            ):Icon(Icons.notifications, size: 30,color: Colors.white,),
          ],
          onTap: (index) {
            if(index==1){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrders()));
            }else if(index==2){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Notifys()));

            }
          },
        ),
        appBar:AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width:40 ,
                height:40 ,
                child: svg,
              ),

              SizedBox(
                width: 10,
              ),
              Text(
                'Online Maintnance Services',
                style: TextStyle(color: Colors.white , fontSize: 15),
              ),
            ],
          ),
          backgroundColor:firstColor, //<-- SEE HERE
        ),
        drawer:Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    color: firstColor,
                    image: DecorationImage(
                        image: NetworkImage("${FirebaseAuth.instance.currentUser?.photoURL}"),
                        fit: BoxFit.cover
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end ,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end ,
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Text(
                                "${FirebaseAuth.instance.currentUser?.displayName}",
                                textAlign: TextAlign.center,
                                style : TextStyle(
                                  fontSize : 20 ,
                                  color: firstColor ,
                                  fontWeight: FontWeight.bold ,
                                  fontFamily: "Phudu" ,
                                )
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              ListTile(
                title: Text("Profile" , style : TextStyle(fontSize:20 , color: firstColor,fontWeight: FontWeight.bold, fontFamily: "Phudu" ,),),
                onTap: () {
                  new Tools().goToAnotherActivity(context, new Profile());
                },
              ),
              ListTile(
                title: Text("Logout ?" , style : TextStyle(fontSize:20 , color: firstColor,fontWeight: FontWeight.bold, fontFamily: "Phudu" ,),),
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    title: "error",
                    body: Text('\tLogout ?'),
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      FirebaseAuth.instance.signOut();
                      final prefs= await SharedPreferences.getInstance();
                      prefs.remove('userName');
                      prefs.remove('userEmail');
                      prefs.remove('userPhone');
                      prefs.remove('userImage');
                      new Tools().showDialoge(context);
                      new Tools().delay((){
                        new Tools().disposeDialog(context);
                        Navigator.pushReplacement( context , new MaterialPageRoute(builder: (context) => login()) );
                      });

                    },
                  ).show();
                },
              ),

            ],
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child:ListView(
                children: [
                    imagesOfCarousel.length != 0 ? Container(
                    width: double.infinity,
                    height: 300,
                    child: Carousel(
                      dotSize: 6,
                      dotSpacing: 15,
                      dotPosition: DotPosition.bottomCenter,
                      images: [
                        for( int x = 0 ; x < imagesOfCarousel.length ; x++ )...[
                          Image(image: NetworkImage(imagesOfCarousel[x]),fit: BoxFit.fill),
                        ],
                      ],
                    ),
                  ) : SizedBox() ,
                  Container(
                    margin: EdgeInsets.only(top: 20 , left:30 , right: 30 ),
                    width: double.infinity,
                    height:(cateogries.length%2==0)?cateogries.length * 140:(((cateogries.length)+1) * 140),
                    decoration: BoxDecoration(
                      color: firstColor,
                      border: Border.all(width: 5 , color: firstColor),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow:[
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 2),
                        ),

                      ],

                    ),
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(5),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 0,
                            mainAxisExtent: 270
                        ),
                        itemCount: cateogries.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return GestureDetector(
                              onTap: (){
                              },
                              child: CategoryCard(cateogries[index])
                          );
                        }
                    ),
                  ) ,
                  SizedBox(
                    height: 200,
                  ),
                ],
              ),
            )
          )
        )
    );
  }

  getImagesOfCarousel(){
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('data/carousel/');
    starCountRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
      values?.forEach((key,values) {
        imagesOfCarousel.add(values);
      });
      setState(() {
        check = false ;

      });
    });
  }
  getCategories(){
    cateogries=[];
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('data/category/');
    starCountRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
      values?.forEach((key,values) {
        cateogries.add(new Cateogry(key, values["image"]));
      });
      setState(() {
        check = false ;
      });
    });

  }
  Future<void> readyHome() async {
    ConnectivityResult r = await Connectivity().checkConnectivity();
    if (r == ConnectivityResult.none) {

    }else{
      await getImagesOfCarousel();
      await getCategories();
    }

  }



}
