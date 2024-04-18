import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class Tools {

  showDialoge(context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (sa) {
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
                // CircularProgressIndicator(backgroundColor: Colors.black,color: Colors.white,),
                // CircularProgressIndicator(),
                LinearProgressIndicator(backgroundColor: firstColor ,color: Colors.white,minHeight: 20,),
                SizedBox(
                  height: 15,
                ),
                // Some text
                Text("loading...",style: TextStyle(fontSize: 20),) ,
              ],
            ),
          ),
        );
      }
    );
  }

  delay(function()){
    Future.delayed(Duration(milliseconds: 5000) , () {
      function();
    });
  }

  jsonStringToMap(String data){
    List<String> str = data.replaceAll("{","").replaceAll("}","").replaceAll("\"","").replaceAll("'","").split(",");
    Map<String,dynamic> result = {};
    for(int i=0;i<str.length;i++){
      List<String> s = str[i].split(":");
      if(s[0].contains("Photo")) {
        if(s[0].trim() != "null")
          result.putIfAbsent(s[0].trim() , () => s[1].trim() +":"+ s[2].trim());
      }
      else if(s[0].contains("image")||s[0].contains("player2clubImage")||s[0].contains("player1clubImage") ) {
        if(s[0].trim() != "null") {
          try{
            String imageLink = s[1].trim() +":"+ s[2].trim() ;
            result.putIfAbsent(s[0].trim(), () => s[1].trim() +":"+ s[2].trim());
          }catch(e){
          }
        }
      } else {
        try {
          if (s[0].trim() != "null" && s[1].trim() != "") {
            result.putIfAbsent(s[0].trim(), () => s[1].trim());
          }
        }catch(ex){

        }
      }
    }
    return result;
  }

  getIconButton(String path, ONPressed) {
    return (
      Container(
        margin: new EdgeInsets.all(15.0),
        child: (
          IconButton(
            icon: Image.asset(path, width: 100, height: 100),
            padding: new EdgeInsets.all(0.0),
            onPressed: ONPressed
          )
        ),
      )
    );
  }

  check(context , secondPage , text){
    return
      Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Phudu" ,
                  color: firstColor,
                ),
              ),
              margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
            ),
            Text(" "),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
              child: InkWell(
                onTap: () {
                  goToAnotherActivity(context, secondPage);
                },
                child: Text(
                  "Click Here",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Phudu" ,
                  ),
                ),
              ),
            )
          ],
        )
     );
  }

  disposeDialog(context){
    Navigator.of(context).pop();
  }

  getTextFailed(TextEditingController controller, String hint, Icon icon , keyboardType , flag) {
    return (
      Container(
        margin: EdgeInsets.all(10),
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          keyboardType: keyboardType ,
          controller: controller,
          enabled: flag,
          decoration: getEditTextDecoration(hint, icon),
          validator: (val) {
            if (hint.compareTo("password") != 0 && val!.length > 100) {
              return ("this failed can't be larger than 100 latter");
            }
            else if (hint.compareTo("username") == 0 && val!.length < 5) {
              return ("this failed can't be less than 5 latter");
            }
            else if (hint.compareTo("email") == 0 &&
                (!val!.contains("@") || !val!.contains(".com"))) {
              return ("should be identical to example@XXX.com");
            }
            else if (val!.length < 8) {
              return ("this failed can't be less than 8 latter");
            }
            return null;
          },
        ),
      )
    );
  }

  getScureTextFailed(TextEditingController controller, String hint, Icon icon , keyboardType , flag) {
    return (
      Container(
        margin: EdgeInsets.all(10),
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          keyboardType: keyboardType ,
          controller: controller,
          enabled: flag,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: getEditTextDecoration(hint, icon),
        ),
      )
    );
  }

  InputDecoration getEditTextDecoration(String hint, Icon icon) {
    return (
      new InputDecoration(
        suffixStyle: TextStyle(fontSize: 20.0, color: Colors.redAccent) ,
        prefixIcon: icon,
        fillColor: Colors.white,
        hintStyle: TextStyle(fontSize: 20.0, color: Colors.redAccent),
        filled: false,
        hintText: hint,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      )
    );
  }

  getMultilineTextFailed(TextEditingController controller, String hint, Icon icon , keyboardType , ) {
    return (
      Container(
        margin: EdgeInsets.all(10),
        child: TextFormField(
          style: TextStyle(color: Colors.white,),
          keyboardType: keyboardType ,
          controller: controller,
          maxLines: null ,
          decoration: getEditTextDecoration(hint, icon),
          validator: (val) {
            if (val!.length >= 1) {
              return ("Please Add Your Quotation");
            }
            return null;
          },
        ),
      )
    );
  }

  goToAnotherActivity(context , secondPage){
    Navigator.pushReplacement( context , new MaterialPageRoute(builder: (context) => secondPage) );
  }

  getElevatedButton(onPressed, String text) {
    return
      Container(
        margin: EdgeInsets.all(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40) ,
          ),
          onPressed: onPressed ,
          child: Text(text,style: TextStyle(fontSize: 20 ))
        ),
      );

  }

  getAwesomeDialog(context , TEXT , title , onOk ) {
    return (
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO_REVERSED,
        borderSide: const BorderSide(
          color: Colors.green,
          width: 2,
        ),
        width: 280,
        buttonsBorderRadius: const BorderRadius.all(
          Radius.circular(2),
        ),
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        onDissmissCallback: (type) {},
        headerAnimationLoop: false,
        animType: AnimType.BOTTOMSLIDE,
        title: title,
        desc: TEXT ,
        showCloseIcon: true,
        btnCancelOnPress: () {},
        btnOkOnPress: onOk,
      )..show()
    );
  }

}