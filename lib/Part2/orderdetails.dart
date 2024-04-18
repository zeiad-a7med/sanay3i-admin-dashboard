import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../Models/ordertime.dart';
import '../main.dart';
import 'findsanayee.dart';
import 'maps.dart';
class OrderDetails extends StatefulWidget{
  String iconImg="";
  String category="";
  OrderTime orderTime;
  dynamic selectedService,userLoc;



  OrderDetails(this.iconImg,this.category,this.selectedService,this.orderTime,);
  @override
  State<OrderDetails> createState() => _OrderDetailsState(iconImg,category,selectedService,orderTime);
}

class _OrderDetailsState extends State<OrderDetails> {
  String iconImg="";
  String category="";
  String userLoc="";
  String description="";
  OrderTime orderTime;


  dynamic selectedService;

  _OrderDetailsState(this.iconImg,this.category,this.selectedService,this.orderTime);
  @override
  Widget build(BuildContext context) {
    if(userLoc==""){
      getUserLocation();
    }
    TextEditingController desc=new TextEditingController();
    MediaQueryData deviceInfo = MediaQuery.of(context);
    double ScreenWidth= deviceInfo.size.width;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50, // Set this height
          leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
            onPressed:() => Navigator.pop(context, false),
          ),
          title: Text("Order Details"),
          backgroundColor: firstColor,
        ),
        body: Center(
            child:Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10,5, 10, 5),
                      child:Column(
                        children: [
                          Container(
                            width:ScreenWidth,
                            height: 50,
                            child: Row(
                              children: [
                                Icon(Icons.home,color: secColor,size: 30,),
                                Padding(
                                    padding:EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text("Curret Location",style: TextStyle(color:Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: ScreenWidth,
                            height: 50,
                            child: Text("${userLoc}"),
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
                                      onPressed:(){
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => Services(category, iconImg, userLoc)));
                                      },
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
                                                  for(int i=0;i<selectedService.length;i++)
                                                    Align(
                                                    alignment: Alignment.centerLeft,
                                                      child: Padding(
                                                          padding:EdgeInsets.fromLTRB(5, 10, 0, 5),
                                                          child:Row(
                                                            children: [
                                                              Icon(Icons.circle,color: Colors.black,size: 15),
                                                              Expanded(child: Text("${selectedService[i]}",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w400),softWrap: false,
                                                                maxLines: 1,
                                                                overflow: TextOverflow.fade,))

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
                                           onPressed:(){
                                             Navigator.pop(context, false);
                                           },
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
                                               Expanded(
                                                 child: Container(
                                                   width:ScreenWidth/4-10,
                                                   height:55,
                                                   child: Align(
                                                     alignment: Alignment.centerLeft,
                                                     child:Text("${orderTime.SelectedDayName},${orderTime.SelectedDay} ${orderTime.SelectedMonth}",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w400),) ,
                                                   ),
                                                 ),
                                               ),

                                               Container(
                                                 width:50,
                                                 height:55,
                                                 child: Align(
                                                   alignment: Alignment.centerRight,
                                                   child:Icon(Icons.arrow_forward_ios,color: Colors.grey,) ,
                                                 )
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
                                           onPressed:(){
                                             Navigator.pop(context, false);
                                           },
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
                                                   child:Text("${orderTime.SelectedTime}:00",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w400),) ,
                                                 ),
                                               ),

                                               Expanded(
                                                 child: Container(
                                                     width:50,
                                                     height:55,
                                                     child: Align(
                                                       alignment: Alignment.centerRight,
                                                       child:Icon(Icons.arrow_forward_ios,color: Colors.grey,) ,
                                                     )
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
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child:Text("add more details",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 17),)
                    ),
                    Container(
                      width: ScreenWidth,
                      height: 1,
                      color: Colors.grey.shade500,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child:TextField(
                        maxLines: 10,
                        controller: desc,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText:"Enter Description",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: 80,
                        width:ScreenWidth
                    ),
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
                            child:(userLoc=="")?null:ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: secColor, //background color of button
                                  shape: RoundedRectangleBorder( //to set border radius to button
                                      borderRadius: BorderRadius.circular(5)
                                  ), //content padding inside button
                                ),
                                onPressed: (){
                                  description=desc.text;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => FindSanayee(category,userLoc,selectedService,orderTime,description)));
                                },
                                child: Text("Find Industrial",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w400),)
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
  getUserLocation() async {//call this async method from whereever you need
    Position position = await Geolocator.getCurrentPosition();
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457
    await getStreetName(position.latitude,position.longitude);
  }
  Future<void> getStreetName(double latitude, double longitude) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude,longitude);
    Placemark place1 = placemarks[0];
    Placemark place2 = placemarks[1];
    userLoc = "${place1.name} ${place2.name} ${place1.subLocality}${place1.subAdministrativeArea}";
    setState(() {

    });
  }

}