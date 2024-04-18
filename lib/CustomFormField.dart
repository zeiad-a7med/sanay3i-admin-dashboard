import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';
class CustomFormField extends StatelessWidget {
  CustomFormField({
    Key? key,
    required this.hintText,
    this.inputFormatters,
    this.iconButton,
    this.obscureText,
    this.textInputType ,
    this.enabled ,
    this.validator,
    this.inputDecoration,
    required this.controller ,
    this.icon,
  }) : super(key: key);
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Icon? icon;
  final bool? obscureText;
  final bool? enabled;
  final InputDecoration ? inputDecoration ;
  final TextEditingController controller;
  final TextInputType? textInputType;
  final IconButton? iconButton;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: inputDecoration == null ? getEditTextDecoration(hintText , icon!) : inputDecoration ,
        keyboardType: textInputType ,
        obscureText: convertToBool(obscureText.toString()) ,
      ),
    );
  }
  bool convertToBool(String s){
    if(s == "true")
      return true;
    else
      return false;
  }
  InputDecoration getEditTextDecoration(String hint, Icon icon) {
    return (
      new InputDecoration(
        suffixIcon: iconButton ,
        errorStyle: TextStyle(fontSize: 12.0, color: Colors.red) ,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        prefixStyle: TextStyle(fontSize: 10.0, color: Colors.black26) ,
        suffixStyle: TextStyle(fontSize: 10.0, color: Colors.black26) ,
        prefixIcon: icon ,
        fillColor: Colors.white,
        hintStyle: TextStyle(fontSize: 15.0, color: firstColor),
        filled: false,
        hintText: hint,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: firstColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: firstColor,
            width: 2.0,
          ),
        ),
      )
    );
  }
}

// extension extString on String {
//   bool get isValidEmail {
//     final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
//     return emailRegExp.hasMatch(this);
//   }
//
//   bool get isValidName{
//     final nameRegExp = new RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
//     return nameRegExp.hasMatch(this);
//   }
//
//   bool get isValidPassword{
//     final passwordRegExp =
//     RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
//     return passwordRegExp.hasMatch(this);
//   }
//
//   bool get isNotNull{
//     return this!=null;
//   }
//
//   bool get isValidPhone{
//     final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
//     return phoneRegExp.hasMatch(this);
//   }
//
//  
//  
// }