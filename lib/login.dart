import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'DialogBox/errorDialog.dart';
import 'DialogBox/loadingDialog.dart';
import 'HomeScreen.dart';
import 'Widgets/customTextField.dart';
import 'package:flutter/foundation.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    data: Icons.person,
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
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width*0.5,
              child: ElevatedButton(
                onPressed: (){
                  _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty
                      ? _login()
                      : showDialog(
                      context: context,
                      builder: (con){
                        return ErrorAlertDialog(
                          message: "Please enter a username and password",
                        );
                      });
                },
                child: Text('Log in', style: TextStyle(color: Colors.cyan),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async{
    showDialog(context: context,
        builder: (con){
          return loadingAlertDialog(
            message: 'Please Wait',
          );
        });

    User currentUser;

    await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    ).then((auth){
      currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (con) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if(currentUser != null){
      Navigator.pop(context);
      Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, newRoute);
    }
    else{
      print("error");
    }

  }



}
