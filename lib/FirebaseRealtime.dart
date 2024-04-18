import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';

class FirebaseRealtime{
  late Map _dataOfThePath ;
  late Map _allData ;
  late String _onChild ;
  late String _url ;


  Map get allData => _allData;

  set allData(Map value) {
    _allData = value;
  }

  Map get dataOfThePath => _dataOfThePath;

  set dataOfThePath(Map value) {
    _dataOfThePath = value;
  }

  String get onChild => _onChild;

  set onChild(String value) {
    _onChild = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  getDataFromPath(String path){
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref(path);
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot ;
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
      dataOfThePath = values! ;
    });
  }

  getData(String path){
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref(path);
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot ;
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
      allData = values! ;
    });
  }

  bool deleteChild(String path){
    try{
      final ref = FirebaseDatabase.instance.ref();
      ref.child(path).remove() ;
      return true ;
    }catch(ex){
      return false ;
    }
  }

  addChildWithRandomKey(String path , String data){
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child(path);
    databaseReference.child("${Random().nextInt(100000)}${Random().nextInt(100000)}${Random().nextInt(100000)}").set(data) ;
  }

  addChildWithSpecificKey(String path , String key , String data){
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child(path);
    databaseReference.child("$key").set(data) ;
  }

  changeChild(String path , String data){
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child(path);
    databaseReference.set(data) ;
  }


  Map jsonStringToMap(String data){
    String fai = "" ;
    List<String> str = data.replaceAll("{","").replaceAll("}","").replaceAll("\"","").replaceAll("'","").split(",");
    Map<String,dynamic> result = {};
    for(int i=0;i<str.length;i++){
      List<String> s = str[i].split(":");
      try{
        result.putIfAbsent(s[0].trim() , () => s[1].trim()) ;
      }catch(ex){
        fai = "${result["selectedService"]},${s[0].trim()}" ;
        result.putIfAbsent("selectedService", () => "${result["selectedService"]},${s[0].trim()}");
      }
    }
    result["selectedService"] = fai ;
    return result;
  }


  Future<String> getOneChildFromDatabase(String path) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(path).get();
    _onChild = snapshot.value.toString() ;
    return snapshot.value.toString() ;
  }

  Future<String> uploadPhoto(String path , imgpicked , file) async {
    var random = Random().nextInt(10000000);
    var nameImage = basename(imgpicked.path);
    nameImage = "$random$nameImage";
    var refStorge = FirebaseStorage.instance.ref("$path/$nameImage");
    await refStorge.putFile(file);
    url = await refStorge.getDownloadURL();
    return url ;
  }

  bool deletePhoto(String path){
    try {
      FirebaseStorage.instance.refFromURL(path).delete();
      return true ;
    }catch(ex){
      return false ;
    }
  }

  printAllDataFromDatabase(path){
    getData(path);
    print(allData);
  }

}