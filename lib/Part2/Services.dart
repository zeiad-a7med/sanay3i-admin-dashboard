
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../main.dart';
import 'pickdate.dart';
import 'selected.dart';
import 'Home.dart';
import 'orderdetails.dart';
import '../cards/servicescard.dart';

class Services extends StatefulWidget {

  dynamic cat;
  Services(this.cat);


  @override
  State<Services> createState() => _ServicesState(cat);
}

class _ServicesState extends State<Services> {
  dynamic cat;
  int changeState=0;
  dynamic catImage;
  _ServicesState(this.cat);
  dynamic services=[];
  getAllServices() async {
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('data/category/${cat}');
    starCountRef.onValue.listen((DatabaseEvent event) {
      dynamic values = event.snapshot.value;
      if(values["services"]!=null){
        for(int i=0;i<values["services"]!.length;i++){
          services.add(
            new ServicesCard("${values["services"][i]}" ,false),
          );
        }
      }

      setState(() {
        changeState=1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String assetName = 'images/skill.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
    );
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
                    Text("There Is No Services Available",style: TextStyle(color: Colors.grey,fontSize: 25),)
                  ],
                ),
              )
          ),
        )
      ],
    );
    if(changeState==0){
      getAllServices();
    }
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        leading: new IconButton(
          icon:Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: (){
            Navigator.of(context).pop();
          }
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width:40 ,
              height:40 ,
              child: svg,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Online Maintnance Services',
              style: TextStyle(color: Colors.white , fontSize: 15),
            ),
          ],
        ),
        backgroundColor: firstColor, //<-- SEE HERE
      ),
      body:  (services.length==0)?Center(child:noDataFound ,):SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:Column(
          children: [
            SizedBox(height: 20,),

            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 15),
                child: Text("Choose your Services" , style: TextStyle(fontSize: 25))
            ),

            Divider(),

            for(int i=0;i<services.length;i++)
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: (){
                    setState(() {
                      if(services[i].isChecked()==true){
                        dynamic x=new ServicesCard(services[i].getService(), false);
                        services[i]=x;
                      }else{
                        dynamic x=new ServicesCard(services[i].getService(), true);
                        services[i]=x;
                      }
                    });
                  },
                  child:services[i]
              ),

            SizedBox(height: 15,),
            ElevatedButton(onPressed: (){
              List<String>selectedServices=[];
              for(int i=0;i<services.length;i++){
                if(services[i].isChecked()==true){
                  selectedServices.add(services[i].getService());
                }
              }
              if(selectedServices.length!=0){
                Navigator.push(context, new MaterialPageRoute(builder: (context)=>new PickDate("iconImg",cat,selectedServices),));
              }


            }, child:Text("Add" , style: TextStyle(fontSize: 20),) , style: ElevatedButton.styleFrom(
              primary: secColor,
              fixedSize:Size(80, 50),
            ), ),

            SizedBox(height: 30,),

          ],

        ),
      )
    );
  }
}
