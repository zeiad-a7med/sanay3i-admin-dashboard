import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:maintenanceservices/Part2/myorders.dart';
import 'package:maintenanceservices/Part2/startOrder.dart';

import '../Models/Requests.dart';
import '../FirebaseRealtime.dart';
import '../main.dart';
//import 'package:sanayee/donerequest.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class CurrentOrder extends StatefulWidget{
  Requests request;
  CurrentOrder(this.request);

  @override
  State<CurrentOrder> createState() => _CurrentOrderState(request);
}

class _CurrentOrderState extends State<CurrentOrder> {
  Requests request;

  bool openDoor=false;
  dynamic email,pass,img,phone,status,sanayeeCategory,sanayeeName,lat,long;
  int changestate=0;
  List<Marker> markers=[

  ];
  List<Circle> circles=[

  ];
  getSanayeeData() async {
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('data/snai3/${request.sanayeeId}');

    await starCountRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
      sanayeeName     =data!["snayname"];
      sanayeeCategory =data["category"];
      status          =data["status"];
      lat             =data["lat"];
      long            =data["long"];
      img             =data["profilephoto"]["path"];
      email           =data["email"];
      phone           =data["phonenumber"];
      markers.add(
          Marker(
            onTap: (){
            },
            markerId: MarkerId("0"),
            position: LatLng(lat,long),
            infoWindow: InfoWindow(
              title: "${sanayeeName}",
            ),
            icon: BitmapDescriptor.defaultMarker,
          )

      );
      circles.add(
          Circle(
              onTap: () {},
              circleId: CircleId("0"),
              center:LatLng(lat,long),
              fillColor:Colors.blue.withOpacity(0.3),
              radius: 800,
              strokeWidth: 2,
              strokeColor: Colors.orange
          )

      );
      setState(() {
        changestate=1;
      });


    });

  }

  getData() async {
    await getSanayeeData();
  }

  _CurrentOrderState(this.request);
  @override
  Widget build(BuildContext context) {


    if(changestate==0){
      getData();
    }

    MediaQueryData deviceInfo = MediaQuery. of(context);
    double ScreenWidth= deviceInfo.size.width;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50, // Set this height
          leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
            onPressed:() => Navigator.pop(context, false),
          ),
          title: Text("Current Order"),
          backgroundColor: firstColor,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FlutterPhoneDirectCaller.callNumber("${phone}");
          },
          child: Icon(Icons.phone),
          backgroundColor: secColor,
        ),
        body: (changestate==0)?null:Center(
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
                                                    Text("Order",style: TextStyle(color: Colors.grey),),
                                                    Text("${request.isArrived}",style: TextStyle(color: Colors.green),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height:40,

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
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child:Text("Order Details",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 17),)
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10,5, 10, 20),
                      child:Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Padding(
                              padding:EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text("${request.category}",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10,5, 10, 5),
                        child:Column(
                          children: [
                            Container(
                              width:ScreenWidth,
                              height: 50,
                              child: Row(
                                children: [
                                  Icon(Icons.home,color: Colors.orange,size: 30,),
                                  Padding(
                                      padding:EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text("Current Location",style: TextStyle(color:Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: ScreenWidth,
                              height: 50,
                              child: Text("${request.userLoc}"),
                            ),
                            Container(
                              width: ScreenWidth,
                              child: Align(
                                alignment: Alignment.center,
                                child:SizedBox(
                                    width:ScreenWidth-20 , //width of button
                                    child:ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(0),
                                          primary: Colors.grey.shade200, //background color of button
                                          shape: RoundedRectangleBorder( //to set border radius to button
                                              borderRadius: BorderRadius.circular(5)
                                          ), //content padding inside button
                                        ),
                                        onPressed:null,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: ScreenWidth-80,
                                              constraints: BoxConstraints(
                                                minHeight: 60, //minimum height
                                              ),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child:Column(
                                                  children: [
                                                    for(int i=0;i<request.selectedService.length;i++)
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Padding(
                                                            padding:EdgeInsets.fromLTRB(5, 10, 0, 5),
                                                            child:Row(
                                                              children: [
                                                                Icon(Icons.circle,color: Colors.black,size: 15),
                                                                Text("${request.selectedService[i]}",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w400),softWrap: false, maxLines: 1, overflow: TextOverflow.fade,)
                                                              ],
                                                            )
                                                        ),
                                                      )


                                                  ],
                                                ) ,
                                              ),
                                            ),
                                            Container(
                                              width:40,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child:Icon(Icons.arrow_forward_ios,color: Colors.grey,) ,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    )
                                )
                                ,
                              ),
                            ),
                            Container(
                              width: ScreenWidth,
                              height:60,
                              child: Align(
                                  alignment: Alignment.center,
                                  child:Row(
                                    children: [
                                      SizedBox(
                                          height:55, //height of button
                                          width:ScreenWidth/2-10 , //width of button
                                          child:ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.all(0),

                                                primary: Colors.grey.shade200, //background color of button
                                                shape: RoundedRectangleBorder( //to set border radius to button
                                                    borderRadius: BorderRadius.circular(5)
                                                ), //content padding inside button
                                              ),
                                              onPressed:null,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width:50,
                                                    height:55,
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child:Icon(Icons.date_range,size: 20,color: Colors.black,) ,
                                                    ),
                                                  ),
                                                  Container(
                                                    width:ScreenWidth/4-10,
                                                    height:55,
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child:Text("${request.selectedDayName},${request.selectedDay} ${request.selectedMonth}",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w400),) ,
                                                    ),
                                                  ),


                                                ],
                                              )
                                          )
                                      ),
                                      SizedBox(
                                          height:55, //height of button
                                          width:ScreenWidth/2-10 , //width of button
                                          child:ElevatedButton(

                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.all(0),

                                                primary: Colors.grey.shade200, //background color of button
                                                shape: RoundedRectangleBorder( //to set border radius to button
                                                    borderRadius: BorderRadius.circular(5)
                                                ), //content padding inside button
                                              ),
                                              onPressed:null,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width:50,
                                                    height:55,
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child:Icon(Icons.access_time_filled,size: 20,color: Colors.black,) ,
                                                    ),
                                                  ),
                                                  Container(
                                                    width:ScreenWidth/4-10,
                                                    height:55,
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child:Text("${request.selectedTime}:00",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w400),) ,
                                                    ),
                                                  ),


                                                ],
                                              )
                                          )
                                      ),
                                    ],
                                  )

                              ),
                            ),
                          ],
                        )
                    ),
                    (request.description=="")?Text(""):Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child:TextField(
                        maxLines: 5,
                        onChanged: null,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText:"${request.description}",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width:ScreenWidth,
                      height: 50,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child:Container(
                      width:ScreenWidth,
                      height:70,
                      child:(openDoor||request.isArrived=="Verified")?Align(
                          alignment: Alignment.topCenter,
                          child:Container(
                            width: ScreenWidth/1.7,
                            height: 60,
                            child:ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green, //background color of button
                                  shape: RoundedRectangleBorder( //to set border radius to button
                                      borderRadius: BorderRadius.circular(5)
                                  ), //content padding inside button
                                ),
                                onPressed: () async {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartOrder(request)));

                                },
                                child: Text("Open The Door",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w400),)
                            ),
                          )
                      ):Align(
                          alignment: Alignment.topCenter,
                          child:Container(
                            width: ScreenWidth/1.7,
                            height: 60,
                            child:ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, //background color of button
                                  shape: RoundedRectangleBorder( //to set border radius to button
                                      borderRadius: BorderRadius.circular(5)
                                  ), //content padding inside button
                                ),
                                onPressed: () async {
                                  new FirebaseRealtime().changeChild('data/requests/${request.requestId}/isArrived', "Veryfing");
                                  showDialoge(context);

                                  setState(() {
                                  });
                                },
                                child: Text("Verify the identity",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w400),)
                            ),
                          )
                      )
                  ),
                )

              ],
            )
        )
    );
  }
  void showDialoge(context){
    dynamic sa;
    final mainRef=FirebaseDatabase.instance.ref('data/requests/${request.requestId}/isArrived');
    mainRef.onValue.listen((DatabaseEvent event){
      if(event.snapshot.value=="Verified"){
        Navigator.pop(sa);
        setState(() {
          openDoor=true;
          request.isArrived="Verified";
        });
      }

    });
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext s) {
          sa=s;
          return Dialog(
            backgroundColor: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 0,
                  ),
                  LinearProgressIndicator(backgroundColor: firstColor ,color: Colors.white,minHeight: 20,),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text("Don't Open Until verifying...",style: TextStyle(fontSize: 20),) ,
                ],
              ),
            ),
          );
        }
    );
  }

}