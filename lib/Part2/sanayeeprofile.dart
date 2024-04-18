import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:maintenanceservices/FirebaseRealtime.dart';
import 'package:maintenanceservices/Models/Requests.dart';
import 'package:maintenanceservices/cards/review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/ordertime.dart';
import '../VerifyPhoneNumberScreen.dart';
import '../main.dart';
import 'Home.dart';
import 'myorders.dart';
import 'pickdate.dart';
dynamic userId,userName;
class Sanayeeprofile extends StatefulWidget{

   dynamic sanayeeId,category,userLoc,selectedService,description;
   dynamic markIcons;
   OrderTime orderTime;

   Sanayeeprofile(this.sanayeeId,this.category,this.userLoc,this.selectedService,this.orderTime,this.description,this.markIcons);
  @override
  State<Sanayeeprofile> createState() => _SanayeeprofileState(sanayeeId,orderTime);
}

class _SanayeeprofileState extends State<Sanayeeprofile> {
   dynamic email,pass,img,phone,status,sanayeeCategory,sanayeeId,sanayeeName,lat,long="";
   OrderTime orderTime;
   Map<dynamic,dynamic> reviews={};
   dynamic Loc=LatLng(30.01,31.239);
   int changestate=0;
   List<bool> doneReq=[false,false,false];
   _SanayeeprofileState(this.sanayeeId,this.orderTime);
   dynamic sanayeeMarker;
   @override
  Widget build(BuildContext context) {

     if(changestate==0) {
       getData();
       setState(() {
       });
     }

    MediaQueryData deviceInfo = MediaQuery. of(context);
    double ScreenWidth= deviceInfo.size.width;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50, // Set this height
          leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
            onPressed:() => Navigator.pop(context, false),
          ),
          title: Text("Request Industrial"),
          backgroundColor: firstColor,
        ),
        body:(changestate==0)?loading():Center(
            child:Stack(
              children: [
                ListView(
                  children: [
                    Container(
                        height: 210,
                        color: Colors.white,
                        child:Stack(
                          children: [
                            Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              color: firstColor,
                            ),
                            Padding(
                              padding:EdgeInsets.fromLTRB(10, 30, 10, 0),
                              child: Container(

                                decoration:BoxDecoration(
                                    boxShadow:[
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5), //color of shadow
                                        spreadRadius: 5, //spread radius
                                        blurRadius: 7, // blur radius
                                        offset: Offset(0, 2), // changes position of shadow
                                        //first paramerter of offset is left-right
                                        //second parameter is top to down
                                      ),
                                      //you can set more BoxShadow() here
                                    ],
                                    border: Border.all(
                                        color: const Color(0xFF000000),
                                        width: 0.1,
                                        style: BorderStyle.solid
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: Colors.white//BorderRadius.all
                                ),
                                height:180,
                                width: (MediaQuery.of(context).size.width),
                                child: Column(
                                  children: [
                                    Container(
                                      height:100,
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child:Container(
                                                width: 80,height: 80,
                                                decoration:BoxDecoration(
                                                  image: DecorationImage(
                                                    image: Image.network("${img}").image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius: BorderRadius.all(Radius.circular(65),
                                                  ),
                                                ),
                                              )
                                          ),
                                          Container(
                                            height: 120,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:EdgeInsets.fromLTRB(0, 30, 0,0),
                                                  child: Container(
                                                    width:ScreenWidth/2,
                                                    height: 27,
                                                    child:Text("${sanayeeName}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold), softWrap: false, maxLines: 1, overflow: TextOverflow.fade,),

                                                  ),
                                                ),
                                                Padding(
                                                  padding:EdgeInsets.fromLTRB(0, 0, 0,2),
                                                  child: Container(
                                                    width:ScreenWidth/2,

                                                    child:Text("${sanayeeCategory}",style: TextStyle(fontSize: 12,color: Colors.grey), softWrap: false, maxLines: 1, overflow: TextOverflow.fade,),

                                                  ),
                                                ),
                                                Container(
                                                  width: ScreenWidth/2,
                                                  child:Row(
                                                    children: [
                                                      Icon(Icons.star,color: Colors.yellow.shade900,),
                                                      Text("20"),
                                                      Text("(100+)",style: TextStyle(color:Colors.grey),),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            child:Icon(Icons.info,color: Colors.grey,)
                                            ,
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height:79,
                                      child: Row(
                                        children: [
                                          Container(
                                            height:40,
                                            decoration:BoxDecoration(
                                              border: Border(
                                                right: BorderSide(color:Colors.grey),
                                              ),
                                            ),
                                            width:MediaQuery.of(context).size.width/3,
                                            child: Center(
                                              child: Padding(

                                                padding: EdgeInsets.all(0),
                                                child:Column(
                                                  children: [
                                                    Text("Deliver time",style: TextStyle(color: Colors.grey),),
                                                    Text("max 60mins"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height:40,
                                            decoration:BoxDecoration(
                                              border: Border(
                                                right: BorderSide(color:Colors.grey),
                                              ),
                                            ),
                                            width:MediaQuery.of(context).size.width/3-20,
                                            child: Center(
                                              child: Padding(

                                                padding: EdgeInsets.all(0),
                                                child:Column(
                                                  children: [
                                                    Text("",style: TextStyle(color: Colors.grey),),
                                                    Text(""),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height:45,

                                            width:MediaQuery.of(context).size.width/3-20,
                                            child: Center(
                                              child: Padding(

                                                padding: EdgeInsets.all(0),
                                                child:Column(
                                                  children: [
                                                    Text("Status",style: TextStyle(color: Colors.grey),),
                                                    Text("${status}",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 17)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                    ),

                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child:Text("Industrial Location",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 17),)
                    ),
                    Container(
                      width: ScreenWidth,
                      height: 1,
                      color: Colors.grey.shade500,
                    ),
                    Container(
                      width:ScreenWidth,
                      height:300,
                      child:Align(
                        alignment: Alignment.center,
                        child: Container(
                          width:ScreenWidth-50,
                          height:280,
                          child: (changestate==0)?null:GoogleMap(
                            compassEnabled: true,
                              circles: {
                                Circle(
                                  onTap: (){},
                                  circleId:CircleId("0") ,
                                  center: Loc,
                                  fillColor: firstColor.withOpacity(0.3),
                                  radius: 400,
                                  strokeWidth: 1,
                                  strokeColor: Colors.orange

                                )
                              },
                              onMapCreated: (controller) {

                              },
                              initialCameraPosition: CameraPosition(
                                target: Loc,
                                zoom: 15,
                              ),
                              markers: {
                                sanayeeMarker
                              }
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: ScreenWidth,
                      height: 60,
                    ),
                    (reviews.length!=0)?Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child:Text("Reviews",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 17),)
                    ):Text(""),
                    (reviews.length!=0)?Container(
                      width: ScreenWidth,
                      height: 1,
                      color: Colors.grey.shade500,
                    ):Text(""),
                    for(var i in reviews.values)
                      Review(i),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      color: Colors.white,
                      width:ScreenWidth,
                      height:60,
                      child:Align(
                          alignment: Alignment.topCenter,
                          child:Container(
                            color: Colors.white,
                            width: ScreenWidth-30,
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: secColor, //background color of button
                                  shape: RoundedRectangleBorder( //to set border radius to button
                                      borderRadius: BorderRadius.circular(5)
                                  ), //content padding inside button
                                ),
                                onPressed: ()async{
                                  final prefs= await SharedPreferences.getInstance();

                                  Requests request = new Requests();
                                  Position position = await Geolocator.getCurrentPosition();
                                  print(position.longitude); //Output: 80.24599079
                                  print(position.latitude); //Output: 29.6593457
                                  dynamic long = position.longitude;
                                  dynamic lat = position.latitude;
                                  request.sanayeeId = sanayeeId.toString() ;
                                  request.userId = FirebaseAuth.instance.currentUser!.uid ;
                                  request.category = widget.category.toString();
                                  request.userLoc = widget.userLoc.toString() ;
                                  dynamic phone;

                                  if(prefs.get('userPhone')!=null){
                                    phone=prefs.get('userPhone');
                                    print("pref=${phone}");
                                  }else{
                                    print(FirebaseAuth.instance.currentUser?.uid.toString());
                                    // final starCountR=FirebaseDatabase.instance.ref('data/user/${FirebaseAuth.instance.currentUser?.uid.toString()}/phone');
                                    // dynamic req = await starCountR.get();
                                    String phone  =  await new FirebaseRealtime().getOneChildFromDatabase('data/user/${FirebaseAuth.instance.currentUser?.uid.toString()}/phone');
                                    print(phone);
                                      // phone=req.value;
                                    prefs.setString("userPhone", phone);
                                    print("fire=${phone}");
                                  }
                                  request.userPhone=phone.toString();
                                  request.lat = lat ;
                                  request.long = long ;
                                  request.selectedService = widget.selectedService;
                                  request.selectedMonth = widget.orderTime.SelectedMonth.toString() ;
                                  request.selectedDay = widget.orderTime.SelectedDay.toString() ;
                                  request.selectedDayName = widget.orderTime.SelectedDayName.toString() ;
                                  request.selectedTime = widget.orderTime.SelectedTime;
                                  request.description = widget.description.toString() ;
                                  request.requestId = "${Random().nextInt(1000000)}${Random().nextInt(1000000)}${Random().nextInt(1000000)}" ;
                                  sendRequest(request);
                                  },
                                child: Text("Request",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w400),)
                            ) ,
                          )
                      )
                  ),
                )
              ],
            )
        )
    );
  }

  getSnai3(String id) async {
     DatabaseReference starCountRef = FirebaseDatabase.instance.ref('data/snai3/$id');
     await starCountRef.onValue.listen((DatabaseEvent event) {
       Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
       sanayeeName=values!["snayname"];
       sanayeeCategory=values!["category"];
       status=values!["status"];
       lat=values!["lat"];
       long=values!["long"];
       img=values!["profilephoto"]["path"];
       email=values!["email"];
       Loc=LatLng(lat, long);
       if(values!["reviews"]!=null){
         reviews=values!["reviews"];
       }

       sanayeeMarker=Marker(
         markerId: MarkerId('0'),
         icon: BitmapDescriptor.fromBytes(widget.markIcons),
         position: Loc,
         infoWindow: InfoWindow(
           // given title for marker
           title: "${sanayeeName}",
         ),
       );
       setState(() {
         changestate=1;
       });
     });
   }
  getData() async {
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
      await getSnai3(sanayeeId);
      setState(() {
      });
    }

   }
  sendRequest(Requests request) async {
    _dialogBuilder(context);
    int timeout = 5;
    try {
      http.Response response = await http.get(Uri.parse('https://maintenance-services-afa6d-default-rtdb.firebaseio.com/')).
      timeout(Duration(seconds: timeout));
      if (response.statusCode == 200) {
        addRequestToTheTableOfTheRequests(request);
        addRequestToTheTableOfTheSani3(request);
        addRequestToTheTableOfTheUser(request);
        if(doneReq[0]==true&&doneReq[1]==true&&doneReq[2]==true){
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrders()));
        }

      } else {
        // handle it
      }
    } on TimeoutException catch (e) {

      Navigator.of(context).pop();
      _dialogErorr(context);
      print('Timeout Error: $e');
    } on SocketException catch (e) {

      Navigator.of(context).pop();
      _dialogErorr(context);
      print('Socket Error: $e');
    } on Error catch (e) {

      Navigator.of(context).pop();
      _dialogErorr(context);
      print('General Error: $e');
    }

  }
  addRequestToTheTableOfTheUser(Requests request){
     DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("data").child("user").child(request.userId);
     print("////////////////////////////////////////////////////////${request.userId}");
     databaseReference.child("requestsWaiting").child(request.requestId).set(request.requestId);
      setState(() {
        doneReq[0]=true;
      });
      try{
        // DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("data").child("user").child(request.userId);
        // databaseReference.child("requestsWaiting").child(request.requestId).set(request.requestId);
        setState(() {
          doneReq[0]=true;
        });

      }on FirebaseException catch (e) {
        setState(() {
          doneReq[0]=false;

        });
        // make it explicit that a SocketException will be thrown if the network connection fails
        rethrow;
      }
   }
  addRequestToTheTableOfTheSani3(Requests request){
     try{
       DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("data").child("snai3").child(request.sanayeeId);
       databaseReference.child("requestsWaiting").child(request.requestId).set("${request.requestId}(VS)NEW");
       setState(() {
         doneReq[1]=true;

       });
     }on FirebaseException catch (e) {
       // make it explicit that a SocketException will be thrown if the network connection fails
       setState(() {
         doneReq[1]=false;

       });
     }

   }
  addRequestToTheTableOfTheRequests(Requests request){
     try{
       DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("data").child("requests").child(request.requestId);
       databaseReference.child("requestId").set(request.requestId);
       databaseReference.child("userId").set(FirebaseAuth.instance.currentUser?.uid.toString());
       databaseReference.child("sanayeeId").set(request.sanayeeId);
       databaseReference.child("userLoc").set(request.userLoc);
       databaseReference.child("userPhone").set(request.userPhone.toString());
       databaseReference.child("lat").set(request.lat);
       databaseReference.child("long").set(request.long);
       databaseReference.child("selectedService").set(request.selectedService);
       databaseReference.child("category").set(request.category);
       databaseReference.child("selectedMonth").set(request.selectedMonth);
       databaseReference.child("selectedDay").set(request.selectedDay);
       databaseReference.child("selectedDayName").set(request.selectedDayName);
       databaseReference.child("selectedTime").set(request.selectedTime);
       databaseReference.child("description").set(request.description);
       databaseReference.child("state").set(request.state);
       databaseReference.child("isArrived").set(request.isArrived);
       setState(() {
         doneReq[2]=true;
       });
     }on FirebaseException catch (e) {
       // make it explicit that a SocketException will be thrown if the network connection fails
       setState(() {
         doneReq[2]=false;

       });
     }

  }
  loading() {
     return Align(
       alignment: Alignment.center,
       child: LoadingIndicator(
           indicatorType: Indicator.circleStrokeSpin, /// Required, The loading type of the widget
           colors:  [secColor,firstColor],       /// Optional, The color collections
           strokeWidth: 5,                     /// Optional, The stroke of the line, only applicable to widget which contains line
           pathBackgroundColor: Colors.white   /// Optional, the stroke backgroundColor
       ),
     );
   }
  Future<void> _dialogBuilder(BuildContext context) {
     return showDialog<void>(
         context: context,
         builder: (BuildContext context) {
           return  Align(
             alignment: Alignment.center,
             child: LoadingIndicator(
                 indicatorType: Indicator.ballScale, /// Required, The loading type of the widget
                 colors:  [firstColor],       /// Optional, The color collections
                 strokeWidth: 5,                     /// Optional, The stroke of the line, only applicable to widget which contains line
                 pathBackgroundColor: Colors.white   /// Optional, the stroke backgroundColor
             ),
           );
         },
       );


   }
  Future<void> _dialogErorr(BuildContext context) {
     return showDialog<void>(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: const Text('Connection Error'),
           content: const Text('something went wrong!!\ncheck your connection and try again'),
           actions: <Widget>[

             TextButton(
               style: TextButton.styleFrom(
                 textStyle: Theme.of(context).textTheme.labelLarge,
               ),
               child: const Text('Ok'),
               onPressed: () {
                 Navigator.of(context).pop();
               },
             ),
           ],
         );
       },
     );
   }


}