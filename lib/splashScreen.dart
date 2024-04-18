import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:maintenanceservices/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'Part2/Home.dart';
import 'login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'main.dart';
class Splash extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // Will print error messages to the console.
    final String assetName = 'images/skill.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
    );
    MediaQueryData deviceInfo = MediaQuery.of(context);
    double ScreenWidth= deviceInfo.size.width;
    // TODO: implement build
    return AnimatedSplashScreen(
      nextScreen: getRout(),//redirect page
      duration: 2000,
      backgroundColor: firstColor,
      splash:Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: ScreenWidth,
              height: (deviceInfo.size.height)*2/3,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: svg
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: ScreenWidth,
              height: (deviceInfo.size.height)/3,
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "O",
                      style: TextStyle(fontSize: 120,color: secColor,fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "M",
                      style: TextStyle(fontSize: 75,color: Colors.white,fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "S",
                      style: TextStyle(fontSize: 75,color: Colors.white,fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      splashIconSize: deviceInfo.size.height,
      pageTransitionType: PageTransitionType.theme, //shape it goes to next page
      splashTransition: SplashTransition.fadeTransition,//shape the image appears with
    );
  }
  getRout(){
    if(FirebaseAuth.instance.currentUser == null){
      return login();
    }else{
      return HomePage();
    }
  }

}