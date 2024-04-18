//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Models/ordertime.dart';
import '../main.dart';
import 'sanayeeprofile.dart';
//import 'sanayeeprofile.dart';
//import 'servicecard.dart';

class FindSanayee extends StatefulWidget{

  dynamic category,userLoc,selectedService,description;
  OrderTime orderTime;
  FindSanayee(this.category,this.userLoc,this.selectedService,this.orderTime,this.description);
  @override
  State<FindSanayee> createState() => _FindSanayeeState(category,userLoc,selectedService,orderTime,description);
}

class _FindSanayeeState extends State<FindSanayee> {
  dynamic category,userLoc,selectedService,description;
  OrderTime orderTime;

  _FindSanayeeState(this.category,this.userLoc,this.selectedService,this.orderTime,this.description);

  List<Marker> markers=[

  ];
  List<Circle> circles=[

  ];
  dynamic lat,long;
  int changestate=0;
  dynamic sanayees;
  dynamic markIcons;
  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }


  getAllSnai3() async {
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('data/snai3');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot ;
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
      sanayees=values;
    });

  }
  getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    long = position.longitude;
    lat = position.latitude;
    circles.add(
        Circle(
            onTap: () {},
            circleId: CircleId("0"),
            center: LatLng(lat,long),
            fillColor: Color.fromRGBO(220, 134, 101, 1).withOpacity(0.3),
            radius: 7000,
            strokeWidth: 0,
            strokeColor: Colors.orange
        )
    );
  }
  getMarkers() async {
    markIcons = await getImages('image/Indust.png', 70);

    List<dynamic> colores=[
      Colors.blue.withOpacity(0.3),
      Colors.green.withOpacity(0.3)
    ];
    int i=1;
    for(var id in sanayees.keys){
      if(sanayees[id]['status']=='online'&&sanayees[id]['category']==category){
        markers.add(
            Marker(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Sanayeeprofile(id,category,userLoc,selectedService,orderTime,description,markIcons)));
              },
              markerId: MarkerId("${i}"),
              position: LatLng(
                  sanayees[id]["lat"], sanayees[id]["long"]),
              infoWindow: InfoWindow(
                title: "${sanayees[id]["snayname"]}",
              ),
              icon:BitmapDescriptor.fromBytes(markIcons),
            )
        );
        circles.add(
            Circle(
                onTap: () {},
                circleId: CircleId("${i}"),
                center: LatLng(sanayees[id]["lat"],sanayees[id]["long"]),
                fillColor: (i%2==0)?colores[0]:colores[1],
                radius: 800,
                strokeWidth: 2,
                strokeColor: Colors.orange
            )
        );
        i++;
      }
    }
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
      await getAllSnai3();
      await getLocation();
      await getMarkers();
      setState(() {
        changestate=1;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    double ScreenWidth= deviceInfo.size.width;

    if(changestate==0){
      getData();
    }

    return Scaffold(appBar: AppBar(
      toolbarHeight: 50, // Set this height
      leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
        onPressed:(){
          Navigator.pop(context, false);
        },
      ),
      title: Text("Find Your Industrial"),
      backgroundColor: firstColor,
    ),

        body: Center(
          child:Stack(
            children: [
              Center(
                child: (changestate==0)?loading():GoogleMap(

                  onMapCreated: (controller) async {

                  },
                  initialCameraPosition: CameraPosition(
                    target:LatLng(lat, long),
                    zoom: 12,
                  ),
                  markers:markers.toSet(),
                  circles: circles.toSet(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width:100,
                    height:100,
                    child:Align(
                        alignment: Alignment.topCenter,
                        child:Container(

                          width: 80,
                          height: 80,
                          child:Center(
                            child: ElevatedButton(

                                style: ElevatedButton.styleFrom(
                                  primary: firstColor, //background color of button
                                  shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                      borderRadius: BorderRadius.circular(70)
                                  ), //content padding inside button
                                ),
                                onPressed: () async {
                                  setState((){
                                    sanayees=[];
                                    circles=[];
                                    markers=[];
                                    changestate=0;
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Icon( Icons.refresh,color: Colors.white,size: 55, ),
                                  ),
                                )

                            ),
                          )
                        )
                    )
                ),
              ),
            ],
          )
        )
    );
  }

  loading() {
    return LoadingIndicator(
        indicatorType: Indicator.circleStrokeSpin, /// Required, The loading type of the widget
        colors:  [secColor,Colors.pink],       /// Optional, The color collections
        strokeWidth: 5,                     /// Optional, The stroke of the line, only applicable to widget which contains line
        pathBackgroundColor: Colors.white   /// Optional, the stroke backgroundColor
    );
  }
}