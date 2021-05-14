import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedigreejh/authenticationScreen.dart';

import 'dart:io' show Platform;

import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer(){
    Timer(Duration(seconds: 3), () async{
      if(FirebaseAuth.instance.currentUser != null){
        Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      }
      else {
        Route newRoute = MaterialPageRoute(builder: (context) => AuthenticationScreen());
        Navigator.pushReplacement(context, newRoute);
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(colors: [
                  Colors.red[300],
                  Colors.amberAccent,
                ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 0.0],
                    tileMode: TileMode.clamp
                )
            ),
            child: Center(
                child: Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20.0,),
                      Text(
                        "Pedigree Pet Finder",
                        style: TextStyle(fontSize: !kIsWeb && (Platform.isIOS || Platform.isAndroid) ? 20.0 : 60.0, color: Colors.black, fontFamily: "Lobster"),
                      )
                    ]
                )
            )
        )
    );
  }
}
