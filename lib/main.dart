// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maintenanceservices/login.dart';
import 'package:maintenanceservices/Part2/home.dart';
import 'package:maintenanceservices/splashScreen.dart';
final Color firstColor =Color.fromRGBO(37, 62, 116,1);
final Color secColor =  Color.fromRGBO(224, 122, 95, 1);

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : Splash(),
      debugShowCheckedModeBanner: false,
    );
  }

}