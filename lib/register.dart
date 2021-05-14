import 'package:flutter/material.dart';

import 'DialogBox/errorDialog.dart';
import 'HomeScreen.dart';
import 'Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'globalVar.dart';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _phoneConfirmController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 10.0,),
              Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                ),
              ),
              SizedBox(height: 8.0,),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CustomTextField(
                      data: Icons.person,
                      controller: _nameController,
                      hintText: 'Name',
                      isObscure: false,
                    ),
                    CustomTextField(
                      data: Icons.email,
                      controller: _emailController,
                      hintText: 'Email',
                      isObscure: false,
                    ),
                    CustomTextField(
                      data: Icons.lock,
                      controller: _passwordController,
                      hintText: 'Password',
                      isObscure: true,
                    ),
                    CustomTextField(
                      data: Icons.lock,
                      controller: _passwordConfirmController,
                      hintText: 'Confirm Password',
                      isObscure: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width*.5,
                child: ElevatedButton(
                  onPressed: () {
                    _register();
                  },
                  child: Text('Sign up', style: TextStyle(color: Colors.cyan),),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          )
      ),
    );
  }

  void saveUserData(){
    Map<String, dynamic> userData={
      'userName' : _nameController.text.trim(),
      'uId': userId,
      'time': DateTime.now(),
    };

    FirebaseFirestore.instance.collection('users').doc(userId).set(userData);
  }


  void _register() async{
    User currentUser;

    await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    ).then((auth){
      currentUser = auth.user;
      userId = currentUser.uid;
      userEmail = currentUser.email;
      getUserName = _nameController.text.trim();

      saveUserData();

    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (con){
        return ErrorAlertDialog(
          message: error.message.toString(),
        );
      });
    });

    if(currentUser != null){
      Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, newRoute);
    }
  }




}
