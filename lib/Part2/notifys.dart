import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:maintenanceservices/Models/Requests.dart';
import 'package:maintenanceservices/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Tools.dart';
import '../login.dart';
import '../main.dart';
import '../FirebaseRealtime.dart';
import 'acceptedOrder.dart';
import 'currentOrder.dart';
import 'myorders.dart';
import 'notifys.dart';
import 'pickdate.dart';
import 'home.dart';
class Notifys extends StatefulWidget{

  @override
  State<Notifys> createState() => _NotifysState();
}

class _NotifysState extends State<Notifys> {
  String category="";
  String iconImg="";
  String userLoc="";
  dynamic pageIndex,userId,userName,img,email,phone,myLoc;
  String selectedService="";
  int? selectedIndex;
  bool hasData=false;
  int index=2;
  dynamic requests={};
  dynamic allrequests;
  List<String> requestsIds=[];
  int changeState=0;
  FirebaseRealtime fire=new FirebaseRealtime();
  int startNotifications=0;
  getRequsts() async {
    final starCountR=FirebaseDatabase.instance.ref('data/user/${FirebaseAuth.instance.currentUser?.uid.toString()}/notifications');
    dynamic req = await starCountR.get();
    Map<dynamic, dynamic>? values = req.value as Map?;
    if(values!=null){
      for(var id in values!.keys){
        requestsIds.add("${id}");
        final starCountR2=FirebaseDatabase.instance.ref('data/requests/${id}');
        dynamic req2 = await starCountR2.get();
        Map<dynamic, dynamic>? values2 = req2.value as Map?;
        requests["${id}"]=values2;
      }
    }
    if(requestsIds.length==0){
      hasData=false;
    }else{
      hasData=true;
    }
    setState(() {
      changeState=1;
    });
  }
  getData() async {
    requestsIds=[];
    requests={};
    ConnectivityResult r = await Connectivity().checkConnectivity();
    if (r == ConnectivityResult.none) {

    }else{
      await getRequsts();

    }
  }
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
                  Navigator.pop(context);
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
        print("==============rererere");
        setState(() {
          startNotifications=1;
          changeState=0;
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
    print("sadsadas notify");
    bool foundOrders=false;
    MediaQueryData deviceInfo = MediaQuery.of(context);
    double ScreenWidth= deviceInfo.size.width;
    dynamic noDataFound=ListView(
      children: [
        Container(
          width: ScreenWidth,
          height:deviceInfo.size.height-140,
          child: Align(
              alignment: Alignment.center,
              child: Container(
                width: ScreenWidth,
                child: Column(
                  children: [
                    Icon(Icons.priority_high,color: Colors.grey,size: 400,),
                    Text("There Is No Notifications",style: TextStyle(color: Colors.grey,fontSize: 30),)
                  ],
                ),
              )
          ),
        )
      ],
    );
    print(changeState);
    print(startNotifications);
    print(hasData);
    if(startNotifications==0){
      listenNotifications();
    }
    if(changeState==0){
      getData();
    }

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
            Icon(Icons.notifications, size: 30,color: Colors.white,),
          ],
          onTap: (index) {
            if(index==0){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            }else if(index==1){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrders()));

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
              ),              SizedBox(
                width: 10,
              ),
              Text(
                'Online Maintnance Services',
                style: TextStyle(color: Colors.white , fontSize: 15),
              ),
            ],
          ),
          backgroundColor: firstColor, //<-- SEE HERE
        ),
        drawer:Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.blue,
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
                        Navigator.pushReplacement( context , new MaterialPageRoute(builder: (context) => new login()) );
                      });

                    },
                  ).show();
                },
              ),
            ],
          ),
        ),
        body:Center(
            child:RefreshIndicator(
                color: Colors.orange,
                strokeWidth: 5,
                edgeOffset: 20,
                onRefresh:()async{
                  setState(() {
                    changeState=0;
                  });
                },
                child:(!hasData)?noDataFound:ListView.builder(
                  itemCount: requestsIds.length,
                  itemBuilder:(context,i){
                    if(requests[requestsIds[i]]["state"]!=null){
                      foundOrders=true;
                      return Container (
                        width: ScreenWidth,
                        height: 115,
                        decoration: BoxDecoration(
                            border:Border(
                              top: BorderSide(width: 1, color: Colors.grey.shade300),
                              bottom: BorderSide(width: 1, color: Colors.grey.shade300),
                            )
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                width: ScreenWidth/4-20,
                                height: 90,
                                decoration:BoxDecoration(
                                  image: DecorationImage(
                                    image: Image.asset("image/1530481.png",).image,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(15),
                                  ),
                                ),

                              ),
                            ),
                            Container(
                                width:ScreenWidth/2,
                                height: 115,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 57.5,
                                      width: ScreenWidth/2,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                        child: Text("${requests[requestsIds[i]]["category"]} Service",style: TextStyle(color:Colors.black,fontSize: 17,),softWrap: false, maxLines: 2, overflow: TextOverflow.fade,),
                                      ),
                                    ),
                                    Container(
                                      height: 25,
                                      width: ScreenWidth/2,
                                      child: Text("${requests[requestsIds[i]]["selectedDayName"]},${requests[requestsIds[i]]["selectedDay"]} ${requests[requestsIds[i]]["selectedMonth"]}  ${requests[requestsIds[i]]["selectedTime"]}:00",style: TextStyle(color:Colors.black,fontSize: 15,),softWrap: false, maxLines: 2, overflow: TextOverflow.fade,),
                                    ),
                                    Container(
                                      height: 25,
                                      width: ScreenWidth/2,
                                      child: Text("${requests[requestsIds[i]]["isArrived"]}",style: TextStyle(color:(requests[requestsIds[i]]["state"]=="Not Accepted Yet"||requests[requestsIds[i]]["state"]=="Rejected")?Colors.red:Colors.green,fontSize: 12,),softWrap: false, maxLines: 2, overflow: TextOverflow.fade,),
                                    ),
                                  ],
                                )

                            ),
                            Container(
                              width:ScreenWidth/4,
                              height: 115,
                              child: Align(
                                alignment: Alignment.center,
                                child:SizedBox(
                                    height:40, //height of button
                                    width:ScreenWidth/5 , //width of button
                                    child:ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(0),
                                          primary: (selectedIndex==i)?Colors.black:Colors.grey.shade300, //background color of button
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30)
                                          ), //content padding inside button
                                        ),
                                        onPressed:(requests[requestsIds[i]]["state"]=="Not Accepted Yet")?null:(){
                                          Requests req=new Requests();
                                          req.sanayeeId       =requests[requestsIds[i]]["sanayeeId"];
                                          req.requestId       =requests[requestsIds[i]]["requestId"];
                                          req.category        =requests[requestsIds[i]]["category"];
                                          req.userLoc         =requests[requestsIds[i]]["userLoc"];
                                          req.selectedService =requests[requestsIds[i]]["selectedService"];
                                          req.selectedMonth   =requests[requestsIds[i]]["selectedMonth"];
                                          req.selectedDay     =requests[requestsIds[i]]["selectedDay"];
                                          req.selectedDayName =requests[requestsIds[i]]["selectedDayName"];
                                          req.selectedTime    =requests[requestsIds[i]]["selectedTime"];
                                          req.description     =requests[requestsIds[i]]["description"];
                                          req.state           =requests[requestsIds[i]]["state"];
                                          req.isArrived       =requests[requestsIds[i]]["isArrived"];
                                          req.lat             =requests[requestsIds[i]]["lat"];
                                          req.long            =requests[requestsIds[i]]["long"];
                                          req.userId          =requests[requestsIds[i]]["userId"];
                                          req.userPhone       =requests[requestsIds[i]]["userPhone"];
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => CurrentOrder(req)));
                                        },
                                        child: Text("View",style: TextStyle(color: (requests[requestsIds[i]]["state"]=="Not Accepted Yet"||requests[requestsIds[i]]["state"]=="Rejected")?Colors.grey:Colors.black,fontSize: 17,fontWeight: FontWeight.w400),)
                                    )
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }else{
                      if(!foundOrders&&requests.length==i-1){
                        return ListView(
                          children: [
                            Container(
                              width: ScreenWidth,
                              height:deviceInfo.size.height,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: ScreenWidth,
                                    child: Column(
                                      children: [
                                        Icon(Icons.priority_high,color: Colors.grey,size: 400,),
                                        Text("There Is No Orders",style: TextStyle(color: Colors.grey,fontSize: 30),)
                                      ],
                                    ),
                                  )
                              ),
                            )
                          ],
                        );
                      }else{
                        return Container();
                      }
                    }
                  },
                )

            )

        )
    );
  }
}
