import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:maintenanceservices/Part2/myorders.dart';

import '../Models/Requests.dart';
import '../FirebaseRealtime.dart';
import '../main.dart';
//import 'package:sanayee/donerequest.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class StartOrder extends StatefulWidget{
  Requests request;
  StartOrder(this.request);

  @override
  State<StartOrder> createState() => _StartOrderState(request);
}

class _StartOrderState extends State<StartOrder> {
  Requests request;
  _StartOrderState(this.request);

  dynamic h,min,sec;

  dynamic header,btn;
  dynamic email,pass,img,phone,status,sanayeeCategory,sanayeeName,lat,long;
  dynamic amount;
  int changestate=0;
  int startNotification=0;
  bool isTimerStarted=false;
  TextEditingController review=new TextEditingController();
  int hours = 00;
  int minutes = 0;
  int seconds = 0;
  bool isRunning = false;
  Timer? timer;
  FirebaseRealtime fire=new FirebaseRealtime();

  void startTimer() {
    isRunning = true;
    timer = Timer.periodic(Duration(seconds:1 ), (timer) {
      setState(() {
        seconds++;
        if (seconds == 60){
          seconds = 0;
          minutes++;
        }
        if (minutes == 60) {
          minutes = 0;
          seconds=0;
          hours++;
        }
        if (hours < 0) {
          timer.cancel();
          isRunning = false;
        }
      });
    });
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
      isRunning = false;
    }
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery. of(context);
    double ScreenWidth= deviceInfo.size.width;
    if(request.isArrived=="Verified"){
      header=Align(
          alignment: Alignment.center,
          child: Container(
            height: 90,
            child: Column(
              children: [
                Text("Wait Until The Industrial", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                Text("Start The Order", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              ],
            ),
          )
      );
    }
    else if(request.isArrived=="Start"){
      header=Text('${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}', style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),);
    }
    else if(request.isArrived=="Paying"){
      header=Align(
          alignment: Alignment.center,
          child: Container(
            height: 90,
            child: Column(
              children: [
                Text("The Order Finished!", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                Text("Pay In Cach", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              ],
            ),
          )
      );
    }
    else if(request.isArrived=="Paid"){
      header=Align(
          alignment: Alignment.center,
          child: Container(
            height: 90,
            child: Column(
              children: [
                Text("Wait Until The Industrial", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                Text("Collect The Cash", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              ],
            ),
          )
      );
    }
    else if(request.isArrived=="Finished"){
      header=Text("Finish!", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),);
    }



    if(request.isArrived=="Start"){
      btn=Text("");
    }else if(request.isArrived=="Finished"){
      btn=Align(
        alignment: Alignment.bottomLeft,
        child:Container(
            width:ScreenWidth,
            height:70,
            child:Align(
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
                        AwesomeDialog(
                            context: context,
                            dismissOnTouchOutside: false,
                            body: Container(
                              height:80,
                              child: Column(
                                children: [
                                  Text("Review Our Industrial",style: TextStyle(fontSize: 20),),
                                  TextField(
                                    controller: review,
                                    decoration: InputDecoration(
                                      hintText: 'Enter a Review',
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            btnOkOnPress: () async {
                              String rev=review.text;
                              if(rev!=""){
                                new FirebaseRealtime().addChildWithRandomKey('data/snai3/${request.sanayeeId}/reviews', rev);
                                review.text="";
                                await fire.deleteChild("data/requests/${request.requestId}");
                                await fire.deleteChild("data/user/${request.userId}/requestsWaiting/${request.requestId}");
                                await fire.deleteChild("data/user/${request.userId}/notifications/${request.requestId}");
                                await fire.deleteChild("data/snai3/${request.sanayeeId}/requestsWaiting/${request.requestId}");
                                Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>MyOrders()));
                              }
                            },
                            btnCancelOnPress:() async {
                              await fire.deleteChild("data/requests/${request.requestId}");
                              await fire.deleteChild("data/user/${request.userId}/requestsWaiting/${request.requestId}");
                              await fire.deleteChild("data/user/${request.userId}/notifications/${request.requestId}");
                              await fire.deleteChild("data/snai3/${request.sanayeeId}/requestsWaiting/${request.requestId}");
                              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>MyOrders()));
                            },
                            btnOkText:"Send",
                            dialogType: DialogType.SUCCES
                        ).show();
                      },
                      child: Text("Finish The Order",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w400),)
                  ),
                )
            )
        ),
      );
    }else if(request.isArrived=="Paying"){
      btn=Align(
        alignment: Alignment.bottomLeft,
        child:Container(
            width:ScreenWidth,
            height:70,
            child:Align(
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
                        AwesomeDialog(
                            context: context,
                            dismissOnTouchOutside: false,
                            body: Container(
                              height:80,
                              child: Column(
                                children: [
                                  Text("The amount required",style: TextStyle(fontSize: 20),),
                                  Text("${amount}EGP",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)

                                ],
                              ),
                            ),
                            btnOkOnPress: (){
                              new FirebaseRealtime().changeChild('data/requests/${request.requestId}/isArrived', "Paid");
                              setState(() {
                                request.isArrived="Paid";
                              });
                              // String rev=review.text;
                              // if(rev!=""){
                              //   new FirebaseRealtime().addChildWithRandomKey('data/snai3/${request.sanayeeId}/reviews', rev);
                              //   review.text="";
                              //   Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>MyOrders()));
                              // }
                            },

                            btnOkText:"Pay",
                            dialogType: DialogType.SUCCES
                        ).show();
                      },
                      child: Text("Pay In Cash",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w400),)
                  ),
                )
            )
        ),
      );
    }else if(request.isArrived=="Paid"){
      btn=Text("");
    }else{
      btn=Text("");
    }





    h="09";
    min="03";
    sec="13";
    if(startNotification==0){
      ListenNotification();
    }
    if(!isTimerStarted&&request.isArrived=="Start"){

    }

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50, // Set this height
          leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
            onPressed:() => Navigator.pop(context, false),
          ),
          title: Text("Start The Order"),
          backgroundColor: firstColor,
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
                                child:Center(
                                  child:header
                                )
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
                btn,

              ],
            )
        )
    );
  }
  void ListenNotification(){
    final mainRef=FirebaseDatabase.instance.ref('data/requests/${request.requestId}/isArrived');
    mainRef.onValue.listen((DatabaseEvent event){
      if(event.snapshot.value=="Start"){
          request.isArrived="Start";
          if (!isRunning) {
            startTimer();
          }
      }
      if(event.snapshot.value=="Finished"){
          request.isArrived="Finished";
          stopTimer();
      }
      if(event.snapshot.value=="Paying"){
        final mainRef=FirebaseDatabase.instance.ref('data/requests/${request.requestId}/Amount');
        mainRef.onValue.listen((DatabaseEvent event) {
          amount=event.snapshot.value;
        });
        request.isArrived="Paying";

      }
      if(event.snapshot.value=="Paid"){
        request.isArrived="Paid";
      }
      setState(() {
        startNotification=1;
        changestate=1;
      });

    });
  }

}