import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:maintenanceservices/main.dart';
import '../Part2/Home.dart';

class ServicesCard extends StatelessWidget {
  dynamic servicesname ,checked ;

  ServicesCard(this.servicesname,this.checked);
  @override
  isChecked(){
    return checked;
  }

  getService(){
    return servicesname;
  }
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text("$servicesname"),
        subtitle: Text(""),
        secondary: Icon(Icons.flag ,color:secColor,),
        isThreeLine: true,
        selected: checked,
        activeColor: firstColor,
        value: checked,
      enabled: false,
      onChanged: (bool? value) {
          checked=true;
      },
    );
  }

}

