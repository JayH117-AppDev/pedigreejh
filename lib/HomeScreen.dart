import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedigreejh/authenticationScreen.dart';
import 'package:pedigreejh/profileScreen.dart';
import 'package:pedigreejh/searchPet.dart';
import 'package:pedigreejh/uploadPage.dart';
import 'dart:io' show File, Platform;
// import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as tAgo;

import 'functions.dart';
import 'globalVar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;

  String userName;
  String userNumber;
  String petPrice;
  String petType;
  String petBreed;
  String description;
  String urlImage;
  String petLocation;
  QuerySnapshot pets;

  File file;

  petMethods petObj = new petMethods();


  Future<bool> showDialogForUpdateData(selectedDoc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Update your ad", style: TextStyle(fontSize: 24, fontFamily: "Bebas", letterSpacing: 2.0),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Enter your Name'),
                  onChanged: (value) {
                    this.userName = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter your Phone Number'),
                  onChanged: (value) {
                    this.userNumber = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter your price'),
                  onChanged: (value) {
                    this.petPrice = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter your pet type'),
                  onChanged: (value) {
                    this.petType = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter your pet breed'),
                  onChanged: (value) {
                    this.petBreed = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter your location'),
                  onChanged: (value) {
                    this.petLocation = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter a description'),
                  onChanged: (value) {
                    this.description = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter image url'),
                  onChanged: (value) {
                    this.urlImage = value;
                  },
                ),
                SizedBox(height: 5.0),
              ],
            ),

            actions: [
              ElevatedButton(
                child: Text(
                  "Cancel",
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: Text(
                  "Update your ad",
                ),
                onPressed: (){
                  Map<String, dynamic> petData ={
                    'userName': this.userName,
                    'userNumber': this.userNumber,
                    'petPrice': this.petPrice,
                    'petType': this.petType,
                    'petBreed': this.petBreed,
                    'petLocation': this.petLocation,
                    'description': this.description,
                    'urlImage': this.urlImage,
                    'time': Timestamp.now(),
                  };
                  petObj.updateData(petData, selectedDoc).then((value){
                    print("Data updated successfully");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).catchError((onError){
                    print(onError);
                  });
                },
              )
            ],
          );
        }
    );
  }


  getMyData(){
    FirebaseFirestore.instance.collection('users').doc(userId).get().then((results){
      setState(() {
        userImageUrl = results.data()['imgPro'];
        getUserName = results.data()['userName'];
      });
    });
  }


  @override
  void initState(){
    super.initState();
    userId = FirebaseAuth.instance.currentUser.uid;
    userEmail = FirebaseAuth.instance.currentUser.email;

    petObj.getData().then((results){
      setState(() {
        pets = results;
      });
    });

    getMyData();
  }


  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery
      .of(context)
      .size
      .width,
        _screenHeight = MediaQuery
            .of(context)
            .size
            .height;

    Widget showAdsList(){
      if(pets !=null){
        return ListView.builder(
          itemCount: pets.docs.length,
          padding: EdgeInsets.all(8.0),
          itemBuilder: (context, i){
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: GestureDetector(
                      onTap: ()
                      {
                      },
                      child: Container(
                        width: 60,
                        height:60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    title: GestureDetector(
                        onTap: ()
                        {

                        },
                        child: Text(pets.docs[i]['userName'])
                    ),
                    subtitle: GestureDetector(
                      onTap: () {

                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              pets.docs[i]['petLocation'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          SizedBox(width: 4.0,),
                          Icon(Icons.location_pin, color: Colors.grey,),
                        ],
                      ),
                    ),
                    trailing:
                    pets.docs[i]['uId'] == userId ?
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 20,),
                        GestureDetector(
                            onDoubleTap: ()
                            {
                              if(pets.docs[i]['uId'] == userId){
                                petObj.deleteData(pets.docs[i].id);
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => HomeScreen()));
                              }
                            },
                            child: Icon(Icons.delete_forever_outlined)
                        )
                      ],
                    ) :Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.network(pets.docs[i]['urlImage'], fit: BoxFit.fill),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      pets.docs[i]['petPrice'],
                      style: TextStyle(
                        fontFamily: "Bebas",
                        letterSpacing: 2.0,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.workspaces_outline),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                child: Text(pets.docs[i]['petType']),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.workspaces_outline),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                child: Text(pets.docs[i]['petBreed']),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.phone),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                child: Text(pets.docs[i]['userNumber']),
                                alignment: Alignment.topRight,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                    child: Text(
                      pets.docs[i]['description'],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            );
          },
        );
      }
      else{
        return Text('Loading...');
      }
    }


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.refresh, color: Colors.black),
          onPressed: ()
          {
            Route newRoute =
            MaterialPageRoute(builder: (_) => HomeScreen());
            Navigator.pushReplacement(context, newRoute);
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed:(){
              Route newRoute =
              MaterialPageRoute(builder: (_) => SearchPet());
              Navigator.pushReplacement(context, newRoute);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.search, color: Colors.black),
            ),
          ),
          TextButton(
            onPressed:(){
              auth.signOut().then((_){
                Route newRoute =
                MaterialPageRoute(builder: (_) => AuthenticationScreen());
                Navigator.pushReplacement(context, newRoute);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.login_outlined, color: Colors.black),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(colors: [
              Colors.amber,
              Colors.red[300],
            ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text(("Home Page"),),
        centerTitle: !kIsWeb && (Platform.isIOS || Platform.isAndroid) ? false : true,
      ),
      body: Center(
        child: Container(
          width: !kIsWeb && (Platform.isIOS || Platform.isAndroid) ? _screenWidth : _screenWidth*.5,
          child: showAdsList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Post',
        child: Icon(Icons.add),
        onPressed: (){
          Route newRoute =
          MaterialPageRoute(builder: (_) => UploadPage());
          Navigator.pushReplacement(context, newRoute);
        },
      ),
    );
  }

}
