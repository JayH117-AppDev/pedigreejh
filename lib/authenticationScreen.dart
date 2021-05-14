import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedigreejh/register.dart';

import 'login.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.amber,
                        Colors.amberAccent,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp
                  ),
                ),
              ),
              title: Text(
                "Pedigree Pet Finder",
                style: TextStyle(fontSize: !kIsWeb && (Platform.isIOS || Platform.isAndroid) ? 20.0 : 50.0, color: Colors.black, fontFamily: "Lobster"),
              ),
              centerTitle: true,
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.lock, color: Colors.black,),
                    text: "Login",
                  ),
                  Tab(
                    icon: Icon(Icons.person, color: Colors.black,),
                    text: "Register",
                  ),
                ],
                indicatorColor: Colors.white38,
                indicatorWeight: 5.0,
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.amberAccent,
                    Colors.amber,
                  ],
                ),
              ),
              child: TabBarView(
                children: <Widget>[
                  Login(),
                  Register(),
                ],
              ),
            )
        ));
  }
}
