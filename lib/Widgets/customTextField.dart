import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class CustomTextField extends StatelessWidget {

  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObscure = true;

  CustomTextField({Key key, this.controller, this.data, this.hintText, this.isObscure,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    double _screenwidth = MediaQuery
        .of(context)
        .size
        .width,
        _screenHeight = MediaQuery
            .of(context)
            .size
            .height;


    return Container(
      width: !kIsWeb && (Platform.isIOS || Platform.isAndroid) ? _screenwidth : _screenwidth *.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            prefixIcon: Icon(
              data,
              color: Colors.cyan,
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: hintText
        ),
      ),
    );
  }
}