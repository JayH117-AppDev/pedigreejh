import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'DialogBox/errorDialog.dart';
import 'HomeScreen.dart';
import 'Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_api.dart';
import 'functions.dart';
import 'globalVar.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  FirebaseAuth auth = FirebaseAuth.instance;

  String userName = " ";
  String userNumber = " ";
  String petPrice = " ";
  String petType = " ";
  String petBreed = " ";
  String description = " ";
  String urlImage = " ";
  String petLocation = " ";
  String chip = " ";
  String fileUrl = " ";
  QuerySnapshot pets;

  File file;
  UploadTask task;

  petMethods petObj = new petMethods();

  static final List<String> petsList = ['Choose a Pet Type','Dog', 'Cat', 'Horse', 'Cattle', 'Avian', 'Marine', 'Exotic', 'Other'];

  static final List<String> currencies = ['Euro', 'Pound'];
  String curr;
  String initial = petsList.first;
  String initialCurr = currencies.first;




  @override
  Widget build(BuildContext context) {

    final fileName = file != null ? basename(file.path) : 'No File Selected';

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.amber,
                  Colors.red[300],
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text(("Post an ad"),),
        centerTitle: !kIsWeb && (Platform.isIOS || Platform.isAndroid) ? false : true,
      ),
      body:Padding(

        padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: (
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter your Name'),
                    onChanged: (value) {
                      this.userName = value;
                    },
                  ),
                  SizedBox(height: 4.0),
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
                  DropdownButton<String>(
                    isExpanded: true,
                    value: initialCurr,
                    items: currencies.map((item) => DropdownMenuItem(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      value: item,
                    )).toList(),
                    onChanged: (value) => setState((){
                      this.initialCurr = value;
                      this.curr = value;
                    }) ,
                  ),
                  SizedBox(height: 5.0),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: initial,
                    items: petsList.map((item) => DropdownMenuItem(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      value: item,
                    )).toList(),
                    onChanged: (value) => setState((){
                      this.initial = value;
                      this.petType = value;
                    }) ,
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
                    decoration: InputDecoration(hintText: 'Enter chip number (where applicable)'),
                    onChanged: (value) {
                      this.chip = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Text(
                        "Upload an Image",
                      ),
                      onPressed: (){
                        selectFile();
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    fileName,
                    style: TextStyle(fontSize: 8, fontFamily: "Bebas", fontWeight: FontWeight.w500),
                  ),
                  ElevatedButton(
                    child: Text(
                      "Post your ad",
                    ),
                    onPressed: (){
                      uploadFile();
                      showAlertDialog();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Text(
                        "Cancel",
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      },
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );

  }

  Future<void> showAlertDialog() async{
    return showDialog(
        context: this.context,
        barrierDismissible: true,
        builder: (context){
          return AlertDialog(
            title: Text('Post Successful'),
            content: Text('Your ad has been successfully posted'),
            actions: <Widget>[
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }


  Future selectFile() async{

    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    final path = result.files.single.path;


    setState(() {
      file = File(path);
    });
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file.path) + DateTime.now().toString();
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file);

    if (task == null) return;

    final snapshot = await task.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    fileUrl = urlDownload;

    if(this.curr == 'Euro'){
      this.curr = '€';
    }
    else{
      this.curr = '£';
    }

    Map<String, dynamic> petData ={
      'userName': this.userName,
      'uId': userId,
      'userNumber': this.userNumber,
      'petPrice': this.curr+this.petPrice,
      'petType': this.petType,
      'petBreed': this.petBreed,
      'petLocation': this.petLocation,
      'description': this.description,
      'urlImage': this.fileUrl,
      'imgPro': userImageUrl,
      'chip' : this.chip,
      'time': Timestamp.now(),
    };
    petObj.addData(petData).then((value){
      print("Data added successfully");
    }).catchError((onError){
      print(onError);
    });

    print('Download link: ' + urlDownload);
    print('fileUrl: ' + fileUrl);

  }
}
